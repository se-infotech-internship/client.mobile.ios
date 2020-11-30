//
//  UITextField+Extensions.swift
//  FineDriver
//
//  Created by Bohdan Turivniy on 30.11.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

extension UITextView {

    func addHyperLinksToText(originalText: String, hyperLinks: [String: String]) {
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        for (hyperLink, urlString) in hyperLinks {
            let linkRange = attributedOriginalText.mutableString.range(of: hyperLink)
            let fullRange = NSRange(location: 0, length: attributedOriginalText.length)
            attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: urlString, range: linkRange)
            attributedOriginalText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: fullRange)
            attributedOriginalText.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Roboto-regular", size: 14)!, range: fullRange)
    }

//    self.linkTextAttributes = [
//        .foregroundColor: ColorScheme.current.hyberlink,
//        .font: UIFont(name: "OpenSans-light", size: 10)!
//    ]
    self.attributedText = attributedOriginalText
  }
}
