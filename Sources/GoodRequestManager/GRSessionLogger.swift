//
//  GRSessionLogger.swift
//  
//
//  Created by Andrej Jasso on 24/05/2022.
//

import Foundation
import Alamofire

open class GRSessionLogger: EventMonitor {

    public init() {}

    public func request<T>(_ request: DataRequest, didParseResponse response: DataResponse<T, AFError>) {
        if let url = response.request?.url?.absoluteString.removingPercentEncoding,
           let method = response.request?.httpMethod {
            let headers = response.request?.headers.description ?? "🏷 empty headers"

            if response.error == nil {
                logInfo("🚀 \(method) \(url)")
                logVerbose("🏷 \(headers)")
            } else {
                logError("🚀 \(method) \(url)")
                logVerbose("🏷 \(headers)")
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

            if case let .failure(error) = response.result {
                logError("‼️ \(error), \(error.localizedDescription)")
            }
        }

        if let error = response.error as NSError? {
            logError("‼️ [\(error.domain) \(error.code)] \(error.localizedDescription)")
        } else if let error = response.error {
            logError("‼️ \(error)")
        }
    }

}

private extension GRSessionLogger {

    /// Functions for printing in each log level.
    func logError(_ text: String) {
        guard GRSessionConfiguration.logLevel != .none else { return }

        print(text)
    }

    func logInfo(_ text: String) {
        guard GRSessionConfiguration.logLevel != .none else { return }

        if GRSessionConfiguration.logLevel != .error {
            print(text)
        }
    }

    func logVerbose(_ text: String) {
        guard GRSessionConfiguration.logLevel != .none else { return }

        if GRSessionConfiguration.logLevel == .verbose {
            print(text)
        }
    }

}
