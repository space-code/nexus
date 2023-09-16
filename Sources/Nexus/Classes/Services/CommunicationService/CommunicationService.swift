//
// Nexus
// Copyright © 2023 Space Code. All rights reserved.
//

import Combine
import WatchConnectivity

// MARK: - CommunicationService

public final class CommunicationService {
    // MARK: Lifecycle

    public init(watchConnectivityService: IWatchConnectivityService = WatchConnectivityService(session: .default)) {
        self.watchConnectivityService = watchConnectivityService
    }

    // MARK: Public

    public weak var delegate: CommunicationServiceDelegate?

    // MARK: Private

    private let watchConnectivityService: IWatchConnectivityService
    private let notificationCenter = NotificationCenter.default

    private func makeNotificationName(for identifier: String) -> Notification.Name {
        Notification.Name("CommunicationService.\(identifier)")
    }

    private func post(message: [String: Any]) {
        guard let identifier = message[.identifier] as? String else {
            return
        }

        notificationCenter.post(name: makeNotificationName(for: identifier), object: message)
    }

    private func makeDictonary<T: Message>(for message: T) -> [String: Any] {
        let identifierDict: [String: Any] = [.identifier: T.identifier]

        guard let messageDict = message.dictionary else {
            return identifierDict
        }

        return identifierDict.merging(messageDict) { current, _ in current }
    }
}

// MARK: ICommunicationService

extension CommunicationService: ICommunicationService {
    public func configure() {
        watchConnectivityService.delegate = self
        watchConnectivityService.configure()
    }

    public func sendMessaage<T: Message>(_ message: T) {
        watchConnectivityService.sendMessage(
            makeDictonary(for: message),
            replyHandler: nil,
            errorHandler: nil
        )
    }

    public func sendMessage(
        _ message: [String: Any],
        replyHandler: (([String: Any]) -> Void)?,
        errorHandler: ((Error) -> Void)?
    ) {
        watchConnectivityService.sendMessage(
            message,
            replyHandler: replyHandler,
            errorHandler: errorHandler
        )
    }

    public func receiveMessage<T: Message>(_ type: T.Type) -> AnyPublisher<T, Never> {
        notificationCenter.publisher(for: makeNotificationName(for: T.identifier))
            .receive(on: RunLoop.main)
            .tryCompactMap { $0.object as? [String: Any] }
            .tryMap { object in
                try JSONDecoder().decode(type, from: JSONSerialization.data(withJSONObject: object))
            }
            .assertNoFailure()
            .eraseToAnyPublisher()
    }
}

// MARK: WatchConnectivityServiceDelegate

extension CommunicationService: WatchConnectivityServiceDelegate {
    public func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        delegate?.session(session, activationDidCompleteWith: activationState, error: error)
    }

    public func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        delegate?.session(session, didReceiveMessage: message)
        post(message: message)
    }

    public func session(
        _ session: WCSession,
        didReceiveMessage message: [String: Any],
        replyHandler: @escaping ([String: Any]) -> Void
    ) {
        delegate?.session(session, didReceiveMessage: message, replyHandler: replyHandler)
        post(message: message)
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

// MARK: - Constants

private extension String {
    static let identifier = "identifier"
}
