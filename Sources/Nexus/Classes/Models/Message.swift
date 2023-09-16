//
// Nexus
// Copyright © 2023 Space Code. All rights reserved.
//

import Foundation

public protocol Message: Codable {
    static var identifier: String { get }
}
