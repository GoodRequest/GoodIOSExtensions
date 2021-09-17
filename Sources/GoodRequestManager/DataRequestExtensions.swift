//
//  DataProviderExtensions.swift
//  sfzfans
//
//  Copyright © 2020 GoodRequest. All rights reserved.
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
        base.gr.log(type: type)

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
        base.gr.log(type: type)

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

/// Log level enum
///
/// error - prints only when error occurs
/// info - prints request url with response status and error when occurs
/// verbose - prints everything including request body and response object
public enum GoodSwiftLogLevel {

    case error
    case info
    case verbose
    case none

}

/// Functions for printing in each log level.
func logError(_ text: String) {
    guard DataRequest.gr.logLevel != .none else { return }

    print(text)
}

func logInfo(_ text: String) {
    guard DataRequest.gr.logLevel != .none else { return }

    if DataRequest.gr.logLevel != .error {
        print(text)
    }
}

func logVerbose(_ text: String) {
    guard DataRequest.gr.logLevel != .none else { return }

    if DataRequest.gr.logLevel == .verbose {
        print(text)
    }
}

public extension GRActive where Base == DataRequest {

    static var logLevel = GoodSwiftLogLevel.verbose

    /// Prints request and response information.
    ///
    /// - returns: Self.
    @discardableResult
    func log<T: GRDecodable>(type: T.Type) -> Self {
        guard DataRequest.gr.logLevel != .none else { return self }

        base.response(completionHandler: { (response: AFDataResponse<Data?>) in
            print("")
            if let url = response.request?.url?.absoluteString.removingPercentEncoding,
               let method = response.request?.httpMethod {
                if response.error == nil {
                    logInfo("🚀 \(method) \(url)")
                } else {
                    logError("🚀 \(method) \(url)")
                }
            }
            if let body = response.request?.httpBody,
               let string = String(data: body, encoding: String.Encoding.utf8), !string.isEmpty {
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
            if let data = response.data,
               let string = String(data: data, encoding: String.Encoding.utf8), !string.isEmpty {
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
