//
//  PaddedTextField.swift
//  Currency Converter
//
//  Created by Mohamed Shiha on 9/4/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class PaddedTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
