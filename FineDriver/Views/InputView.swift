//
//  InputView.swift
//  FineDriver
//
//  Created by Bohdan Turivniy on 30.11.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

enum InputTextType: Int {
    case text = 0
    case email = 1
    case password = 2
}

@IBDesignable
final class InputView: NibView {
    
    @IBOutlet fileprivate weak var textField: UITextField!
    @IBOutlet fileprivate weak var bottomView: UIView!
    @IBOutlet fileprivate weak var imgView: UIImageView!
    @IBOutlet fileprivate weak var hideButtom: UIButton!
    
    @IBInspectable var placeholder: String? {
        didSet{
            textField.placeholder = placeholder
        }
    }
    
    @IBInspectable var textType: Int = 0 {
        didSet{
            switch InputTextType(rawValue: textType) {
            case .email:
                textField.keyboardType = .emailAddress
                imgView.image = #imageLiteral(resourceName: "mail")
                break
            case .password:
                textField.keyboardType = .default
                textField.isSecureTextEntry = true
                hideButtom.isHidden = false
                imgView.image = #imageLiteral(resourceName: "lock")
                
                let rightView = UIView(frame: CGRect(x: 0,
                                                     y: 0,
                                                     width: 28,
                                                     height: 1))
                rightView.backgroundColor = UIColor.clear
                
                textField.rightView = rightView
                textField.rightViewMode = .always
                break
            default:
                textField.keyboardType = .default
                imgView.image = #imageLiteral(resourceName: "user")
                break
            }
        }
    }
    
    override func setupUI() {
        textField.delegate = self
    }
    
    //MARK:- Actions
    
    @IBAction fileprivate func hideAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        textField.isSecureTextEntry = !sender.isSelected
    }

}

//MARK:- UITextFieldDelegate

extension InputView: UITextFieldDelegate {
    
    
    
}
