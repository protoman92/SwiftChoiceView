//
//  BasicChoiceViewBuilder.swift
//  SwiftChoiceView
//
//  Created by Hai Pham on 5/4/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit

/// Builder class for UIBasicChoiceView.
open class BasicChoiceViewBuilder: ChoiceViewBuilder {
    
    /// Create an Array of NSLayoutConstraint to be used with choice list.
    /// We introduce a height constraint here.
    ///
    /// - Parameters:
    ///   - choiceList: An UIView instance.
    ///   - view: The parent UIView instance.
    /// - Returns: An Array of NSLayoutConstraint.
    override open func constraints(forChoiceList choiceList: UIView,
                                   for view: UIView) -> [NSLayoutConstraint] {
        var constraints = super.constraints(forChoiceList: choiceList, for: view)
        
        // Since we expect UIBasicChoiceView to receive a limited set of 
        // choices that can be displayed completely on the screen without
        // scrolling, we add a height constraint to the choice list. This
        // height constraint will need to be updated every time the choices
        // are updated.
        let heightConstraint = NSLayoutConstraint(item: choiceList,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1,
                                                  constant: 0)
        
        constraints.append(heightConstraint)
        return constraints
    }
}
