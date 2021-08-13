//
//  NSAttributedString.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

#if !os(macOS)

import Foundation
import UIKit
import GRCompatible

public extension GRActive where Base: NSAttributedString {

    static func from(html: String?, font: (regular: UIFont, bold: UIFont), color: UIColor, documentAttributes: AutoreleasingUnsafeMutablePointer<NSDictionary?>? = nil) -> NSAttributedString? {
        return from(html: html, font: font, size: font.regular.pointSize, color: color, documentAttributes: documentAttributes)
    }

    static func from(html: String?, font: (regular: UIFont, bold: UIFont)?, size: CGFloat, color: UIColor,
                            documentAttributes: AutoreleasingUnsafeMutablePointer<NSDictionary?>? = nil) -> NSAttributedString? {
        guard let html = html, !html.isEmpty else {
            return nil
        }

        var htmlWithFontType = ""

        if let font = font {
            htmlWithFontType = "<html><style>*{font-family: \(font.regular.fontName), -apple-system, HelveticaNeue !important; font-size: \(size) !important;}</style>\(html)</html>"
        } else {
            htmlWithFontType = "<html><style>*{font-family: -apple-system, HelveticaNeue !important; font-size: \(size) !important;}</style>\(html)</html>"
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.html.rawValue,
                                                                           .characterEncoding: String.Encoding.utf8.rawValue]
        // Parse HTML
        guard let parsedHTML = try? NSAttributedString(data: htmlWithFontType.data(using: .unicode, allowLossyConversion: false)!,
                                                       options: options,
                                                       documentAttributes: documentAttributes).mutableCopy() as? NSMutableAttributedString else {
            return nil
        }

        // Correct Bold Font
        if let font = font {
            parsedHTML.enumerateAttribute(.font, in: NSRange(location: 0, length: parsedHTML.length), options: .longestEffectiveRangeNotRequired) { value, range, _ in
                if let currentFont = value as? UIFont {
                    if currentFont.fontName.contains("bold") || currentFont.fontName.contains("Bold") {
                        parsedHTML.gr.setFont(font.bold, range: range)
                    }
                }
            }
        }

        // Correct Foreground Color
        parsedHTML.gr.setColor(color)

        return parsedHTML
    }

}

public extension GRActive where Base: NSMutableAttributedString {

    func addLink(URL: String, toText text: String) -> Bool {
        let range = base.mutableString.range(of: text)
        if range.location != NSNotFound {
            base.addAttribute(.link, value: URL, range: range)
            return true
        }
        return false
    }

    @discardableResult
    func append(string: NSAttributedString) -> NSMutableAttributedString {
        base.append(string)
        return base
    }

    @discardableResult
    func append(string: String) -> NSMutableAttributedString {
        return append(string: NSAttributedString(string: string))
    }

    // MARK: Color

    @discardableResult
    func setColor(_ color: UIColor, range: NSRange) -> NSMutableAttributedString {
        base.addAttributes([.foregroundColor: color], range: range)
        return base
    }

    @discardableResult
    func setColor(_ color: UIColor) -> NSMutableAttributedString {
        return setColor(color, range: NSRange(location: 0, length: base.string.count))
    }

    // MARK: Font

    @discardableResult
    func setFont(_ font: UIFont, range: NSRange) -> NSMutableAttributedString {
        base.addAttributes([.font: font], range: range)
        return base
    }

    @discardableResult
    func setFont(_ font: UIFont) -> NSMutableAttributedString {
        return setFont(font, range: NSRange(location: 0, length: base.string.count))
    }

    // MARK: Text Alignment

    @discardableResult
    func setTextAlignment(_ alignment: NSTextAlignment, range: NSRange) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        base.addAttributes([.paragraphStyle: style], range: range)
        return base
    }

    func setTextAlignment(_ alignment: NSTextAlignment) -> NSMutableAttributedString {
        return setTextAlignment(alignment, range: NSRange(location: 0, length: base.string.count))
    }

}

#endif
