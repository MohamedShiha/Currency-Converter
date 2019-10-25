//
//  PaddedLabel.swift
//  Currency Converter
//
//  Created by Mohamed Shiha on 9/5/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class PaddedLabel: UILabel {
    
    private var padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
}
