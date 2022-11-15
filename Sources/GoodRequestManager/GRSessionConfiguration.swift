//
//  File.swift
//  
//
//  Created by Andrej Jasso on 15/11/2022.
//

import Foundation
import Alamofire
import GoodStructs

open class GRSessionConfiguration {

    // MARK: - Enums

    /// Log level enum
    ///
    /// error - prints only when error occurs
    /// info - prints request url with response status and error when occurs
    /// verbose - prints everything including request body and response object
    public enum GRSessionLogLevel {

        case error
        case info
        case verbose
        case none

    }

    // MARK: - Constants

    let urlSessionConfiguration: URLSessionConfiguration
    let interceptor: RequestInterceptor?
    let serverTrustManager: ServerTrustManager?
    let eventMonitors: [EventMonitor]

    // MARK: - Initialization

    public init(
        urlSessionConfiguration: URLSessionConfiguration = .default,
        interceptor: RequestInterceptor? = nil,
        serverTrustManager: ServerTrustManager? = nil,
        eventMonitors: [EventMonitor] = []
    ) {
        self.urlSessionConfiguration = urlSessionConfiguration
        self.interceptor = interceptor
        self.serverTrustManager = serverTrustManager
        self.eventMonitors = eventMonitors
    }

    // MARK: - Static

    public static var logLevel: GRSessionLogLevel = .verbose

    public static let `default` = GRSessionConfiguration(
        urlSessionConfiguration: .default,
        interceptor: nil,
        serverTrustManager: nil,
        eventMonitors: [GRSessionLogger()]
    )

}
