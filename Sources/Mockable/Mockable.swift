import Foundation
import GoodRequestManager

public protocol Mockable {

    static func mockURL(fileName: String) -> URL?

    static func data(fileName: String) -> Data?

    static func decodeFromFile(fileName: String) throws -> Self

}

public enum  JSONTestableError: Error {
    case urlNotValid
    case emptyJsonData
}
