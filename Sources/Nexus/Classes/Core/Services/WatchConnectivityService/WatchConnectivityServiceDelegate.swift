//
// Nexus
// Copyright © 2023 Space Code. All rights reserved.
//

import WatchConnectivity

/// A delegate protocol that defines methods for receiving messages sent by a WatchConnectivityService object.
public protocol WatchConnectivityServiceDelegate: AnyObject {
    #if os(iOS)
        /// Inherited from WCSessionDelegate.sessionDidBecomeInactive(_:).
        func sessionDidBecomeInactive(_ session: WCSession)
        /// Inherited from WCSessionDelegate.sessionDidDeactivate(_:).
        func sessionDidDeactivate(_ session: WCSession)
    #endif

    /// Inherited from WCSessionDelegate.session(_:didReceiveMessage:)
    func session(_ session: WCSession, didReceiveMessage message: [String: Any])

    /// Inherited from WCSessionDelegate.session(_:activationDidCompleteWith:error:).
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    )

    /// Inherited from WCSessionDelegate.session(_:didReceiveMessage:replyHandler:).
    func session(
        _ session: WCSession,
        didReceiveMessage message: [String: Any],
        replyHandler: @escaping ([String: Any]) -> Void
    )
}
