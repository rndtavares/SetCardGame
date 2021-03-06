//
//  BorderButton.swift
//  SetCardGame
//
//  Created by Ronaldo Tavares da Silva on 11/09/2020.
//  Copyright © 2020 Ronaldo Tavares da Silva. All rights reserved.
//

import UIKit

@IBDesignable class BorderButton: UIButton {

    private struct DefaultValues{
        static let cornerRadius: CGFloat = 8.0
        static let borderWidth: CGFloat = 4.0
        static let borderColor: UIColor = #colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1)
    }
    
    @IBInspectable var borderColor:UIColor = DefaultValues.borderColor {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth:CGFloat = DefaultValues.borderWidth {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = DefaultValues.cornerRadius {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    var disable: Bool {
        get {
            return !isEnabled
        }
        set {
            if newValue {
                isEnabled = false
                borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            } else {
                isEnabled = true
                borderColor = DefaultValues.borderColor
            }
        }
    }
    
    private func configure() {
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
}
