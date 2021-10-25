import XCTest
import GRCompatible

final class BaseTests: XCTestCase {

    func testBaseType() {
        assert("Hello".gr.base != nil)
    }

}
