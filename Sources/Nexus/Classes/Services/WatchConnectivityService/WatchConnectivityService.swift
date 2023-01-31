import WatchConnectivity

// MARK: - WatchConnectivityService

public final class WatchConnectivityService: NSObject {
    // MARK: Lifecycle

    public init(session: WCSession) {
        self.session = session
    }

    // MARK: Public

    public weak var delegate: WatchConnectivityServiceDelegate?

    // MARK: Private

    private let session: WCSession
}

// MARK: IWatchConnectivityService

extension WatchConnectivityService: IWatchConnectivityService {
    public var isSupported: Bool {
        WCSession.isSupported()
    }

    public func configure() {
        guard isSupported else {
            return
        }

        session.delegate = self
        session.activate()
    }

    public func sendMessage(_ message: [String: Any], replyHandler: (([String: Any]) -> Void)?, errorHandler: ((Error) -> Void)?) {
        guard session.activationState == .activated else {
            errorHandler?(WatchConnectivityError.sessionIsNotActive)
            return
        }

        #if os(iOS)
            guard session.isWatchAppInstalled else {
                errorHandler?(WatchConnectivityError.watchAppNotInstalled)
                return
            }
        #else
            guard session.isCompanionAppInstalled else {
                errorHandler?(WatchConnectivityError.companionAppNotInstalled)
                return
            }
        #endif

        session.sendMessage(message, replyHandler: replyHandler, errorHandler: errorHandler)
    }
}

// MARK: WCSessionDelegate

extension WatchConnectivityService: WCSessionDelegate {
    public func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        delegate?.session(session, activationDidCompleteWith: activationState, error: error)
    }

    public func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        delegate?.session(session, didReceiveMessage: message)
    }

    public func session(
        _ session: WCSession,
        didReceiveMessage message: [String: Any],
        replyHandler: @escaping ([String: Any]) -> Void
    ) {
        delegate?.session(session, didReceiveMessage: message, replyHandler: replyHandler)
    }

    #if os(iOS)
        public func sessionDidBecomeInactive(_ session: WCSession) {
            delegate?.sessionDidBecomeInactive(session)
        }

        public func sessionDidDeactivate(_ session: WCSession) {
            delegate?.sessionDidDeactivate(session)
        }
    #endif
}
