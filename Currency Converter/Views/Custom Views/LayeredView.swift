//
//  LayeredView.swift
//  WeatherIO
//
//  Created by Mohamed Shiha on 8/24/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import UIKit

@IBDesignable class LayeredView: UIView {

    /* Overriding default layer class to use CAGradientLayer */
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    /* Handy accessor to avoid unnecessary casting */
    private var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
    
    /* Public properties to manipulate colors */
    @IBInspectable var firstColor: UIColor = UIColor.white {
        didSet {
            var currentColors = gradientLayer.colors
            currentColors![0] = firstColor.cgColor
            gradientLayer.colors = currentColors
        }
    }

    @IBInspectable var secondColor: UIColor = UIColor.white {
        didSet {
            var currentColors = gradientLayer.colors
            currentColors![1] = secondColor.cgColor
            gradientLayer.colors = currentColors
        }
    }

    @IBInspectable var thirdColor: UIColor = UIColor.white {
        didSet {
            var currentColors = gradientLayer.colors
            currentColors![2] = thirdColor.cgColor
            gradientLayer.colors = currentColors
        }
    }
    
    @IBInspectable var startPoint: CGPoint {
        get {
            return gradientLayer.endPoint
        }
        set {
            gradientLayer.endPoint = newValue
        }
    }
    
    @IBInspectable var endPoint: CGPoint {
        get {
            return gradientLayer.endPoint
        }
        set {
            gradientLayer.endPoint = newValue
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            gradientLayer.shadowColor = uiColor.cgColor
        }
        get {
            guard let color = gradientLayer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var shadowRadius : CGFloat {
        set {
            gradientLayer.shadowRadius = newValue
        }
        get {
            return gradientLayer.shadowRadius
        }
    }
    
    @IBInspectable var shadowOpacity : Float {
        set {
            gradientLayer.shadowOpacity = newValue
        }
        get {
            return gradientLayer.shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset : CGSize {
        set {
            gradientLayer.shadowOffset = newValue
        }
        get {
            return gradientLayer.shadowOffset
        }
    }
    
    /* Initializers overriding to have appropriately configured layer after creation */
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradient()
    }
    
    func setupGradient () {
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor, thirdColor.cgColor]

//            gradientLayer.locations = []

        /* Convert shadow into image to be cached to avoid consuming resources */
        gradientLayer.shouldRasterize = true
        gradientLayer.rasterizationScale = UIScreen.main.scale
    }
}

