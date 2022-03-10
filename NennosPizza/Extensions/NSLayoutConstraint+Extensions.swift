//
//  NSLayoutConstraint+Extension.swift
//  NennosPizza
//
//  Created by kristof on 2021. 10. 11..
//

import UIKit

extension NSLayoutConstraint {
    class func activate(_ constraints: [[NSLayoutConstraint]]) {
        NSLayoutConstraint.activate(constraints.flatMap { $0 })
    }
}
