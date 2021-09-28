# GRProvider
[![iOS Version](https://img.shields.io/badge/iOS_Version->=_13.0-brightgreen?logo=apple&logoColor=green)]() [![Swift Version](https://img.shields.io/badge/Swift_Version-5.2-green?logo=swift)](https://docs.swift.org/swift-book/)
[![Supported devices](https://img.shields.io/badge/Supported_Devices-iPhone/iPad-green)]()
[![Contains Test](https://img.shields.io/badge/Tests-YES-blue)]()
[![Dependency Manager](https://img.shields.io/badge/Dependency_Manager-SPM-red)](#swiftpackagemanager)

## Table of content
*  [Features](#Features)
*  [GRCompatible](#GRCompatible)
*  [GoodCache](#GoodCache)
*  [GoodExtensions](#GoodExtensions)
    * [Array](#Array)
    * [CGAffineTransforms](#CGAffineTransforms)
    * [Data](#Data)
    * [Date](#Date)
    * [UICollectionView TableView](#UICollectionView-TableView)
    * [UITableView](#UITableView)
    * [Storyboard](#Storyboard)
    * [Lossy Codable Array](#Lossy-Codable-Array)
    * [MKMultiPoint](#MKMultiPoint)
    * [Attributed string](#Attributed-string)
    * [NSCollectionLayoutGroup](#NSCollectionLayoutGroup)
    * [CGAffineTransforms](#CGAffineTransforms)
    * [NameDescribable](#NameDescribable)
    * [String](#String)
    * [UIAlertController](#UIAlertController)
    * [UICollectionViewCell](#UICollectionViewCell)
    * [UIColor](#UIColor)
    * [UIDatePicker](#UIDatePicker)
    * [UIDevice](#UIDevice)
    * [UILabel](#UILabel)
    * [UINavigationController](#UINavigationController)
    * [UIScrollView](#UIScrollView)
    * [UIView](#UIView)
    * [URL](#URL)
    * [UIViewController](#UIViewController)
*  [GoodCombineExtensions](#GoodCombineExtensions)
    * [UIControll](#UIControll)
    * [BarButtonItem](#BarButtonItem)
    * [GestureRecognizer](#GestureRecognizer)
    * [Publisher](#Publisher)
    * [NWise](#NWise)
*  [GoodReactor](#GoodReactor)
*  [GoodRequestManager](#GoodRequestManager)
*  [GoodStructs](#GoodStructs)
    * [Either](#Either)
    * [Then](#Then)
    * [Nothing](#Nothing)
*  [Installation](#installation)
*  [License](#license)

# GoodIOSExtensions

GoodIOSExtensions is a collection of modules extending different aspects of your swift xcode project

## Features

* GRCompatible
* GoodCache
* GoodCombineExtensions
* GoodExtensions
* GoodReactor
* GoodRequestManager
* GoodStructs

## GRCompatible

A wrapper protocol for distinguishing our extensions. To call goodrequest extensions you refer to .gr ie:
```
cartButton.gr.tapPublisher
```

## GoodCache

A propery wrapper to make caching into keychain and userdefaults extremelly easy.

```
@UserDefaultValue("appState", defaultValue: .inactive)
var appState: AppState

@KeychainValue("accessToken", defaultValue: "", accessibility: .afterFirstUnlockThisDeviceOnly)
var accessToken: String
```

## GoodExtensions
All the other extensions:

### Array 
Returns array of elements where between each element will be inserted element, provided in parameter with the **separated**

Returns true if array contains item with specified index, otherwise returns false with the **contains** function

Returns if Collection has any elements with the **hasItems** property 

Functions for collection operations:

- **removingOrAppending**
- **joinNonNil**
- **chunked**
- **removedDuplicates**
- **prepending**
- **swaped**

Safely ask for item at index using the **safe** subscript

### CGAffineTransforms
Create a transform with scale, translation and anchor in place with the **create** function

### Data 
Creates string from hex data format **hexString**

### Date
A simple function to add time value into an existing date with the **adding** function

### UICollectionView TableView
Set of functions to register and dequeue cells

### UITableView
Header updating functions to recalculate content with the **sizeHeaderToFit**, **updateHeaderWidth** and **sizeFooterToFit**

### Storyboard
Instantiate storyboard from view controller typename with the **instantiateViewController** function

### Lossy Codable Array
Property wrapper that does compact map on top of an array value. Default empty array
```
@LossyCodableArray<Widget> var widgets: [Widget]
```

### MKMultiPoint
Creates an array of MKMapPints from MKMultiPoint with the **points** property

### Attributed string
Contains functions to create Attributed text from HTML string and functions to work with NSMUtableAttributedString

### NSCollectionLayoutGroup
Create a horizontal layout group for Compositional Layout with the **horizontalWithDimensions** function

### NameDescribable
Extracts typename from Collection, NSObject or Enum
```
public protocol NameDescribable {

    var typeName: String { get }
    static var typeName: String { get }

}
```

### String
Removes diacritics from string with the **removeDiacritics**

### UIAlertController
Create alert menu to open Coordinates via different maps with the **create** function

### UIApplication
get status bar frame with **currentStatusBarFrame** property

open URL of Type with predefines URLType
```
public enum UIApplicationUrlType {

    case instagramMedia(id: String)
    case telepromt(number: String)
    case settings

}
```
using the **open** function or just safely open a standard URL with the **safeOpen** function

### UICollectionViewCell
Animate cell selection shrinking it when selected for 0.2 seconds with the **animate**

### UIColor
Create UIColor from 3 equal RGB values or try parse color from hex with our **color** functions

### UIDatePicker 
**dateBinding** computed property for observing datepicker values

### UIDevice
get info about the device  with **deviceId**, **deviceSystem**, **deviceName** and **deviceType**

### UILabel
Computed property **isTruncated** checks if intrisic with is wider than bounds

### UINavigationController 
Push into navigation view controller with completion with the **pushViewController** function

### UIScrollView
Computed property **isRefreshing** cheecks if any refreshing controll is available check if its refreshing

### UIView
Nib loading for initialization through constructor with the **loadNib** function 
A list of IBInspectable attributes for UIView
- **cornerRadius**
- **borderColor** 
- **borderWidth**
- **masksToBounds**
- **shadowOpacity**
- **shadowColor**
- **shadowRadius**
- **shadowOffset**

Shake the view repeatedly with the **shakeView**
Rotate view by given Rotate Options
```
enum Rotate {

    case by0
    case by90
    case by180
    case by270
    case custom(Double)

}
```
with the **rotate**

Animate view fading with the **animate** function

Clip corner radius to exact half with the **circleMaskImage** function 
Blur view beautifuly blur and unblur with the **blur** and **unblur** functions.

### URL
**formatted** computed property returns URL formatted as follows "\(scheme)://\(host)" or returns absolute url string

### UIViewController:
Embed view controller into container with the **embed** function or make instance of viewController with the **makeInstance** function

## GoodCombineExtensions
Extends the combine framework by some convenient events that help you build a reactive app

### UIControll:
A publisher for tapping the UIControll items. 
### Sample:
<details>
<summary>Click to expand!</summary>

```
lazy var buttonPublisher = showAllMatchesButton.gr.publisher(for: .touchUpInside)
    .mapToVoid()
    .erased()
```
</details>

### BarButtonItem:
A publisher for tapping the bar button items. 

### Sample:
<details>
<summary>Click to expand!</summary>

```
sortButton.gr.tapPublisher
    .sink { [weak self] _ in
        guard let self = self else { return }
        let controller = self.createPickerViewController(
            with: SortValues.allCases,
            preselectedItems: self.viewModel.preselectedSortPickerItems
        )
        self.present(controller, animated: true)
    }
    .store(in: &cancellables)
```
</details>

### GestureRecognizer:
Contains an event publisher much like UIControll and BarButtonItem

### Publisher:
Offers a more legible option for chaing multiple Publishers

Assign operator alows you to set key in the given object path

### NWise:
Nwise combine operator for when native operators aren't enough

## GoodReactor
Goodreactor is an adaptation of the Reactor framework that is Redux inspired. 
The view model communicates with the view controller via the State and with the Coordinator via the navigation function.
You communicate to the viewModel via Actions
Viewmodel changes state in the Reduce function 
Viewmodel interactes with dependencies outside of the Reduce function not to create side-effects

Link to the original reactor kit: https://github.com/ReactorKit/ReactorKit

### Sample:
<details>
<summary>Click to expand!</summary>

```
import Foundation
import Combine

// MARK: - View Model Implementation

final class LoginViewModel: Reactor {

    // MARK: - Typealiases

    typealias LoginResult = GRResult<Bool, AppError>

    // MARK: - View Model Definitions

    struct State {

        var loginResult: LoginResult?

    }

    enum Action {

        case loginUser(AuthorizeRequest)
        case goToRegistration

    }

    enum Mutation {

        case loginResultChanged(LoginResult)

    }

    // MARK: - Constants

    internal let initialState: State
    internal let coordinator: Coordinator<AppStep>

    // MARK: - Initialization

    init(di: DI, coordinator: Coordinator<AppStep>) {
        self.coordinator = coordinator
        self.initialState = State(loginResult: nil)
    }

}

// MARK: - Reactive

extension LoginViewModel {

    func navigate(action: Action) -> AppStep? {
        switch action {
       case .goToRegistration:
            return .loginStep(.goToRegistration)

        case .loginUser:
            return nil
        }
    }

    func mutate(action: Action) -> AnyPublisher<Mutation, Never> {
        switch action {
        case .loginUser(let authorizeRequest):
            return loginUser(
                authorizeRequest: authorizeRequest,
                requestManager: di.requestManager,
                userRequestManager: di.userRequestManager,
                cache: di.cache
            )

        case .goToRegistration:
            return Empty().erased()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case .loginResultChanged(let result):
            state.loginResult = result
        }

        return state
    }

}

// MARK: - Private

private extension LoginViewModel {

    func loginUser(
        authorizeRequest: AuthorizeRequest,
        requestManager: RequestManagerType,
        userRequestManager: UserRequestManagerType,
        cache: CacheType
    ) -> AnyPublisher<Mutation, Never> {
        return requestManager.loginUser(authorizeRequest: authorizeRequest)
            .handleEvents(receiveOutput: { cache.cache(accessToken: $0.accessToken) })
            .flatMap { _ in
                userRequestManager.loadWalkthroughState()
                    .map { Mutation.loginResultChanged(.success($0.walkthroughPassed ?? false)) }
                    .mapError { AppError.af($0) }
            }
            .prepend(.loginResultChanged(.loading))
            .catch { Just(Mutation.loginResultChanged(.failure($0))) }
            .erased()
    }

}
```
With a login viewModel like this you receive values in the viewController binding yourself like this.
```
func bindState(reactor: LoginViewModel) {
    reactor.state
        .map { $0.loginResult }
        .removeDuplicates()
        .compactMap { $0 }
        .sink(receiveValue: showLoginResult)
        .store(in: &cancellables)
}
```
And the coordinator navigation looks like this
```
import UIKit
import Combine

// MARK: - Steps

enum LoginStep {

    case goToRegistration
    case goToLogin

}

final class LoginCoordinator: Coordinator<AppStep> {

    // MARK: - Properties

    private let parentCoordinator: Coordinator<AppStep>

// MARK: - Initialization

    init(
        parentCoordinator: Coordinator<AppStep>
    ) {
        self.parentCoordinator = parentCoordinator
    }

    // MARK: - Overrides

    override func navigate(to step: AppStep) -> StepAction {
        switch step {
        case .loginStep(let loginStep):
            return navigate(to: loginStep)

        default:
            return .none
        }
    }

    @discardableResult
    override func start() -> UIViewController? {
        super.start()

        navigationController = UINavigationController()
        setupInitialController()
        let viewController = UIViewController()
        navigationController?.viewControllers = [initialController]

        return navigationController
    }

}


// MARK: - Navigation

private extension LoginCoordinator {

    func navigate(to step: LoginStep) -> StepAction {
        switch step {
        case .goToRegistration:
            let registerViewModel = RegisterViewModel(di: di, coordinator: self)
            let registerViewController = RegisterViewController.create(viewModel: registerViewModel)

            return .push(registerViewController)

        case .goToLogin:
            return .push(createLoginViewController())
        }
    }

}

```
</details>


GoodCoordinator also allows you to find the first type matching coordinator in hierarchy via: **firstCoordinatorOfType** and **lastCoordinatorOfType** functions

## GoodRequestManager
Contains our GRSession that works with GREndpointManager and GRCodable and DataRequestExtensions.
### Sample:
<details>
<summary>Click to expand!</summary>

```
import Foundation
import Alamofire
import Combine

enum UserRequestEndpoint: GREndpointManager {

    // MARK: - User Profile

    case profile


    var path: String {
        switch self {
        case .profile,
            return "v1/me/profile"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .profile,
            return .get
        }
    }

    var queryParameters: Either<Parameters, GREncodable>? {
        return nil
    }

    var parameters: Either<Parameters, GREncodable>? {
        return nil
    }

    var encoding: ParameterEncoding {
        return method == .get ? URLEncoding(destination: .methodDependent) : JSONEncoding.default
    }

    var headers: HTTPHeaders? {
        return [.contentType("application/json")]
    }

    func asURL(baseURL: String) throws -> URL {
        var url = try baseURL.asURL()
        url.appendPathComponent(path)
        return url
    }

}

class UserRequestManager: UserRequestManagerType {

    // MARK: - Constants

    internal let session: GRSession<UserRequestEndpoint, ApiServer>
    internal let cache: CacheType

    // MARK: - Initialization

    init(baseURL: String, cache: CacheType) {
        session = GRSession(
            configuration: .default,
            baseURL: baseURL,
            interceptor: SFZRequestInterceptor(cache: cache)
        )
        self.cache = cache
    }

    // MARK: - User Profile

    func fetchProfile() -> AnyPublisher<ProfileResponse, AFError> {
        return session.request(endpoint: .profile)
            .validateToSFZError()
            .goodify()
    }

}

```
And then inside your viewModel just call 
```
fetchProfile(requestManager: requestManager, id: id, appSpace: appSpace),
```
The result is a publisher so you can continue chaining Combine functions.
</details>

Also contains datarequest logger that logs the payload and response and request url of sent datarequests to be able to debug it more easily
## GoodStructs
### Either
Either represents a value of one of two possible types (a disjoint union).

### Sample:
<details>
<summary>Click to expand!</summary>

```
var queryParameters: Either<Parameters, GREncodable>? {
    switch self {
    case .login:
        return .left(
            [
                "client_id": Environment.isProductionAppId,
                "appSpace": AppSpace.defaultAppSpace
            ]
        )
        
     default:
        return nil
    }
}
```
</details>

### Then
Makes it available to set properties with closures just after initializing.

### Sample:
<details>
<summary>Click to expand!</summary>

```
surnameLabel.then {
    $0.font = AC.DynamicFont.largeTitle
    $0.textColor = Color.blueDark.color
}
```
</details>

### Nothing
Empty codable equatable and error struct

### Sample:
<details>
<summary>Click to expand!</summary>

```
func resetPassword(
    requestManager: RequestManagerType,
    email: String
) -> AnyPublisher<Mutation, Never> {
    return requestManager.resetPassword(email: email)
        .mapError { AppError.af($0) }
        .map { _ in Mutation.resetPasswordResultChanged(.success(Nothing())) }
        .prepend(.resetPasswordResultChanged(.loading))
        .catch { Just(Mutation.resetPasswordResultChanged(.failure($0))) }
        .erased()
}
```
</details>

## Installation
### Swift Package Manager

Create a `Package.swift` file and add the package dependency into the dependencies list. 
Or to integrate without package.swift add it through the Xcode add package interface.

```swift

import PackageDescription

let package = Package(
    name: "SampleProject",
    dependencies: [
        .Package(url: "https://github.com/GoodRequest/GoodIOSExtensions" from: "0.2.3")
    ]
)

```

## License
GoodIOSExtensions repository is released under the MIT license. See [LICENSE](LICENSE.md) for details.