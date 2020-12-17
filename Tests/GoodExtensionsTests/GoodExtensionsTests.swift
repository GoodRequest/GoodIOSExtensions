import XCTest
import GoodExtensions

final class GoodExtensionsTests: XCTestCase {
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var view: UIView!

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        tableView.gr.rotate(.by180)
        XCTAssertEqual(" Dominik ".gr.removeWhiteSpacesAndNewlines, "Dominik")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
