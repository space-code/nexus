//
// Nexus
// Copyright © 2023 Space Code. All rights reserved.
//

import Combine

/// A type that initiates bi-directional communication between the Apple Watch and the iPhone app.
public protocol ICommunicationService: AnyObject {
    /// The delegate for the service object.
    var delegate: CommunicationServiceDelegate? { get set }

    /// Configures service.
    func configure()

    /// Sends a message.
    ///
    /// - Parameter message: The message object,
    func sendMessaage<T: Message>(_ message: T)

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

    /// Subscribes to receive messages from the service.
    func receiveMessage<T: Message>(_ message: T.Type) -> AnyPublisher<T, Never>
}
