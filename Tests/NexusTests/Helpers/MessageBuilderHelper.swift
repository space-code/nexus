//
// Nexus
// Copyright © 2023 Space Code. All rights reserved.
//

import Foundation
@testable import Nexus

// MARK: - MessageBuilderHelper

final class MessageBuilderHelper {
    static func makeDictonary<T: Message>(for message: T) -> [String: Any] {
        let identifierDict: [String: Any] = [.identifier: T.identifier]

        guard let messageDict = message.dictionary else {
            return identifierDict
        }

        return identifierDict.merging(messageDict) { current, _ in current }
    }
}

// MARK: - Constants

private extension String {
    static let identifier = "identifier"
}
