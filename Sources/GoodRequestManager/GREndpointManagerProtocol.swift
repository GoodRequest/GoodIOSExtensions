//
//  GREndpointManager.swift
//  

import Alamofire
import Foundation
import GoodStructs

public protocol GREndpointManager {

    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Either<Parameters, GREncodable>? { get }
    var headers: HTTPHeaders? { get }
    var encoding: ParameterEncoding { get }
    func asURL(baseURL: String) throws -> URL

}
