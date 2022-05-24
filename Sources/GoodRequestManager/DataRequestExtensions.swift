//
//  DataProviderExtensions.swift
//
//
//  Created by Dominik Pethö on 4/30/19.
//

import Foundation
import Alamofire
import Combine
import GRCompatible

extension DataRequest: GRCompatible {}

@available(iOS 13, *)
public extension GRActive where Base == DataRequest {

    /// Creates a `DataResponsePublisher` for this instance and uses a `DecodableResponseSerializer` to serialize the
    /// response.
    ///
    /// - Parameters:
    ///   - type:                `Decodable` type to which to decode response `Data`. Inferred from the context by default.
    ///   - queue:               `DispatchQueue` on which the `DataResponse` will be published. `.main` by default.
    ///   - preprocessor:        `DataPreprocessor` which filters the `Data` before serialization. `PassthroughPreprocessor()`
    ///                          by default.
    ///   - decoder:             `DataDecoder` instance used to decode response `Data`. `JSONDecoder()` by default.
    ///   - emptyResponseCodes:  `Set<Int>` of HTTP status codes for which empty responses are allowed. `[204, 205]` by
    ///                          default.
    ///   - emptyRequestMethods: `Set<HTTPMethod>` of `HTTPMethod`s for which empty responses are allowed, regardless of
    ///                          status code. `[.head]` by default.
    ///
    /// - Returns:               The `DataResponsePublisher`.
    func goodify<T: GRDecodable>(
        type: T.Type = T.self,
        queue: DispatchQueue = .main,
        preprocessor: DataPreprocessor = DecodableResponseSerializer<T>.defaultDataPreprocessor,
        emptyResponseCodes: Set<Int> = DecodableResponseSerializer<T>.defaultEmptyResponseCodes,
        emptyResponseMethods: Set<HTTPMethod> = DecodableResponseSerializer<T>.defaultEmptyRequestMethods
    ) -> AnyPublisher<T, AFError> {
        let serializer = DecodableResponseSerializer<T>(
            dataPreprocessor: preprocessor,
            decoder: T.decoder,
            emptyResponseCodes: emptyResponseCodes,
            emptyRequestMethods: emptyResponseMethods
        )
        return base.validate()
            .publishResponse(using: serializer, on: queue)
            .value()
    }

    /// Creates a `DataResponsePublisher` for this instance and uses a `DecodableResponseSerializer` to serialize the
    /// response.
    ///
    /// - Parameters:
    ///   - type:                `Decodable` type to which to decode response `Data`. Inferred from the context by default.
    ///   - queue:               `DispatchQueue` on which the `DataResponse` will be published. `.main` by default.
    ///   - preprocessor:        `DataPreprocessor` which filters the `Data` before serialization. `PassthroughPreprocessor()`
    ///                          by default.
    ///   - decoder:             `DataDecoder` instance used to decode response `Data`. `JSONDecoder()` by default.
    ///   - emptyResponseCodes:  `Set<Int>` of HTTP status codes for which empty responses are allowed. `[204, 205]` by
    ///                          default.
    ///   - emptyRequestMethods: `Set<HTTPMethod>` of `HTTPMethod`s for which empty responses are allowed, regardless of
    ///                          status code. `[.head]` by default.
    ///
    /// - Returns:               The `DataResponsePublisher`.
    func goodify<T: GRDecodable>(
        type: T.Type = T.self,
        queue: DispatchQueue = .main,
        preprocessor: DataPreprocessor = DecodableResponseSerializer<T>.defaultDataPreprocessor,
        emptyResponseCodes: Set<Int> = DecodableResponseSerializer<T>.defaultEmptyResponseCodes,
        emptyResponseMethods: Set<HTTPMethod> = DecodableResponseSerializer<T>.defaultEmptyRequestMethods
    ) -> AnyPublisher<[T], AFError> {
        let serializer = DecodableResponseSerializer<[T]>(
            dataPreprocessor: preprocessor,
            decoder: T.decoder,
            emptyResponseCodes: emptyResponseCodes,
            emptyRequestMethods: emptyResponseMethods
        )
        return base.validate()
            .publishResponse(using: serializer, on: queue)
            .value()
    }

}

// MARK: - Private

public extension GRActive where Base == DataRequest {

    func response<T>(withValue value: T) -> DataResponse<T, AFError> {
        return DataResponse<T, AFError>(
            request: base.request,
            response: base.response,
            data: base.data,
            metrics: .none,
            serializationDuration: 30,
            result: AFResult<T>.success(value)
        )
    }

    func response<T>(withError error: AFError) -> DataResponse<T, AFError> {
        return DataResponse<T, AFError>(
            request: base.request,
            response: base.response,
            data: base.data,
            metrics: .none,
            serializationDuration: 30,
            result: AFResult<T>.failure(error)
        )
    }

}
