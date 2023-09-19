//
// Nexus
// Copyright © 2023 Space Code. All rights reserved.
//

import Nexus
import WatchConnectivity

final class SessionMock: IWCSession {
    var invokedActivationStateGetter = false
    var invokedActivationStateGetterCount = 0
    var stubbedActivationState: WCSessionActivationState!

    var activationState: WCSessionActivationState {
        invokedActivationStateGetter = true
        invokedActivationStateGetterCount += 1
        return stubbedActivationState
    }

    var invokedIsWatchAppInstalledGetter = false
    var invokedIsWatchAppInstalledGetterCount = 0
    var stubbedIsWatchAppInstalled: Bool! = false

    var isWatchAppInstalled: Bool {
        invokedIsWatchAppInstalledGetter = true
        invokedIsWatchAppInstalledGetterCount += 1
        return stubbedIsWatchAppInstalled
    }

    var invokedIsCompanionAppInstalledGetter = false
    var invokedIsCompanionAppInstalledGetterCount = 0
    var stubbedIsCompanionAppInstalled: Bool! = false

    var isCompanionAppInstalled: Bool {
        invokedIsCompanionAppInstalledGetter = true
        invokedIsCompanionAppInstalledGetterCount += 1
        return stubbedIsCompanionAppInstalled
    }

    var invokedDelegateSetter = false
    var invokedDelegateSetterCount = 0
    var invokedDelegate: WCSessionDelegate?
    var invokedDelegateList = [WCSessionDelegate?]()
    var invokedDelegateGetter = false
    var invokedDelegateGetterCount = 0
    var stubbedDelegate: WCSessionDelegate!

    var delegate: WCSessionDelegate? {
        set {
            invokedDelegateSetter = true
            invokedDelegateSetterCount += 1
            invokedDelegate = newValue
            invokedDelegateList.append(newValue)
        }
        get {
            invokedDelegateGetter = true
            invokedDelegateGetterCount += 1
            return stubbedDelegate
        }
    }

    var invokedActivate = false
    var invokedActivateCount = 0

    func activate() {
        invokedActivate = true
        invokedActivateCount += 1
    }

    var invokedSendMessage = false
    var invokedSendMessageCount = 0
    var invokedSendMessageParameters: (message: [String: Any], Void)?
    var invokedSendMessageParametersList = [(message: [String: Any], Void)]()
    var stubbedSendMessageReplyHandlerResult: ([String: Any], Void)?
    var stubbedSendMessageErrorHandlerResult: (Error, Void)?

    func sendMessage(_ message: [String: Any], replyHandler: (([String: Any]) -> Void)?, errorHandler: ((Error) -> Void)?) {
        invokedSendMessage = true
        invokedSendMessageCount += 1
        invokedSendMessageParameters = (message, ())
        invokedSendMessageParametersList.append((message, ()))
        if let result = stubbedSendMessageReplyHandlerResult {
            replyHandler?(result.0)
        }
        if let result = stubbedSendMessageErrorHandlerResult {
            errorHandler?(result.0)
        }
    }
}
