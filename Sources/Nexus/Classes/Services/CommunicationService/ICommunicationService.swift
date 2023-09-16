//
// Nexus
// Copyright © 2023 Space Code. All rights reserved.
//

import Combine

/// The protocol describe a public interface of the communication service.
public protocol ICommunicationService: AnyObject {
    /// A communication service delegate.
    var delegate: CommunicationServiceDelegate? { get set }

    /// Configure service.
    func configure()

    /// Send a message.
    ///
    /// - Parameter message: A message object,
    func sendMessaage<T: Message>(_ message: T)

    /// Sends a message immediately to the paired and active device and optionally handles a response.
    ///
    /// - Parameters:
    ///   - message: A message object.
    ///   - replyHandler: A reply handler for receiving a response from the counterpart.
    ///   Specify nil if you do not want to receive a reply.This block has no return value and takes
    ///   the following parameter:`replyMessage`
    ///   A dictionary of property list values containing the response from the counterpart.
    ///   - errorHandler: A block that is executed when an error occurs. Specify nil if you do not care about error information.
    ///   This block has no return value and takes the following parameter: `errorHandler`
    ///   An error object containing the reason for the failure.
    ///   When sending messages, the most common error is that the paired device was not reachable,
    ///   but other errors may occur too.
    func sendMessage(
        _ message: [String: Any],
        replyHandler: (([String: Any]) -> Void)?,
        errorHandler: ((Error) -> Void)?
    )

    /// Subscribe to receive messages from the service.
    func receiveMessage<T: Message>(_ message: T.Type) -> AnyPublisher<T, Never>
}
