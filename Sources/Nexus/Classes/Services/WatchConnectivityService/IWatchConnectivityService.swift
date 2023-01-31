public protocol IWatchConnectivityService: AnyObject {
    /// Returns a Boolean value indicating whether the current iOS device is able to use a session object.
    var isSupported: Bool { get }

    /// Delegate.
    var delegate: WatchConnectivityServiceDelegate? { set get }

    /// Configure watch connectivity service.
    func configure()

    /// Sends a message immediately to the paired and active device and optionally handles a response.
    ///
    /// - Parameters:
    ///   - message: A message object.
    ///   - replyHandler: A reply handler for receiving a response from the counterpart. Specify nil if you do not want to receive a reply.
    ///   This block has no return value and takes the following parameter: `replyMessage` A dictionary of property list values containing the response from the counterpart.
    ///   - errorHandler: A block that is executed when an error occurs. Specify nil if you do not care about error information.
    ///   This block has no return value and takes the following parameter: `errorHandler`
    ///   An error object containing the reason for the failure. When sending messages, the most common error is that the paired device was not reachable, but other errors may occur too.
    func sendMessage(
        _ message: [String: Any],
        replyHandler: (([String: Any]) -> Void)?,
        errorHandler: ((Error) -> Void)?
    )
}
