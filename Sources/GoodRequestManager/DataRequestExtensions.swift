//
//  DataProviderExtensions.swift
//  sfzfans
//
//  Copyright © 2020 GoodRequest. All rights reserved.
//

import Foundation
import Alamofire
import Combine

extension DataRequest {

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
    public func goodify<T: GRDecodable>(type: T.Type = T.self,
                                 queue: DispatchQueue = .main,
                                 preprocessor: DataPreprocessor = DecodableResponseSerializer<T>.defaultDataPreprocessor,
                                 emptyResponseCodes: Set<Int> = DecodableResponseSerializer<T>.defaultEmptyResponseCodes,
                                 emptyResponseMethods: Set<HTTPMethod> = DecodableResponseSerializer<T>.defaultEmptyRequestMethods) -> AnyPublisher<T, AFError> {
        log(type: type)

        let serializer = DecodableResponseSerializer<T>(dataPreprocessor: preprocessor,
                                                     decoder: T.decoder,
                                                     emptyResponseCodes: emptyResponseCodes,
                                                     emptyRequestMethods: emptyResponseMethods)
        return validate()
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
    public func goodify<T: GRDecodable>(type: T.Type = T.self,
                                 queue: DispatchQueue = .main,
                                 preprocessor: DataPreprocessor = DecodableResponseSerializer<T>.defaultDataPreprocessor,
                                 emptyResponseCodes: Set<Int> = DecodableResponseSerializer<T>.defaultEmptyResponseCodes,
                                 emptyResponseMethods: Set<HTTPMethod> = DecodableResponseSerializer<T>.defaultEmptyRequestMethods) -> AnyPublisher<[T], AFError> {
        log(type: type)

        let serializer = DecodableResponseSerializer<[T]>(dataPreprocessor: preprocessor,
                                                     decoder: T.decoder,
                                                     emptyResponseCodes: emptyResponseCodes,
                                                     emptyRequestMethods: emptyResponseMethods)
        return validate()
            .publishResponse(using: serializer, on: queue)
            .value()
    }

}

/// Log level enum
///
/// error - prints only when error occurs
/// info - prints request url with response status and error when occurs
/// verbose - prints everything including request body and response object
public enum GoodSwiftLogLevel {
    case error, info, verbose, none
}

/// Functions for printing in each log level.
public func logError(_ text: String) {
    guard DataRequest.logLevel != .none else { return }

    print(text)
}

public func logInfo(_ text: String) {
    guard DataRequest.logLevel != .none else { return }

    if DataRequest.logLevel != .error {
        print(text)
    }
}

public func logVerbose(_ text: String) {
    guard DataRequest.logLevel != .none else { return }

    if DataRequest.logLevel == .verbose {
        print(text)
    }
}

extension DataRequest {

    public static var logLevel = GoodSwiftLogLevel.verbose

    /// Prints request and response information.
    ///
    /// - returns: Self.
    @discardableResult
    func log<T: GRDecodable>(type: T.Type) -> Self {
        guard DataRequest.logLevel != .none else { return self }

        response(completionHandler: { (response: AFDataResponse<Data?>) in
            print("")
            if let url = response.request?.url?.absoluteString.removingPercentEncoding, let method = response.request?.httpMethod {
                if response.error == nil {
                    logInfo("🚀 \(method) \(url)")
                } else {
                    logError("🚀 \(method) \(url)")
                }
            }
            if let body = response.request?.httpBody, let string = String(data: body, encoding: String.Encoding.utf8), !string.isEmpty {
                logVerbose("📦 \(string)")
            }
            if let response = response.response {
                switch response.statusCode {
                case 200 ..< 300:
                    logInfo("✅ \(response.statusCode)")

                default:
                    logInfo("❌ \(response.statusCode)")
                }
            }
            if let data = response.data, let string = String(data: data, encoding: String.Encoding.utf8), !string.isEmpty {
                logVerbose("📦 \(string)")
                
                do {
                    _ = try T.decoder.decode(T.self, from: data)
                } catch let error {
                    logError("‼️ \(error), \(error.localizedDescription)")
                }
                
            }
            if let error = response.error as NSError? {
                logError("‼️ [\(error.domain) \(error.code)] \(error.localizedDescription)")
            } else if let error = response.error {
                logError("‼️ \(error)")
            }
        })
        return self
    }

}

// MARK: - Private

extension DataResponse {

    public func response<T>(withValue value: T) -> DataResponse<T, AFError> {
        return DataResponse<T, AFError>(request: request, response: response, data: data, metrics: .none, serializationDuration: 30, result: AFResult<T>.success(value))
    }

    public func response<T>(withError error: AFError) -> DataResponse<T, AFError> {
        return DataResponse<T, AFError>(request: request, response: response, data: data, metrics: .none, serializationDuration: 30, result: AFResult<T>.failure(error))
    }

}
