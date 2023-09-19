//
// Nexus
// Copyright © 2023 Space Code. All rights reserved.
//

import Combine
@testable import Nexus
import XCTest

// MARK: - CommunicationServiceTests

final class CommunicationServiceTests: XCTestCase {
    // MARK: Properties

    private var watchConnectivityServiceMock: WatchConnectivityServiceMock!
    private var communicationService: ICommunicationService!
    private var delegateMock: CommunicationServiceDelegateMock!
    private var notificationCenterMock: NotificationCenterMock!

    // MARK: XCTestCase

    override func setUp() {
        super.setUp()
        delegateMock = CommunicationServiceDelegateMock()
        watchConnectivityServiceMock = WatchConnectivityServiceMock()
        notificationCenterMock = NotificationCenterMock()
        communicationService = CommunicationService(
            watchConnectivityService: watchConnectivityServiceMock,
            notificationCenter: notificationCenterMock
        )
        communicationService.delegate = delegateMock
    }

    override func tearDown() {
        watchConnectivityServiceMock = nil
        communicationService = nil
        delegateMock = nil
        notificationCenterMock = nil
        super.tearDown()
    }

    // MARK: Tests

    func test_thatCommunicationServiceConfiguresProperties() {
        // when
        communicationService.configure()

        // then
        XCTAssertTrue(watchConnectivityServiceMock.invokedDelegateParameters?.delegate === communicationService)
        XCTAssertTrue(watchConnectivityServiceMock.invokedConfigure)
        XCTAssertEqual(watchConnectivityServiceMock.invokedConfigureCount, 1)
    }

    func test_thatCommunicationServiceSendsMessage() throws {
        // given
        let message = MessageStub()

        // when
        communicationService.sendMessaage(message)

        // then
        let receivedMessage = try XCTUnwrap(watchConnectivityServiceMock.invokedSendMessageParameters?.message)
        XCTAssertTrue(NSDictionary(dictionary: receivedMessage).isEqual(to: MessageBuilderHelper.makeDictonary(for: message)))
    }

    func test_thatCommunicationServiceSendsMessageWithHandlers() throws {
        // given
        let message = MessageStub()
        let dict = MessageBuilderHelper.makeDictonary(for: message)

        // when
        communicationService.sendMessage(dict, replyHandler: nil, errorHandler: nil)

        // then
        let receivedMessage = try XCTUnwrap(watchConnectivityServiceMock.invokedSendMessageParameters?.message)
        XCTAssertTrue(NSDictionary(dictionary: receivedMessage).isEqual(to: dict))
    }

    func test_thatCommunicationServiceCallsHandler_whenMessageDidReceive() {
        // given
        var cancellable = Set<AnyCancellable>()
        let expectation = XCTestExpectation(description: "Publishes one value then finishes")
        let messageMock = MessageStub()

        notificationCenterMock.stubbedPublisherResult = NotificationCenter.Publisher(
            center: .default,
            name: makeNotificationName(for: MessageStub.identifier)
        )

        // when
        let publisher = communicationService.receiveMessage(MessageStub.self)

        DispatchQueue.main.async {
            NotificationCenter.default.post(name: self.makeNotificationName(for: MessageStub.identifier), object: messageMock.dictionary)
        }

        // then
        publisher
            .sink(receiveCompletion: { result in
                if case .failure = result {
                    XCTFail()
                }
            }, receiveValue: { message in
                XCTAssertTrue(
                    NSDictionary(
                        dictionary: MessageBuilderHelper.makeDictonary(for: messageMock)
                    )
                    .isEqual(to: MessageBuilderHelper.makeDictonary(for: message))
                )
                expectation.fulfill()
            })
            .store(in: &cancellable)

        wait(for: [expectation], timeout: .timeout)
    }

    func test_thatCommunicationServiceTriggersDelegate_whenActivationDidComplete() {
        // given
        let communicationService = communicationService as? WatchConnectivityServiceDelegate

        // when
        communicationService?.session(.default, activationDidCompleteWith: .activated, error: nil)

        // then
        XCTAssertEqual(delegateMock.invokedSessionActivationDidCompleteWithParameters?.session, .default)
        XCTAssertEqual(delegateMock.invokedSessionActivationDidCompleteWithParameters?.activationState, .activated)
        XCTAssertNil(delegateMock.invokedSessionActivationDidCompleteWithParameters?.error)
    }

    func test_thatCommunicationServiceTriggersDelegate_whenActivationFailed() {
        // given
        let communicationService = communicationService as? WatchConnectivityServiceDelegate

        // when
        communicationService?.session(.default, activationDidCompleteWith: .notActivated, error: WatchConnectivityError.sessionIsNotActive)

        // then
        XCTAssertEqual(delegateMock.invokedSessionActivationDidCompleteWithParameters?.session, .default)
        XCTAssertEqual(delegateMock.invokedSessionActivationDidCompleteWithParameters?.activationState, .notActivated)
        XCTAssertEqual(
            delegateMock.invokedSessionActivationDidCompleteWithParameters?.error as? NSError,
            WatchConnectivityError.sessionIsNotActive as NSError
        )
    }

    func test_thatCommunicationServiceTriggersDelegate_whenMessageDidReceive() {
        // given
        let communicationService = communicationService as? WatchConnectivityServiceDelegate
        let message = MessageBuilderHelper.makeDictonary(for: MessageStub())

        // when
        communicationService?.session(.default, didReceiveMessage: message)

        // then
        XCTAssertEqual(delegateMock.invokedSessionParameters?.session, .default)
        XCTAssertEqual(
            delegateMock.invokedSessionParameters?.message[MessageStub.identifier] as? String,
            message[MessageStub.identifier] as? String
        )
        XCTAssertEqual(notificationCenterMock.invokedPostCount, 1)
    }

    func test_thatCommunicationServiceTriggersDelegate_whenMessageDidReceiveWithReplyHandler() {
        // given
        let communicationService = communicationService as? WatchConnectivityServiceDelegate
        let message = MessageBuilderHelper.makeDictonary(for: MessageStub())

        // when
        communicationService?.session(.default, didReceiveMessage: message, replyHandler: { _ in })

        // then
        XCTAssertEqual(delegateMock.invokedSessionDidReceiveMessageParameters?.session, .default)
        XCTAssertEqual(
            delegateMock.invokedSessionDidReceiveMessageParameters?.message[MessageStub.identifier] as? String,
            message[MessageStub.identifier] as? String
        )
        XCTAssertEqual(notificationCenterMock.invokedPostCount, 1)
    }

    func test_thatCommunicationServiceTriggersDelegate_whenSessionDidBecomeInactive() {
        // given
        let communicationService = communicationService as? WatchConnectivityServiceDelegate

        // when
        communicationService?.sessionDidBecomeInactive(.default)

        // then
        XCTAssertEqual(delegateMock.invokedSessionDidBecomeInactiveParameters?.session, .default)
    }

    func test_thatCommunicationServiceTriggersDelegate_whenSessionDidDeactivate() {
        // given
        let communicationService = communicationService as? WatchConnectivityServiceDelegate

        // when
        communicationService?.sessionDidDeactivate(.default)

        // then
        XCTAssertEqual(delegateMock.invokedSessionDidDeactivateParameters?.session, .default)
    }

    // MARK: Private

    private func makeNotificationName(for identifier: String) -> Notification.Name {
        Notification.Name("\(String.notificationName).\(identifier)")
    }
}

// MARK: - Constants

private extension String {
    static let identifier = "identifier"
    static let notificationName = "CommunicationService"
}

private extension TimeInterval {
    static let timeout: TimeInterval = 0.5
}
