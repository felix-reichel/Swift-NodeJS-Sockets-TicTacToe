//
//  TTTField.swift
//  TicTacToe
//
//  Created by RevNex on 08.04.18.
//  Copyright © 2018 MP GmbH. All rights reserved.
//

import Foundation
import UIKit

struct TTTField {
    var rect: CGRect
    var fieldValue: String = ""
    
    init(rect: CGRect) {
        self.rect = rect
    }
}
