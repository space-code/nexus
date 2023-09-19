//
// Nexus
// Copyright © 2023 Space Code. All rights reserved.
//

import Foundation
import WatchConnectivity

public final class SessionCompatibleProvider: ISessionCompatibleProvider {
    // MARK: Initialization

    public init() {}

    // MARK: ISessionCompatibleProvider

    public var isSupported: Bool {
        WCSession.isSupported()
    }
}
