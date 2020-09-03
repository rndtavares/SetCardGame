//
//  SetCardViewController.swift
//  SetCardGame
//
//  Created by Ronaldo Tavares da Silva on 01/09/2020.
//  Copyright © 2020 Ronaldo Tavares da Silva. All rights reserved.
//

import UIKit

class SetCardView: UIView {
    
    var card = Card(shape: Shape.oval,
                    color: Color.green,
                    shading: Shading.filled,
                    numberOfShapes: NumberOfShapes.two,
                    selected: false, matched: false,
                    mismatched: false, hided: false)
    
    enum BorderType {
        case selected
        case matched
        case mismatched
        case none
    }
    
    override func draw(_ rect: CGRect) {
        let button = UIButton(frame: rect)
        let attributes = getAttibutes(card)
        let text = getText(card)
        let attibutedString = NSAttributedString(string: text, attributes: attributes)
        button.setAttributedTitle(attibutedString, for: UIControl.State.normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        if card.selected {
            if card.matched {
                if card.hided {
                    hideButton(button)
                    makeBorder(BorderType.none, button)
                } else {
                    makeBorder(BorderType.matched, button)
                }
            } else if card.mismatched {
                makeBorder(BorderType.mismatched, button)
            } else {
                makeBorder(BorderType.selected, button)
            }
        } else {
            makeBorder(BorderType.none, button)
        }
        
        button.draw(bounds)
    }
    
    private func makeBorder(_ type: BorderType, _ button: UIButton){
        switch type {
        case .selected:
            button.layer.borderWidth = 3.0
            button.layer.borderColor = UIColor.blue.cgColor
        case .matched:
            button.layer.borderWidth = 5.0
            button.layer.borderColor = UIColor.green.cgColor
        case .mismatched:
            button.layer.borderWidth = 5.0
            button.layer.borderColor = UIColor.red.cgColor
        case .none:
            button.layer.borderWidth = 0.0
            button.layer.borderColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0)
        }
    }
    
    private func hideButton(_ button: UIButton){
        button.setAttributedTitle(nil, for: UIControl.State.normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0)
    }
    
    private func getAttibutes(_ card: Card) -> [NSAttributedString.Key:Any] {
        var attributes: [NSAttributedString.Key:Any] = [:]
        let color = getColor(card)
        switch card.shading {
        case .filled:
            attributes = [
                .strokeWidth : -5.0,
                .font : UIFont.systemFont(ofSize: 28),
                .foregroundColor : color.withAlphaComponent(100.0)
            ]
        case .outline:
            attributes = [
                .strokeWidth : 10.0,
                .font : UIFont.systemFont(ofSize: 28),
                .foregroundColor : color
            ]
        case .striped:
            attributes = [
                .strokeWidth : 0.0,
                .font : UIFont.systemFont(ofSize: 28),
                .foregroundColor : color.withAlphaComponent(0.15)
            ]
        }
        return attributes
    }
    
    private func getColor(_ card: Card) -> UIColor {
        switch card.color {
        case .red:
            return UIColor.red
        case .green:
            return UIColor.green
        case .purple:
            return UIColor.purple
        }
    }
    
    private func getText(_ card: Card) -> String{
        var text = ""
        for _ in 0..<card.numberOfShapes.rawValue {
            text += card.shape.description
        }
        return text
    }


}
