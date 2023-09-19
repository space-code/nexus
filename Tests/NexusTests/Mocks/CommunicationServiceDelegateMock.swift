//
// Nexus
// Copyright © 2023 Space Code. All rights reserved.
//

import Foundation
@testable import Nexus
import WatchConnectivity

final class CommunicationServiceDelegateMock: CommunicationServiceDelegate {
    var invokedSessionDidBecomeInactive = false
    var invokedSessionDidBecomeInactiveCount = 0
    var invokedSessionDidBecomeInactiveParameters: (session: WCSession, Void)?
    var invokedSessionDidBecomeInactiveParametersList = [(session: WCSession, Void)]()

    func sessionDidBecomeInactive(_ session: WCSession) {
        invokedSessionDidBecomeInactive = true
        invokedSessionDidBecomeInactiveCount += 1
        invokedSessionDidBecomeInactiveParameters = (session, ())
        invokedSessionDidBecomeInactiveParametersList.append((session, ()))
    }

    var invokedSessionDidDeactivate = false
    var invokedSessionDidDeactivateCount = 0
    var invokedSessionDidDeactivateParameters: (session: WCSession, Void)?
    var invokedSessionDidDeactivateParametersList = [(session: WCSession, Void)]()

    func sessionDidDeactivate(_ session: WCSession) {
        invokedSessionDidDeactivate = true
        invokedSessionDidDeactivateCount += 1
        invokedSessionDidDeactivateParameters = (session, ())
        invokedSessionDidDeactivateParametersList.append((session, ()))
    }

    var invokedSession = false
    var invokedSessionCount = 0
    var invokedSessionParameters: (session: WCSession, message: [String: Any])?
    var invokedSessionParametersList = [(session: WCSession, message: [String: Any])]()

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        invokedSession = true
        invokedSessionCount += 1
        invokedSessionParameters = (session, message)
        invokedSessionParametersList.append((session, message))
    }

    var invokedSessionActivationDidCompleteWith = false
    var invokedSessionActivationDidCompleteWithCount = 0
    var invokedSessionActivationDidCompleteWithParameters: (session: WCSession, activationState: WCSessionActivationState, error: Error?)?
    var invokedSessionActivationDidCompleteWithParametersList =
        [(session: WCSession, activationState: WCSessionActivationState, error: Error?)]()

    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        invokedSessionActivationDidCompleteWith = true
        invokedSessionActivationDidCompleteWithCount += 1
        invokedSessionActivationDidCompleteWithParameters = (session, activationState, error)
        invokedSessionActivationDidCompleteWithParametersList.append((session, activationState, error))
    }

    var invokedSessionDidReceiveMessage = false
    var invokedSessionDidReceiveMessageCount = 0
    var invokedSessionDidReceiveMessageParameters: (session: WCSession, message: [String: Any])?
    var invokedSessionDidReceiveMessageParametersList = [(session: WCSession, message: [String: Any])]()
    var stubbedSessionDidReceiveMessageReplyHandlerResult: ([String: Any], Void)?

    func session(
        _ session: WCSession,
        didReceiveMessage message: [String: Any],
        replyHandler: @escaping ([String: Any]) -> Void
    ) {
        invokedSessionDidReceiveMessage = true
        invokedSessionDidReceiveMessageCount += 1
        invokedSessionDidReceiveMessageParameters = (session, message)
        invokedSessionDidReceiveMessageParametersList.append((session, message))
        if let result = stubbedSessionDidReceiveMessageReplyHandlerResult {
            replyHandler(result.0)
        }
    }
}
