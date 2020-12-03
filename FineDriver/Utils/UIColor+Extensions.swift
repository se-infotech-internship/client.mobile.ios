//
//  UIColor+Extensions.swift
//  FineDriver
//
//  Created by Bohdan Turivniy on 01.12.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
 
    convenience init(hex: String) {
        let hex = hex.replacingOccurrences(of: "#", with: "")
        
        guard hex.count == 6 else {
            self.init(white: 1.0, alpha: 1.0)
            return
        }
        
        self.init(
            red:   CGFloat((Int(hex, radix: 16)! >> 16) & 0xFF) / 255.0,
            green: CGFloat((Int(hex, radix: 16)! >> 8) & 0xFF) / 255.0,
            blue:  CGFloat((Int(hex, radix: 16)!) & 0xFF) / 255.0, alpha: 1.0
        )
    }

}
