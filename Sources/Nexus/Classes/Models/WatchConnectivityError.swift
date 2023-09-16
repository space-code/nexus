//
// Nexus
// Copyright © 2023 Space Code. All rights reserved.
//

import Foundation

public enum WatchConnectivityError: Swift.Error {
    case sessionIsNotActive
    case watchAppNotInstalled
    case companionAppNotInstalled
}
