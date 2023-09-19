//
// Nexus
// Copyright © 2023 Space Code. All rights reserved.
//

import Nexus
import XCTest

final class SessionCompatibleProviderTests: XCTestCase {
    // MARK: Properties

    private var provider: SessionCompatibleProvider!

    // MARK: Initialization

    override func setUp() {
        super.setUp()
        provider = SessionCompatibleProvider()
    }

    override func tearDown() {
        provider = nil
        super.tearDown()
    }

    // MARK: Tests

    func test_thatSessionCompatibleProviderSupportsConnection() {
        // when
        let result = provider.isSupported

        // then
        XCTAssertTrue(result)
    }
}
