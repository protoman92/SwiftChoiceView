//
//  ChoiceItemDecorator.swift
//  SwiftChoiceView
//
//  Created by Hai Pham on 5/1/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit

/// Implement this protocol to provide configurations for each choice item
/// view's appearance.
@objc public protocol ChoiceItemDecoratorType {
    
    /// If this is not declared, use a default value.
    @objc optional var choiceItemBackgroundColor: UIColor { get }
    
    /// If this is not declared, use a default value.
    @objc optional var choiceItemTitleFontName: String { get }
    
    /// If this is not declared, use a default value (most preferably
    /// TextSize.medium.value).
    @objc optional var choiceItemTitleFontSize: CGFloat { get }
    
    /// If this is not declared, use a default value.
    @objc optional var choiceItemTitleTextColor: UIColor { get }
    
    /// If this is not declared, use a default value.
    @objc optional var choiceItemHighlightedColor: UIColor { get }
    
    /// If this is not declared, use a default value.
    @objc optional var choiceItemHighlightedTextColor: UIColor { get }
}

public extension ChoiceItemDecoratorType {
    
    /// Use this UIFont instance for the choice label.
    public var choiceItemTitleFont: UIFont? {
        let fontName = choiceItemTitleFontName ?? ""
        let fontSize = choiceItemTitleFontSize ?? 0
        return UIFont(name: fontName, size: fontSize)
    }
}
