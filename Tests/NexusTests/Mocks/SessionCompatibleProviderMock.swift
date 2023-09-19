//
// Nexus
// Copyright © 2023 Space Code. All rights reserved.
//

import Foundation
@testable import Nexus

final class SessionCompatibleProviderMock: ISessionCompatibleProvider {
    var invokedIsSupportedGetter = false
    var invokedIsSupportedGetterCount = 0
    var stubbedIsSupported: Bool! = false

    var isSupported: Bool {
        invokedIsSupportedGetter = true
        invokedIsSupportedGetterCount += 1
        return stubbedIsSupported
    }
}
