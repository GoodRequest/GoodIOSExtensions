import XCTest
import GoodExtensions
import GoodRequestManager
import Mockable

final class LossyCodableArrayTests: XCTestCase {

    struct Response: GRDecodable {

        @LossyCodableArray var ids: [ResponseElement]

    }

    struct ResponseElement: GRDecodable, Equatable {

        let id: Int

    }

    func testLossyCodableArrayEmptyElement() {
        let result: Response = try! MockManager.decodeFromFile(fileName: "EmptyElement", bundle: Bundle.module)
        XCTAssert(result.ids.map{ $0.id } == [1,2,3])
    }

    func testLossyCodableEmptyArray() {
        let result: Response = try! MockManager.decodeFromFile(fileName: "ArrayNil", bundle: Bundle.module)
        XCTAssert(result.ids.map{ $0.id } == [])
    }

}
