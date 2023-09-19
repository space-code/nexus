//
// Nexus
// Copyright © 2023 Space Code. All rights reserved.
//

import Foundation

// MARK: - INotificationCenter

/// A notification dispatch mechanism that enables the broadcast of information to registered observers.
public protocol INotificationCenter {
    /// Creates a notification with a given name and sender and posts it to the notification center.
    ///
    /// - Parameters:
    ///   - aName: The name of the notification.
    ///   - anObject: The object posting the notification.
    func post(name aName: NSNotification.Name, object anObject: Any?)

    /// Returns a publisher that emits events when broadcasting notifications.
    ///
    /// - Parameters:
    ///   - name: The name of the notification to publish.
    ///   - object: The object posting the named notification. If nil, the publisher emits elements
    ///             for any object producing a notification with the given name.
    ///
    /// - Returns: A Publisher that emits events when broadcasting notifications.
    func publisher(for name: Notification.Name, object: AnyObject?) -> NotificationCenter.Publisher
}

extension INotificationCenter {
    func publisher(for name: Notification.Name) -> NotificationCenter.Publisher {
        publisher(for: name, object: nil)
    }
}
