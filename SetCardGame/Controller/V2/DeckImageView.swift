//
//  DeckImageView.swift
//  SetCardGame
//
//  Created by Ronaldo Tavares da Silva on 23/09/2020.
//  Copyright © 2020 Ronaldo Tavares da Silva. All rights reserved.
//

import UIKit
@IBDesignable
class DeckImageView: UIImageView {

    @IBInspectable
    var deckNumberString: String = "81" { didSet { setNeedsDisplay(); setNeedsLayout()}}
    
    private func centeredAttributedString(_ string:String, fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize).bold()
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [.paragraphStyle:paragraphStyle,.font:font])
    }
    
    private var labelFontSize: CGFloat {
        if UIScreen.main.traitCollection.verticalSizeClass == .regular && UIScreen.main.traitCollection.horizontalSizeClass == .regular {
            return bounds.size.height * 0.5
        }
        return bounds.size.height * 0.3
    }
    
    private var numberString: NSAttributedString {
        return centeredAttributedString(deckNumberString, fontSize: labelFontSize)
    }
    
    private lazy var deckNumberLabel = createNumberLabel()
    
    private func createNumberLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.white
        addSubview(label)
        return label
    }
    
    private func configureNumberLabel(_ label: UILabel) {
        label.attributedText = numberString
        label.frame.size = CGSize.zero
        label.sizeToFit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureNumberLabel(deckNumberLabel)
        deckNumberLabel.center = bounds.origin.offsetBY(dx: bounds.size.width/2, dy: bounds.size.height/2)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsLayout()
    }
    
    override func draw(_ rect: CGRect) {
        if let cardBackImage = UIImage(named: "Deal Deck", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
            cardBackImage.draw(in: bounds)
        }
    }
}

extension UIFont {
    func withTraits(traits:UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //0 equals keep the same size
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
    
    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}
