import Foundation

public enum WatchConnectivityError: Swift.Error {
    case sessionIsNotActive
    case watchAppNotInstalled
    case companionAppNotInstalled
}
