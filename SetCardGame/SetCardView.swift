//
//  SetCardViewController.swift
//  SetCardGame
//
//  Created by Ronaldo Tavares da Silva on 01/09/2020.
//  Copyright © 2020 Ronaldo Tavares da Silva. All rights reserved.
//

import UIKit

@IBDesignable
class SetCardView: UIView {

    @IBInspectable
    var faceBackgroundColor: UIColor = UIColor.white { didSet { setNeedsDisplay()}}
    
    @IBInspectable
    var isFaceUp: Bool = true { didSet {setNeedsDisplay(); setNeedsLayout() }}
    
    var isMatched: Bool? { didSet { setNeedsDisplay(); setNeedsLayout()}}
    
    private enum Symbol: Int {
        case diamond
        case squiggle
        case oval
    }
    
    private enum Fill: Int {
        case empty
        case stripes
        case solid
    }
    
    private struct Colors {
        static let green = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
        static let red = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        static let purple = #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1)
        
        static let selected = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1).cgColor
        static let matched = #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1).cgColor
        static var misMatched = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        static let hint = #colorLiteral(red: 1, green: 0.5212053061, blue: 1, alpha: 1).cgColor
    }
    
    private var symbol = Symbol.squiggle {
        didSet { setNeedsDisplay(); setNeedsLayout()}
    }
    
    private var fill = Fill.stripes {
        didSet { setNeedsDisplay(); setNeedsLayout()}
    }
    
    private var color = Colors.red {
        didSet { setNeedsDisplay(); setNeedsLayout()}
    }
    
    @IBInspectable
    var count: Int = 1 {
        didSet { setNeedsDisplay(); setNeedsLayout()}
    }

    @IBInspectable
    var symbolInt: Int = 1 { didSet {
        switch symbolInt {
            case 1: symbol = .squiggle
            case 2: symbol = .oval
            case 3: symbol = .diamond
            default: break
        }
        }}
    
    @IBInspectable
    var fillInt: Int = 1 { didSet {
        switch fillInt {
        case 1: fill = .empty
        case 2: fill = .stripes
        case 3: fill = .solid
        default: break
        }
        }}
    
    @IBInspectable
    var colorInt: Int = 1 { didSet {
        switch colorInt {
        case 1: color = Colors.green
        case 2: color = Colors.red
        case 3: color = Colors.purple
        default: break
        }
        }}
    
    private struct SizeRatio {
        static let pinFontSizeToBoundsHeight: CGFloat = 0.09
        static let maxFaceSizeToBoundsSize: CGFloat = 0.75
        static let pipHeightToFaceHeight: CGFloat = 0.25
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let pinOffset: CGFloat = 0.03
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        faceBackgroundColor.setFill()
        roundedRect.fill()
        
        if isFaceUp {
            drawPips()
        } else {
            if let cardBackImage = UIImage(named: "cardback", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                cardBackImage.draw(in: bounds)
            }
        }
    }
    
    private var maxFaceFrame: CGRect {
        return bounds.zoomed(by: SizeRatio.maxFaceSizeToBoundsSize)
    }
    
    private struct AspectRatio{
        static let faceFrame: CGFloat = 0.60
    }
    
    private var faceFrame: CGRect {
        let faceWidth = maxFaceFrame.height * AspectRatio.faceFrame
        return maxFaceFrame.insetBy(dx: (maxFaceFrame.width - faceWidth) / 2, dy: 0)
    }
    
    private var pipHeight: CGFloat {
        return faceFrame.height * SizeRatio.pipHeightToFaceHeight
    }
    
    private var interPipHeight: CGFloat {
        return (faceFrame.height - (3 * pipHeight)) / 2
    }
    
    private func drawPips(){
        color.setFill()
        color.setStroke()
        
        var origin : CGPoint
        let size = CGSize(width: faceFrame.width, height: pipHeight)
        var firstRect : CGRect
        switch count {
        case 1:
            origin = CGPoint(x: faceFrame.minX, y: faceFrame.midY - pipHeight/2)
            firstRect = CGRect(origin: origin, size: size)
            drawShape(in: firstRect)
        case 2:
            origin = CGPoint(x: faceFrame.minX, y: faceFrame.midY - interPipHeight / 2 - pipHeight)
            firstRect = CGRect(origin: origin, size: size)
            drawShape(in: firstRect)
            let secondRect = firstRect.offsetBy(dx: 0, dy: pipHeight + interPipHeight)
            drawShape(in: secondRect)
        case 3:
            origin = CGPoint(x: faceFrame.minX, y: faceFrame.minY)
            firstRect = CGRect(origin: origin, size: size)
            drawShape(in: firstRect)
            let secondRect = firstRect.offsetBy(dx: 0, dy: pipHeight + interPipHeight)
            drawShape(in: secondRect)
            let thirdRect = secondRect.offsetBy(dx: 0, dy: pipHeight + interPipHeight)
            drawShape(in: thirdRect)
        default: break
        }
    }
    
    private func drawShape(in rect: CGRect) {
        let path: UIBezierPath
        switch symbol {
        case .diamond:
            path = pathForDiamond(in: rect)
        case .oval:
            path = pathForOval(in: rect)
        case .squiggle:
            path = pathForSquiggle(in: rect)
        }
        
        path.lineWidth = 3.0
        path.stroke()
        switch fill {
        case .solid:
            path.fill()
        case .stripes:
            stripeShape(path: path, in: rect)
        default:
            break
        }
    }
    
    private func stripeShape(path: UIBezierPath, in rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        path.addClip()
        stripeRect(rect)
        context?.restoreGState()
    }
    
    private let interStripeSpace: CGFloat = 5.0
    
    private func stripeRect(_ rect: CGRect) {
        let stripe = UIBezierPath()
        stripe.lineWidth = 1.0
        stripe.move(to: CGPoint(x: rect.minX, y: bounds.minY))
        stripe.addLine(to: CGPoint(x: rect.minX, y: bounds.maxY))
        let stripeCount = Int(faceFrame.width / interStripeSpace)
        for _ in 1...stripeCount {
            let translation = CGAffineTransform(translationX: interStripeSpace, y: 0)
            stripe.apply(translation)
            stripe.stroke()
        }
    }
    
    private func pathForSquiggle(in rect: CGRect) -> UIBezierPath {
        let upperSquiggle = UIBezierPath()
        return upperSquiggle
    }
    
    private func pathForOval(in rect: CGRect) -> UIBezierPath {
        let oval = UIBezierPath()
        return oval
    }
    
    private func pathForDiamond(in rect: CGRect) -> UIBezierPath {
        let diamond = UIBezierPath()
        return diamond
    }

}

extension CGRect {
    func zoomed(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}
