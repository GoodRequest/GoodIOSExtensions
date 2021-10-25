import XCTest
import GoodStructs

final class EitherTests: XCTestCase {

    func testEither() {
        let value = Either<Int,String>.left(5)
        assert(try! value.unwrapLeft() == 5)
        let value2 = Either<Int,String>.right("Hello")
        assert(try! value2.unwrap() == "Hello")
    }

    static var allTests = [
        ("testEither", testEither)
    ]
}
