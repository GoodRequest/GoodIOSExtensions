import XCTest
import GoodExtensions
import GoodRequestManager
import Mockable

final class LossyCodableArrayTests: XCTestCase {

    struct Response: Mockable, GRDecodable {

        static func mockURL(fileName: String) -> URL? {
            return Bundle.module.url(forResource: fileName, withExtension: "json")
        }

        static func data(fileName: String) -> Data? {
            guard let testURL = mockURL(fileName: fileName) else { return nil }
            return try? Data(contentsOf: testURL)
        }

        static func decodeFromFile(fileName: String) throws -> Self {
            guard let testURL = mockURL(fileName: fileName) else {
                throw JSONTestableError.urlNotValid

            }
            guard let jsonData = try? Data(contentsOf: testURL) else {
                throw JSONTestableError.emptyJsonData
            }

            return try Self.decode(data: jsonData)
        }

        @LossyCodableArray var ids: [ResponseElement]

    }

    struct ResponseElement: GRDecodable, Equatable {

        let id: Int

    }

    func testLossyCodableArrayEmptyElement() {
        let result = try! Response.decodeFromFile(fileName: "EmptyElement")
        XCTAssert(result.ids.map{ $0.id } == [1,2,3])
    }

    func testLossyCodableEmptyArray() {
        let result = try! Response.decodeFromFile(fileName: "ArrayNil")
        XCTAssert(result.ids.map{ $0.id } == [])
    }

}
