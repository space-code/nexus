//
// Nexus
// Copyright © 2023 Space Code. All rights reserved.
//

import Foundation
import WatchConnectivity

// MARK: - IWCSession

/// A type that initiates communication between a WatchKit extension and its companion iOS app.
public protocol IWCSession: AnyObject {
    /// The current activation state of the session.
    var activationState: WCSessionActivationState { get }

    #if os(iOS)
        /// A Boolean value indicating whether the currently paired and active Apple Watch has installed the app.
        var isWatchAppInstalled: Bool { get }
    #else
        ///  A Boolean value indicating whether the companion has installed the app.
        var isCompanionAppInstalled: Bool { get }
    #endif

    /// The delegate for the session object.
    var delegate: WCSessionDelegate? { get set }

    /// Activates the session asynchronously.
    func activate()

    /// Sends a message immediately to the paired and active device and optionally handles a response.
    ///
    /// - Parameters:
    ///   - message: A dictionary of property list values that you want to send.
    ///              You define the contents of the dictionary that your counterpart supports.
    ///              This parameter must not be nil.
    ///   - replyHandler: A reply handler for receiving a response from the counterpart.
    ///                   Specify nil if you do not want to receive a reply.
    ///   - errorHandler: A block that is executed when an error occurs.
    ///                   Specify nil if you do not care about error information.
    func sendMessage(_ message: [String: Any], replyHandler: (([String: Any]) -> Void)?, errorHandler: ((Error) -> Void)?)
}

// MARK: - WCSession + IWCSession

extension WCSession: IWCSession {}
