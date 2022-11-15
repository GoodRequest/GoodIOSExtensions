//
//  GRImageDownloader.swift
//  
//
//  Created by Andrej Jasso on 24/05/2022.
//

import Foundation
import AlamofireImage
import Alamofire

open class GRImageDownloader {

    public struct GRImageDownloaderConfiguration {

        let maxActiveDownloads: Int

    }

    // MARK: - Constants

    enum C {

        static let imageDownloaderDispatchQueueKey = "ImageDownloaderDispatchQueue"
        static let imageDownloaderOperationQueueKey = "ImageDownloaderOperationQueue"

    }

    // MARK: - Variables

    static var shared: ImageDownloader?

    // MARK: - Public

    static func setupAuthorizedImageDownloader(
        sessionConfiguration: GRSessionConfiguration = GRSessionConfiguration.configuration,
        downloaderConfiguration: GRImageDownloaderConfiguration
    ) {
        let imageDownloaderQueue = DispatchQueue(label: C.imageDownloaderDispatchQueueKey)
        let operationQueue = OperationQueue().then {
            $0.name = C.imageDownloaderOperationQueueKey
            $0.underlyingQueue = imageDownloaderQueue
            $0.maxConcurrentOperationCount = downloaderConfiguration.maxActiveDownloads
            $0.qualityOfService = .default
        }

        let sessionDelegate = SessionDelegate()

        let urlSession = URLSession(
            configuration: sessionConfiguration.urlSessionConfiguration,
            delegate: sessionDelegate,
            delegateQueue: operationQueue
        )

        let session = Session(
            session: urlSession,
            delegate: sessionDelegate,
            rootQueue: imageDownloaderQueue,
            interceptor: sessionConfiguration.interceptor,
            serverTrustManager: sessionConfiguration.serverTrustManager,
            eventMonitors: sessionConfiguration.eventMonitors
        )

        shared = ImageDownloader(
            session: session,
            downloadPrioritization: .fifo,
            maximumActiveDownloads: downloaderConfiguration.maxActiveDownloads,
            imageCache: AutoPurgingImageCache()
        )
    }

}
