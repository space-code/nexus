//
// Nexus
// Copyright © 2023 Space Code. All rights reserved.
//

import Foundation
import Nexus

final class NotificationCenterMock: INotificationCenter {
    var invokedPost = false
    var invokedPostCount = 0
    var invokedPostParameters: (aName: NSNotification.Name, anObject: Any?)?
    var invokedPostParametersList = [(aName: NSNotification.Name, anObject: Any?)]()

    func post(name aName: NSNotification.Name, object anObject: Any?) {
        invokedPost = true
        invokedPostCount += 1
        invokedPostParameters = (aName, anObject)
        invokedPostParametersList.append((aName, anObject))
    }

    var invokedPublisher = false
    var invokedPublisherCount = 0
    var invokedPublisherParameters: (name: Notification.Name, object: AnyObject?)?
    var invokedPublisherParametersList = [(name: Notification.Name, object: AnyObject?)]()
    var stubbedPublisherResult: NotificationCenter.Publisher!

    func publisher(for name: Notification.Name, object: AnyObject?) -> NotificationCenter.Publisher {
        invokedPublisher = true
        invokedPublisherCount += 1
        invokedPublisherParameters = (name, object)
        invokedPublisherParametersList.append((name, object))
        return stubbedPublisherResult
    }
}
