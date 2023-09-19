//
// Nexus
// Copyright © 2023 Space Code. All rights reserved.
//

import Foundation

/// A common type for all messages.
public protocol Message: Codable {
    /// The message identifier.
    static var identifier: String { get }
}
