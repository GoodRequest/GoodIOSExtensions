//
//  DataRequest.swift
//
//  Created by Dominik Pethö on 7/2/20.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

import Foundation
import Alamofire

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
    guard URLRequest.logLevel != .none else { return }

    print(text)
}

public func logInfo(_ text: String) {
    guard URLRequest.logLevel != .none else { return }

    if URLRequest.logLevel != .error {
        print(text)
    }
}

public func logVerbose(_ text: String) {
    guard URLRequest.logLevel != .none else { return }

    if URLRequest.logLevel == .verbose {
        print(text)
    }
}

extension URLRequest {

    public static var logLevel = GoodSwiftLogLevel.verbose

}

extension DataRequest {

    /// Prints request and response information.
    ///
    /// - returns: Self.
    @discardableResult
    func log<T: GRDecodable>(type: T.Type) -> Self {
        guard DataRequest.logLevel != .none else { return self }

        response(completionHandler: { (response: AFDataResponse<Data?>) in
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
               let string = String(data: body, encoding: String.Encoding.utf8),
               !string.isEmpty {
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
               let string = String(data: data, encoding: String.Encoding.utf8),
               !string.isEmpty {
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

extension DataResponse {

    func response<T>(withValue value: T) -> DataResponse<T, AFError> {
        return DataResponse<T, AFError>(
            request: request,
            response: response,
            data: data,
            metrics: .none,
            serializationDuration: 30,
            result: AFResult<T>.success(value)
        )
    }

    func response<T>(withError error: AFError) -> DataResponse<T, AFError> {
        return DataResponse<T, AFError>(
            request: request,
            response: response,
            data: data,
            metrics: .none,
            serializationDuration: 30,
            result: AFResult<T>.failure(error)
        )
    }

}

extension DownloadRequest {

    /// Prints request and response information.
    ///
    /// - returns: Self.
    @discardableResult
    func log() -> Self {
        guard DataRequest.logLevel != .none else { return self }

        response(completionHandler: { (response: AFDownloadResponse<URL?>) in
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
               let string = String(data: body, encoding: String.Encoding.utf8),
               !string.isEmpty {
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
            if let fileURL = response.fileURL?.absoluteString.removingPercentEncoding {
                logVerbose("📦 \(fileURL)")
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
