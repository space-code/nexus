//
// Nexus
// Copyright © 2023 Space Code. All rights reserved.
//

import Combine
@testable import Nexus
import WatchConnectivity
import XCTest

final class WatchConnectivityServiceTests: XCTestCase {
    // MARK: Properties

    private var watchConnectivityService: WatchConnectivityService!
    private var sessionMock: SessionMock!
    private var sessionCompatibleProviderMock: SessionCompatibleProviderMock!
    private var delegateMock: WatchConnectivityServiceDelegateMock!

    // MARK: Initialization

    override func setUp() {
        super.setUp()
        sessionMock = SessionMock()
        sessionCompatibleProviderMock = SessionCompatibleProviderMock()
        delegateMock = WatchConnectivityServiceDelegateMock()
        watchConnectivityService = WatchConnectivityService(
            session: sessionMock,
            sessionCompatibleProvider: sessionCompatibleProviderMock
        )
        watchConnectivityService.delegate = delegateMock
    }

    override func tearDown() {
        sessionMock = nil
        watchConnectivityService = nil
        sessionCompatibleProviderMock = nil
        delegateMock = nil
        super.tearDown()
    }

    // MARK: Tests

    func test_thatWatchConnectivityServiceDoesNotConfigureSession_whenConnectionIsNotSupported() {
        // given
        sessionCompatibleProviderMock.stubbedIsSupported = false

        // when
        watchConnectivityService.configure()

        // then
        XCTAssertFalse(sessionMock.invokedActivate)
    }

    func test_thatWatchConnectivityServiceConfiguresSession_whenConnectionIsSupported() {
        // given
        sessionCompatibleProviderMock.stubbedIsSupported = true

        // when
        watchConnectivityService.configure()

        // then
        XCTAssertTrue(sessionMock.invokedActivate)
    }

    func test_thatWatchConnectivityServiceSendsMessageTriggerringErrorHandler_whenActivateStatusIsNotActivated() {
        // given
        let message = MessageBuilderHelper.makeDictonary(for: MessageStub())

        sessionMock.stubbedActivationState = .notActivated

        // when
        var resultError: Error?
        watchConnectivityService.sendMessage(message, replyHandler: { _ in }, errorHandler: { error in resultError = error })

        // then
        XCTAssertEqual(resultError as? NSError, WatchConnectivityError.sessionIsNotActive as NSError)
    }

    #if os(iOS)
        func test_thatWatchConnectivityServiceSendsMessageTriggeringErrorHandler_whenWatchAppIsNotInstalled() {
            // given
            let message = MessageBuilderHelper.makeDictonary(for: MessageStub())

            sessionMock.stubbedActivationState = .activated
            sessionMock.stubbedIsWatchAppInstalled = false

            // when
            var resultError: Error?
            watchConnectivityService.sendMessage(message, replyHandler: { _ in }, errorHandler: { error in resultError = error })

            // then
            XCTAssertEqual(resultError as? NSError, WatchConnectivityError.watchAppNotInstalled as NSError)
        }
    #endif

    #if os(watchOS)
        func test_thatWatchConnectivityServiceSendsMessageTriggeringErrorHandler_whenCompanionAppIsNotInstalled() {
            // given
            let message = MessageBuilderHelper.makeDictonary(for: MessageMock())

            sessionMock.stubbedActivationState = .activated
            sessionMock.isCompanionAppInstalled = false

            // when
            var resultError: Error?
            watchConnectivityService.sendMessage(message, replyHandler: { _ in }, errorHandler: { error in resultError = error })

            // then
            XCTAssertEqual(resultError as? NSError, WatchConnectivityError.companionAppNotInstalled as NSError)
        }
    #endif

    func test_thatWatchConnectivityServiceSendsMessage_whenActiveStateIsActived() {
        // given
        let message = MessageBuilderHelper.makeDictonary(for: MessageStub())

        sessionMock.stubbedActivationState = .activated
        sessionMock.stubbedIsWatchAppInstalled = true

        // when
        watchConnectivityService.sendMessage(message, replyHandler: nil, errorHandler: nil)

        // then
        XCTAssertEqual(sessionMock.invokedSendMessageCount, 1)
    }

    func test_thatWatchConnectivityServiceTriggersDelegate_whenActivationDidComplete() {
        // when
        watchConnectivityService.session(.default, activationDidCompleteWith: .activated, error: nil)

        // then
        XCTAssertEqual(delegateMock.invokedSessionActivationDidCompleteWithParameters?.session, .default)
        XCTAssertEqual(delegateMock.invokedSessionActivationDidCompleteWithParameters?.activationState, .activated)
        XCTAssertNil(delegateMock.invokedSessionActivationDidCompleteWithParameters?.error)
    }

    func test_thatWatchConnectivityServiceTriggersDelegate_whenActivationDidCompleteWithError() {
        // when
        watchConnectivityService.session(
            .default,
            activationDidCompleteWith: .notActivated,
            error: WatchConnectivityError.sessionIsNotActive
        )

        // then
        XCTAssertEqual(delegateMock.invokedSessionActivationDidCompleteWithParameters?.session, .default)
        XCTAssertEqual(delegateMock.invokedSessionActivationDidCompleteWithParameters?.activationState, .notActivated)
        XCTAssertEqual(
            delegateMock.invokedSessionActivationDidCompleteWithParameters?.error as? NSError,
            WatchConnectivityError.sessionIsNotActive as NSError
        )
    }

    func test_thatWatchConnectivityServiceTriggersDelegate_whenMessageDidReceiveWithReplyHandler() {
        // given
        let message = MessageBuilderHelper.makeDictonary(for: MessageStub())

        // when
        watchConnectivityService.session(.default, didReceiveMessage: message, replyHandler: { _ in })

        // then
        XCTAssertEqual(delegateMock.invokedSessionDidReceiveMessageCount, 1)
    }

    func test_thatWatchConnectivityServiceTriggersDelegate_whenMessageDidReceive() {
        // given
        let message = MessageBuilderHelper.makeDictonary(for: MessageStub())

        // when
        watchConnectivityService.session(.default, didReceiveMessage: message)

        // then
        XCTAssertEqual(delegateMock.invokedSessionCount, 1)
    }

    #if os(iOS)
        func test_thatWatchConnectivityServiceTriggersDelegate_whenSessionDidBecomeActive() {
            // when
            watchConnectivityService.sessionDidBecomeInactive(.default)

            // then
            XCTAssertEqual(delegateMock.invokedSessionDidBecomeInactiveCount, 1)
        }

        func test_thatWatchConnectivityServiceTriggersDelegate_whenSessionDidDeactive() {
            // when
            watchConnectivityService.sessionDidDeactivate(.default)

            // then
            XCTAssertEqual(delegateMock.invokedSessionDidDeactivateCount, 1)
        }
    #endif
}
