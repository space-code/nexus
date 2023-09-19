//
// Nexus
// Copyright © 2023 Space Code. All rights reserved.
//

/// A type that initiates communication between a WatchKit extension and its companion iOS app.
public protocol IWatchConnectivityService: AnyObject {
    /// Returns a Boolean value indicating whether the current iOS device is able to use a session object.
    var isSupported: Bool { get }

    /// The delegate object for the serivce.
    var delegate: WatchConnectivityServiceDelegate? { get set }

    /// Configures the watch connectivity service.
    func configure()

    /// Sends a message immediately to the paired and active device and optionally handles a response.
    ///
    /// - Parameters:
    ///   - message: The message object.
    ///   - replyHandler: A reply handler for receiving a response from the counterpart.
    ///                   Specify nil if you do not want to receive a reply.
    ///   - errorHandler: A block that is executed when an error occurs. Specify nil if you do not care about error information.
    func sendMessage(
        _ message: [String: Any],
        replyHandler: (([String: Any]) -> Void)?,
        errorHandler: ((Error) -> Void)?
    )
}
