//
//  Codable.swift
//  DepoSwiftExtensions
//
//  Created by Dominik Pethö on 11/9/18.
//

import Foundation

// MARK: - Encodable extensions

public extension Encodable {
    
    func jsonDictionary(encoder: JSONEncoder) -> [String: Any]? {
        guard let data = try? encoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
}

// MARK: - Encodable extensions

public protocol GREncodable: Encodable {
    
    var encoder: JSONEncoder { get }
    var keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy { get }
    var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy { get }
    
}

private var referenceKeyEncoder: UInt8 = 11

public extension GREncodable {
    
    var keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy {
        return JSONEncoder.KeyEncodingStrategy.useDefaultKeys
    }
    
    private var _encoder: JSONEncoder? {
        return (objc_getAssociatedObject(self, &referenceKeyEncoder) as? JSONEncoder)
    }
    
    
    func encode() throws -> Data {
        return try encoder.encode(self)
    }
    
    var encoder: JSONEncoder {
        initEncoderIfNeeded()
        let encoder = _encoder ?? JSONEncoder()
        encoder.keyEncodingStrategy = keyEncodingStrategy
        encoder.dateEncodingStrategy = dateEncodingStrategy
        return encoder
    }
    
    var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy {
        return JSONEncoder.DateEncodingStrategy.millisecondsSince1970
    }
    
    private func initEncoderIfNeeded() {
        if _encoder == nil {
            objc_setAssociatedObject(self, &referenceKeyEncoder, JSONEncoder(), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

public extension GREncodable {
    
    var jsonDictionary: [String: Any]? {
        guard let data = try? encoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
}

// MARK: - GRCodable

public protocol GRDecodable: Decodable {
    
    static var decoder: JSONDecoder { get }
    static var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy { get }
    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get }
    
}

private var referenceKeyDecoder: UInt8 = 10

extension GRDecodable {
    
    public static var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy {
        return JSONDecoder.KeyDecodingStrategy.useDefaultKeys
    }
    
    private static var _decoder: JSONDecoder? {
        return (objc_getAssociatedObject(self, &referenceKeyDecoder) as? JSONDecoder)
    }
    
    public static func decode(data: Data) throws -> Self {
        return try decoder.decode(Self.self, from: data)
    }
    
    public static var decoder: JSONDecoder {
        initDecoderIfNeeded()
        let decoder = _decoder ?? JSONDecoder()
        decoder.keyDecodingStrategy = keyDecodingStrategy
        decoder.dateDecodingStrategy = dateDecodingStrategy
        return decoder
    }
    
    public static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        return JSONDecoder.DateDecodingStrategy.millisecondsSince1970
    }
    
    private static func initDecoderIfNeeded() {
        if _decoder == nil {
            objc_setAssociatedObject(self, &referenceKeyDecoder, JSONDecoder(), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

public typealias GRCodable = GREncodable & GRDecodable
