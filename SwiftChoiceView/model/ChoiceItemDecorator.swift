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
    @objc optional var choiceBackgroundColor: UIColor { get }
    
    /// If this is not declared, use a default value.
    @objc optional var choiceTitleFontName: String { get }
    
    /// If this is not declared, use a default value (most preferably
    /// TextSize.medium.value).
    @objc optional var choiceTitleFontSize: CGFloat { get }
    
    /// If this is not declared, use a default value.
    @objc optional var choiceTitleTextColor: UIColor { get }
}

public extension ChoiceItemDecoratorType {
    
    /// Use this UIFont instance for the choice label.
    public var choiceTitleFont: UIFont? {
        let fontName = choiceTitleFontName ?? ""
        let fontSize = choiceTitleFontSize ?? 0
        return UIFont(name: fontName, size: fontSize)
    }
}
