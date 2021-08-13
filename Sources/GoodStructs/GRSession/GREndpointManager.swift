//
//  GREndpointManager.swift
//  sfzfans
//
//  Created by Dominik Pethö on 7/2/20.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

protocol GREndpointManager {

    var path: String { get }
    var method: HTTPMethod { get }
    var queryParameters: Either<Parameters, GREncodable>? { get }
    var parameters: Either<Parameters, GREncodable>? { get }
    var headers: HTTPHeaders? { get }
    var encoding: ParameterEncoding { get }
    func asURL(baseURL: String) throws -> URL

}
