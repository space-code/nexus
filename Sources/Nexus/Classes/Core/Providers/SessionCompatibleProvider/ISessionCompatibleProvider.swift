//
// Nexus
// Copyright © 2023 Space Code. All rights reserved.
//

import Foundation

/// A type that identifies compatible session communication.
public protocol ISessionCompatibleProvider {
    /// A Boolean value indicating whether the current iOS device is able to use a session object.
    var isSupported: Bool { get }
}
