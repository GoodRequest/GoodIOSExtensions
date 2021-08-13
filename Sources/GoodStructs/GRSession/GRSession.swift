//
//  GRNetworking.swift
//  sfzfans
//
//  Created by Dominik Pethö on 7/2/20.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

class GRSession<T: GREndpointManager> {

    private let session: Session

    let baseURL: String
    let configuration: URLSessionConfiguration

    init(
        configuration: URLSessionConfiguration,
        baseURL: String,
        interceptor: RequestInterceptor? = nil
    ) {
        self.baseURL = baseURL
        self.configuration = configuration

        session = .init(
            configuration: configuration,
            interceptor: interceptor
        )
    }

    func request(endpoint: T, base: String? = nil) -> DataRequest {
        let builder = endpointBuilder(endpoint: endpoint, base: base)

        return session.request(
            builder.url ?? URL(fileURLWithPath: ""),
            method: endpoint.method,
            parameters: builder.body,
            encoding: endpoint.encoding,
            headers: endpoint.headers
        )
    }

    func download(endpoint: T, base: String? = nil, customFileName: String? ) -> DownloadRequest {
        let builder = endpointBuilder(endpoint: endpoint, base: base)

        let destination: DownloadRequest.Destination = { temporaryURL, response in
            let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let url = directoryURLs.first?.appendingPathComponent(customFileName ?? response.suggestedFilename!) ?? temporaryURL

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

    func endpointBuilder(endpoint: T, base: String? = nil) -> (url: URL?, body: [String: Any]?) {
        var path: URL? = try? endpoint.asURL(baseURL: base ?? baseURL)
        var bodyData: [String: Any]?

        switch endpoint.queryParameters {
        case .left(let params)?:
            let endpointURL = try? endpoint.asURL(baseURL: base ?? baseURL)
            let urlComponent = NSURLComponents(
                url: endpointURL ?? URL(fileURLWithPath: ""),
                resolvingAgainstBaseURL: false
            )

            urlComponent?.queryItems = params.map {
                URLQueryItem(name: $0.0, value: String(describing: $0.1))
            }
            path = urlComponent?.url

        case .right(let encodable)?:
            let endpointURL = try? endpoint.asURL(baseURL: base ?? baseURL)
            let urlComponent = NSURLComponents(
                url: endpointURL ?? URL(fileURLWithPath: ""),
                resolvingAgainstBaseURL: false
            )

            urlComponent?.queryItems = encodable.jsonDictionary?.map {
                let (key, value) = $0
                return URLQueryItem(name: String(describing: key), value: String(describing: value))
            }

            path = urlComponent?.url
        default: break
        }

        switch endpoint.parameters {
        case .left(let params)?:
            bodyData = params

        case .right(let encodable)?:
            bodyData = encodable.jsonDictionary
        default: break
        }

        return (path, bodyData)
    }

}
