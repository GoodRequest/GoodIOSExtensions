import XCTest
import GoodExtensions
import GoodRequestManager
import Alamofire
#if !os(macOS)

import UIKit

final class GoodExtensionsTests: XCTestCase {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var view: UIView!

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
//        tableView.gr.rotate(.by180)
        print(scrollView.gr.isRefreshing)
        scrollView.refreshControl?.gr.endRefreshing()

        DataRequest().gr.goodify()

        XCTAssertEqual(" Dominik ".gr.removeWhiteSpacesAndNewlines, "Dominik")
    }

    static var allTests = [
        ("testExample", testExample)
    ]
}

#endif
