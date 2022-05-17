//
//  Mockable.swift
//
//
//  Created by Dominik Pethö on 4/30/19.
//

import Foundation
import GoodRequestManager

public protocol Mockable {

    static func mockURL(fileName: String, bundle: Bundle) -> URL?
    static func data(fileName: String, bundle: Bundle) -> Data?
    static func decodeFromFile<T: GRDecodable>(fileName: String, bundle: Bundle) throws -> T

}

public enum  JSONTestableError: Error {

    case urlNotValid
    case emptyJsonData

}

public class MockManager: Mockable {

    public static func mockURL(fileName: String, bundle: Bundle) -> URL? {
        return bundle.url(forResource: fileName, withExtension: "json")
    }

    public static func data(fileName: String, bundle: Bundle) -> Data? {
        guard let testURL = MockManager.mockURL(fileName: fileName, bundle: bundle) else { return nil }
        return try? Data(contentsOf: testURL)
    }

    public static func decodeFromFile<T: GRDecodable>(fileName: String, bundle: Bundle) throws -> T {
        guard let testURL = MockManager.mockURL(fileName: fileName, bundle: bundle) else {
            throw JSONTestableError.urlNotValid

        }
        guard let jsonData = try? Data(contentsOf: testURL) else {
            throw JSONTestableError.emptyJsonData
        }

        return try T.decode(data: jsonData)
    }

}
