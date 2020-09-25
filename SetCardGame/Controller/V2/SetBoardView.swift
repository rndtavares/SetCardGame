//
//  SetBoardView.swift
//  SetCardGame
//
//  Created by Ronaldo Tavares da Silva on 03/09/2020.
//  Copyright © 2020 Ronaldo Tavares da Silva. All rights reserved.
//

import UIKit

class SetBoardView: UIView {

    var cardViews = [SetCardView]()
    
    private var gridCards: Grid?
    
    var rowsGrid : Int {
        return gridCards?.dimensions.rowCount ?? 0
    }
    
    private func layoutSetCards() {
        if let grid = gridCards {
            let columnsGrid = grid.dimensions.columnCount
            for row in 0..<rowsGrid {
                for column in 0..<columnsGrid {
                    if cardViews.count > (row * columnsGrid + column) {
                        UIViewPropertyAnimator.runningPropertyAnimator(
                            withDuration: 0.3,
                            delay: TimeInterval(row) * 0.1,
                            options: [.curveEaseInOut],
                            animations: {
                                self.cardViews[row * columnsGrid + column].frame = grid[row, column]!.insetBy(dx: Constant.spacingDx, dy: Constant.spacingDy)
                            }
                        )
                    }
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gridCards = Grid(layout: Grid.Layout.aspectRatio(Constant.cellAspectRatio), frame: bounds)
        gridCards?.cellCount = cardViews.count
        layoutSetCards()
    }
    
    func addCardViews(newCardViews: [SetCardView]) {
        cardViews += newCardViews
        newCardViews.forEach {
            (setCardView) in
                addSubview(setCardView)
        }
        layoutIfNeeded()
    }
    
    func removeCardViews(removeCardViews: [SetCardView]) {
        removeCardViews.forEach {
            (setCardView) in
            cardViews.remove(elements: [setCardView])
            setCardView.removeFromSuperview()
        }
        layoutIfNeeded()
    }
    
    func resetCards() {
        cardViews.forEach {
            (cardView) in
                cardView.removeFromSuperview()
        }
        cardViews = []
        layoutIfNeeded()
    }
    
    struct Constant {
        static let cellAspectRatio: CGFloat = 0.7
        static let spacingDx: CGFloat = 3.0
        static let spacingDy: CGFloat = 3.0
    }
}
