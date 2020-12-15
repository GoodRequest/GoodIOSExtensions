import XCTest
import GoodExtensions

final class GoodExtensionsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(" Dominik ".gr.removeWhiteSpacesAndNewlines, "Dominik")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
