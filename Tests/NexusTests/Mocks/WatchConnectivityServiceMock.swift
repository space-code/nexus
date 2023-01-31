import Nexus

final class WatchConnectivityServiceMock: IWatchConnectivityService {
    var invokedIsSupported = false
    var invokedIsSupportedCount = 0
    var stubbedIsSupported = false

    var isSupported: Bool {
        invokedIsSupported = true
        invokedIsSupportedCount += 1
        return stubbedIsSupported
    }

    var invokedSetDelegate = false
    var invokedSetDelegateCount = 0
    var invokedDelegateParameters: (delegate: WatchConnectivityServiceDelegate?, Void)?
    var invokedDelegateParametersList = [(delegate: WatchConnectivityServiceDelegate?, Void)]()
    var invokedGetDelegate = false
    var invokedGetDelegateCount = 0
    var stubbedDelegate: WatchConnectivityServiceDelegate?
    
    var delegate: WatchConnectivityServiceDelegate? {
        get {
            invokedGetDelegate = true
            invokedGetDelegateCount += 1
            return stubbedDelegate
        }
        set {
            invokedSetDelegate = true
            invokedSetDelegateCount += 1
            invokedDelegateParameters = (newValue, ())
            invokedDelegateParametersList.append((newValue, ()))
        }
    }

    var invokedConfigure = false
    var invokedConfigureCount = 0
    
    func configure() {
        invokedConfigure = true
        invokedConfigureCount += 1
    }
    
    var invokedSendMessage = false
    var invokedSendMessageCount = 0
    var invokedSendMessageParameters: (message: [String : Any], replyHandler: (([String : Any]) -> Void)?, errorHandler: ((Error) -> Void)?)?
    var invokedSendMessageParametersList = [(message: [String : Any], replyHandler: (([String : Any]) -> Void)?, errorHandler: ((Error) -> Void)?)]()
                        
    func sendMessage(
        _ message: [String : Any],
        replyHandler: (([String : Any]) -> Void)?,
        errorHandler: ((Error) -> Void)?
    ) {
        invokedSendMessage = true
        invokedSendMessageCount += 1
        invokedSendMessageParameters = (message, replyHandler, errorHandler)
        invokedSendMessageParametersList.append((message, replyHandler, errorHandler))
    }
}
