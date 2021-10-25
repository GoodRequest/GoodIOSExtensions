import XCTest
import GoodReactor
import UIKit

final class GoodCoordinatorTests: XCTestCase {


    func testGoodCoordinatorParent() {
        let firstCoordinator = FirstCoordinator(parentCoordinator: nil)
        let firstCoordinator2 = FirstCoordinator(parentCoordinator: firstCoordinator)
        let secondCoordinator = SecondCoordinator(parentCoordinator: firstCoordinator)
        let thirdCoordinator = ThirdCoordinator(parentCoordinator: secondCoordinator)
        let fourthCoordinator = FourthCoordinator(parentCoordinator: thirdCoordinator)

        XCTAssert(fourthCoordinator.firstCoordinatorOfType(type: ThirdCoordinator.self) == thirdCoordinator)
        XCTAssert(fourthCoordinator.firstCoordinatorOfType(type: SecondCoordinator.self) == secondCoordinator)
        XCTAssert(fourthCoordinator.lastCoordinatorOfType(type: FirstCoordinator.self, lastMatch: nil) == firstCoordinator)
    }

}

enum Steps {

    case firstStep

}

class FirstCoordinator: GoodCoordinator<Steps> {}
class SecondCoordinator: GoodCoordinator<Steps> {}
class ThirdCoordinator: GoodCoordinator<Steps> {}
class FourthCoordinator: GoodCoordinator<Steps> {}
