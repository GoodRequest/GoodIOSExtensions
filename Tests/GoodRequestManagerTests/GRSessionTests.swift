import XCTest
import GoodStructs
import GoodRequestManager
import Alamofire

class Endpoint: GREndpointManager {

    init() {}

    var path: String = ""

    var method: HTTPMethod {
        return HTTPMethod.post
    }

    var queryParameters: Either<Parameters, GREncodable>? {
        return nil
    }

    var parameters: Either<Parameters, GREncodable>? {
        return nil
    }

    var headers: HTTPHeaders? {
        return nil
    }

    var encoding: ParameterEncoding {
        return URLEncoding.default
    }

    func asURL(baseURL: String) throws -> URL {
        return URL(string: "feafa")!
    }

}

final class GRSessionTests: XCTestCase {

    enum Base: String {

        case base = "https://"

    }

    func testGRSession() {
        let session = GRSession<Endpoint, Base>(configuration: .default, baseURL: .base)
        assert(true)
    }

}
