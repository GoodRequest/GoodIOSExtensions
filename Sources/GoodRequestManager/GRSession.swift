//
//  GRSession.swift
//  
//
//  Created by Dominik Pethö on 8/17/20.
//

import Foundation
import Alamofire
import Combine

public class GRSession<T: GREndpointManager, BaseURL: RawRepresentable> where BaseURL.RawValue == String {
    
    private let session: Session
    
    let baseURL: BaseURL
    let configuration: URLSessionConfiguration
    
    public init(
        configuration: URLSessionConfiguration,
        baseURL: BaseURL,
        interceptor: RequestInterceptor? = nil,
        serverTrustManager: ServerTrustManager? = nil
    ) {
        self.baseURL = baseURL
        self.configuration = configuration
        
        session = .init(
            configuration: configuration,
            interceptor: interceptor,
            serverTrustManager: serverTrustManager
        )
    }
    
    public func request(endpoint: T, base: BaseURL? = nil) -> DataRequest {
        var path: URL? = try? endpoint.asURL(baseURL: base?.rawValue ?? baseURL.rawValue)
        var bodyData: [String: Any]?
        
        switch endpoint.queryParameters {
        case .left(let params)?:
            let endpointURL = try? endpoint.asURL(baseURL: base?.rawValue ?? baseURL.rawValue)
            let urlComponent = NSURLComponents(url: endpointURL ?? URL(fileURLWithPath: ""), resolvingAgainstBaseURL: false)
            
            urlComponent?.queryItems = params.map {
                URLQueryItem(name: $0.0, value: String(describing: $0.1))
            }
            path = urlComponent?.url
            
        case .right(let encodable)?:
            let endpointURL = try? endpoint.asURL(baseURL: base?.rawValue ?? baseURL.rawValue)
            let urlComponent = NSURLComponents(url: endpointURL ?? URL(fileURLWithPath: ""), resolvingAgainstBaseURL: false)
            
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
        
        return session.request(path ?? URL(fileURLWithPath: ""),
                               method: endpoint.method,
                               parameters: bodyData,
                               encoding: endpoint.encoding,
                               headers: endpoint.headers)
    }
    
//    public func uploadWithMultipart(endpoint: T, baseURL: String, data: Data, filename: String, progressPublisher: PassthroughSubject<ProgressResponse, AFError>) -> UploadRequest {
//        return session.upload(multipartFormData: { formData in
//            formData.append(
//                data,
//                withName: "upload",
//                fileName: filename,
//                mimeType: "image/jpeg")},
//                              to: EndpointConvertible(endpoint: endpoint, baseURL: baseURL),
//                              method: endpoint.method,
//                              headers: endpoint.headers).uploadProgress(closure: { progress in
//                                progressPublisher.send(ProgressResponse(value: progress.fractionCompleted))
//                              })
//    }
    
}
