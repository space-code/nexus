//
// Nexus
// Copyright © 2023 Space Code. All rights reserved.
//

import Foundation

/// `WatchConnectivityError` is the error type returned by Nexus.
/// It encompasses a few different types of errors, each with their own associated reasons.
public enum WatchConnectivityError: Swift.Error {
    /// The `WCSession` is not active.
    case sessionIsNotActive
    /// The watch application is not installed.
    case watchAppNotInstalled
    /// The companion application is not installed.
    case companionAppNotInstalled
}
