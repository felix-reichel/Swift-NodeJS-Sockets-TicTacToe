//
//  TicTacToeView.swift
//  TicTacToe
//
//  Created by RevNex on 13.03.18.
//  Copyright © 2018 MP GmbH. All rights reserved.
//

import UIKit

class TicTacToeView: UIView {
    
    var cellSize: CGFloat = 0.0
    var dividerWidth: CGFloat = 1
    var gridSize: Int = 3
    
    weak var model: TicTacToeModel!
    
    override func draw(_ rect: CGRect) {
        
        //get cellSize
        cellSize = (bounds.width / CGFloat(gridSize))
        
        //draw dividers
        var divider = UIBezierPath(rect: CGRect(x: cellSize, y: 0, width: dividerWidth, height: bounds.height))
        divider.stroke()
        
        divider = UIBezierPath(rect: CGRect(x: cellSize*2, y: 0, width: dividerWidth, height: bounds.height))
        divider.stroke()
        
        divider = UIBezierPath(rect: CGRect(x: 0, y: cellSize, width: bounds.width, height: dividerWidth))
        divider.stroke()
        
        divider = UIBezierPath(rect: CGRect(x: 0, y: cellSize*2, width: bounds.width, height: dividerWidth))
        divider.stroke()
        
        for i in 0...2 {
            for j in 0...2 {
                
                switch model.fieldStatus[i][j] {
                    case "X" :
                        let path = UIBezierPath()
                        
                        path.move(to: CGPoint(
                            x: (CGFloat(i) * cellSize) + 2,
                            y: (CGFloat(j) * cellSize) + 2))
                        path.addLine(to: CGPoint(
                            x: (CGFloat(i) * cellSize) + cellSize - 4,
                            y: (CGFloat(j) * cellSize) + cellSize - 4))
                        
                        path.move(to: CGPoint(
                            x: (CGFloat(i) * cellSize) + 2,
                            y: (CGFloat(j) * cellSize) + 2 + cellSize - 4))
                        path.addLine(to: CGPoint(
                            x: (CGFloat(i) * cellSize) + 2 + cellSize - 4,
                            y: (CGFloat(j) * cellSize) + 2))
                        
                        path.lineWidth = 2
                        path.stroke()
                        break;
                    case "O" :
                        let path = UIBezierPath(arcCenter: CGPoint(x: ((CGFloat(i) * cellSize) + cellSize/2), y: ((CGFloat(j) * cellSize) + cellSize/2)), radius: (cellSize/2) - 2, startAngle: 0, endAngle: 360, clockwise: true)
                        path.lineWidth = 2
                        path.stroke()
                        break;
                    default:
                        break;
                    }
                
                }
        }
    }
    

}
