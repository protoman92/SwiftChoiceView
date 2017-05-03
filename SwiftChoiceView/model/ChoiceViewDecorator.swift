//
//  ChoiceViewDecorator.swift
//  SwiftChoiceView
//
//  Created by Hai Pham on 5/3/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit

/// Implement this protocol to provide appearance configurations for
/// UIBaseChoiceView subclasses.
@objc public protocol ChoiceViewDecoratorType {
    
    /// This value will be used to describe what the choices are used for.
    /// Use a default value if not implemented.
    @objc optional var choiceTitle: String { get }
    
    /// This value will be used to set the label view's height. Use a default
    /// value if not implemented.
    @objc optional var choiceTitleHeight: CGFloat { get }
    
    /// The font name to be used for the choice title label. Use a default
    /// value if not implemented.
    @objc optional var choiceTitleFontName: String { get }
    
    /// The font size to be used for the choice title label. Use a default
    /// value if not implemented.
    @objc optional var choiceTitleFontSize: CGFloat { get }
    
    /// Text alignment option for title label. By default should be .center.
    @objc optional var choiceTitleTextAlignment: NSTextAlignment { get }
    
    /// The text color to be used for the title label. Use a default value if
    /// not implemented.
    @objc optional var choiceTitleTextColor: UIColor { get }
}

public extension ChoiceViewDecoratorType {
    
    /// Get the font to be used for the choice title label.
    public var choiceTitleFont: UIFont? {
        let fontName = choiceTitleFontName ?? ""
        let fontSize = choiceTitleFontSize ?? 0
        return UIFont(name: fontName, size: fontSize)
    }
}
