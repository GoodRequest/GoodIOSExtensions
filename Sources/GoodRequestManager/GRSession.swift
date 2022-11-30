//
//  GRSession.swift
//  
//
//  Created by Dominik Pethö on 8/17/20.
//

import Foundation
import Alamofire

open class GRSession<T: GREndpointManager, BaseURL: RawRepresentable> where BaseURL.RawValue == String {

    // MARK: - Private

    public let session: Session
    private let baseURL: String
    private let configuration: GRSessionConfiguration?

    // MARK: - Public

    public init(
        baseURL: BaseURL,
        configuration: GRSessionConfiguration = .default
    ) {
        self.baseURL = baseURL.rawValue
        self.configuration = configuration

        session = .init(
            configuration: configuration.urlSessionConfiguration,
            interceptor: configuration.interceptor,
            serverTrustManager: configuration.serverTrustManager,
            eventMonitors: configuration.eventMonitors
        )
    }

    public func request(endpoint: T, base: BaseURL? = nil) -> DataRequest {
        let builder = endpointBuilder(endpoint: endpoint, base: base?.rawValue ?? baseURL)

        return session.request(
            builder.url ?? URL(fileURLWithPath: ""),
            method: endpoint.method,
            parameters: builder.body,
            encoding: endpoint.encoding,
            headers: endpoint.headers
        )
    }

}

// MARK: - Download

public extension GRSession {

    func download(endpoint: T, base: String? = nil, customFileName: String) -> DownloadRequest {
        let builder = endpointBuilder(endpoint: endpoint, base: base)

        let destination: DownloadRequest.Destination = { temporaryURL, _ in
            let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let url = directoryURLs.first?.appendingPathComponent(customFileName) ?? temporaryURL

            return (url, [.removePreviousFile, .createIntermediateDirectories])
        }

        return session.download(
            builder.url ?? URL(fileURLWithPath: ""),
            method: endpoint.method,
            parameters: builder.body,
            encoding: endpoint.encoding,
            headers: endpoint.headers,
            to: destination
        )
    }

}


// MARK: - Upload

public extension GRSession {

    func uploadWithMultipart(
        endpoint: GREndpointManager,
        data: Data,
        fileHeader: String = "file",
        filename: String,
        mimeType: String
    ) -> UploadRequest {
        return session.upload(
            multipartFormData: {formData in
                formData.append(data, withName: fileHeader, fileName: filename, mimeType: mimeType)
            },
            to: EndpointConvertible(endpoint: endpoint, baseURL: baseURL),
            method: endpoint.method,
            headers: endpoint.headers
        )
    }

}

public class EndpointConvertible: URLConvertible {

    init(endpoint: GREndpointManager, baseURL: String) {
        self.baseURL = baseURL
        self.endpoint = endpoint
    }

    public func asURL() throws -> URL {
        var url = try baseURL.asURL()
        url.appendPathComponent(endpoint.path)
        return url
    }

    let baseURL: String
    let endpoint: GREndpointManager

}

// MARK: - Request Builder

private extension GRSession {

    func endpointBuilder(endpoint: T, base: String? = nil) -> (url: URL?, body: [String: Any]?) {
        let path: URL? = try? endpoint.asURL(baseURL: base ?? baseURL)
        var bodyData: [String: Any]?

        switch endpoint.parameters {
        case .left(let params)?:
            bodyData = params

        case .right(let encodable)?:
            bodyData = encodable.jsonDictionary

        default:
            break
        }

        return (path, bodyData)
    }

}
