import Foundation

public protocol Message: Codable {
    static var identifier: String { get }
}
