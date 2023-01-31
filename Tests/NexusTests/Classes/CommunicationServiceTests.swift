import Combine
import XCTest
@testable import Nexus

private extension String {
    static let identifier = "identifier"
}

final class CommunicationServiceTests: XCTestCase {
    // MARK: Properties

    private var watchConnectivityServiceMock: WatchConnectivityServiceMock!
    private var communicationService: ICommunicationService!

    // MARK: XCTestCase

    override func setUp() {
        super.setUp()
        watchConnectivityServiceMock = WatchConnectivityServiceMock()
        communicationService = CommunicationService(watchConnectivityService: watchConnectivityServiceMock)
    }

    override func tearDown() {
        watchConnectivityServiceMock = nil
        communicationService = nil
        super.tearDown()
    }

    // MARK: Tests

    func test_thatCommunicationServiceConfigure() {
        // given

        // when
        communicationService.configure()

        // then
        XCTAssertTrue(watchConnectivityServiceMock.invokedDelegateParameters?.delegate === communicationService)
        XCTAssertTrue(watchConnectivityServiceMock.invokedConfigure)
        XCTAssertEqual(watchConnectivityServiceMock.invokedConfigureCount, 1)
    }

    func test_thatCommunicationServiceSendMessage() throws {
        // given
        let message = MessageMock()

        // when
        communicationService.sendMessaage(message)

        // then
        let receivedMessage = try XCTUnwrap(watchConnectivityServiceMock.invokedSendMessageParameters?.message)
        XCTAssertTrue(NSDictionary(dictionary: receivedMessage).isEqual(to: makeDictonary(for: message)))
    }

    func test_thatCommunicationServiceSendMessageWithHandlers() throws {
        // given
        let message = MessageMock()
        let dict = makeDictonary(for: message)

        // when
        communicationService.sendMessage(dict, replyHandler: nil, errorHandler: nil)

        // then
        let receivedMessage = try XCTUnwrap(watchConnectivityServiceMock.invokedSendMessageParameters?.message)
        XCTAssertTrue(NSDictionary(dictionary: receivedMessage).isEqual(to: dict))
    }
    
    func test_thatCommunicationServiceCallHandler_whenRecieveMessage() {
        // given
        var cancellable = Set<AnyCancellable>()
        let expectation = XCTestExpectation(description: "Publishes one value then finishes")
        let messageMock = MessageMock()

        // when
        let publisher = communicationService.receiveMessage(MessageMock.self)

        DispatchQueue.main.async {
            NotificationCenter.default.post(name: self.makeNotificationName(for: MessageMock.identifier), object: messageMock.dictionary)
        }

        // then
        publisher
            .sink(receiveCompletion: { result in
                if case .failure = result {
                    XCTFail()
                }
            }, receiveValue: { message in
                XCTAssertTrue(NSDictionary(dictionary: self.makeDictonary(for: messageMock)).isEqual(to: self.makeDictonary(for: message)))
                expectation.fulfill()
            })
            .store(in: &cancellable)

        wait(for: [expectation], timeout: 0.5)
    }
    
    // MARK: Private

    private func makeDictonary<T: Message>(for message: T) -> [String: Any] {
        let identifierDict: [String: Any] = [.identifier: T.identifier]

        guard let messageDict = message.dictionary else {
            return identifierDict
        }

        return identifierDict.merging(messageDict) { current, _ in current }
    }

    private func makeNotificationName(for identifier: String) -> Notification.Name {
        Notification.Name("CommunicationService.\(identifier)")
    }
}
