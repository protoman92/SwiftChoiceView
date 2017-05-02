//
//  ChoiceViewBuilder.swift
//  SwiftChoiceView
//
//  Created by Hai Pham on 4/29/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftBaseViews
import SwiftUIUtilities
import UIKit

/// Implement this protocol to provide view builder for choice item views,
/// e.g. each cell that is dequeued by UIChoiceListView.
public protocol ChoiceItemViewBuilderType: ViewBuilderType {
    
    /// Initialize with a ChoiceDetailType instance.
    ///
    /// - Parameter choice: A ChoiceDetailType instance.
    init(choice: ChoiceDetailType)
    
    var choice: ChoiceDetailType { get }
    
    /// This should be acquired from the choice item itself.
    var decorator: ChoiceItemDecoratorType { get }
}

/// Builder class for UIChoiceView.
open class ChoiceItemViewBuilder {
    
    public let choice: ChoiceDetailType
    
    public let decorator: ChoiceItemDecoratorType
    
    public required init(choice: ChoiceDetailType) {
        self.choice = choice
        decorator = choice.decorator
    }
    
    // MARK: ViewBuilderType
    
    /// Get an Array of UIView subviews to be added to a UIView.
    /// - Parameter view: The parent UIView instance.
    /// - Returns: An Array of ViewBuilderComponentType.
    open func subviews(for view: UIView) -> [UIView] {
        let choice = self.choice
        var subviews = [UIView]()
        subviews.append(choiceTitle(using: choice))
        return subviews
    }
    
    /// Add a choice title label.
    ///
    /// - Parameters choice: A ChoiceDetailType instance.
    /// - Returns: A UILabel instance.
    open func choiceTitle(using choice: ChoiceDetailType) -> UILabel {
        let title = UILabel()
        title.accessibilityIdentifier = choiceTitleId
        return title
    }
    
    /// Get an Array of NSLayoutConstraint to be added to a UIView.
    ///
    /// - Parameter view: The parent UIView instance.
    /// - Returns: An Array of NSLayoutConstraint.
    open func constraints(for view: UIView) -> [NSLayoutConstraint] {
        let subviews = view.subviews
        let choice = self.choice
        
        var allConstraints = [NSLayoutConstraint]()
        
        if let choiceTitle = subviews.filter({
            $0.accessibilityIdentifier == choiceTitleId
        }).first {
            let cs = constraints(forChoiceTitle: choiceTitle,
                                 for: view,
                                 using: choice)
            
            allConstraints.append(contentsOf: cs)
        }
        
        return allConstraints
    }
    
    /// Create an Array of NSLayoutConstraint for the choice title.
    ///
    /// - Parameters:
    ///   - title: A UIView instance.
    ///   - view: The parent UIView.
    ///   - choice: A ChoiceDetailType instance.
    /// - Returns: An Array of NSLayoutConstraint.
    open func constraints(forChoiceTitle title: UIView,
                          for view: UIView,
                          using choice: ChoiceDetailType)
        -> [NSLayoutConstraint]
    {
        return FitConstraintSet.builder()
            .with(parent: view)
            .with(child: title)
            .add(top: true)
            .add(bottom: true)
            .add(left: true, withMargin: Space.medium.value)
            .add(right: true)
            .build()
            .constraints
    }
    
    // MARK: ViewBuilderConfigType
    
    /// Configure the current UIView, after populating it with a
    /// ViewBuilderType.
    ///
    /// - Parameter view: The UIView to be configured.
    open func configure(for view: UIView) {
        let choice = self.choice
        let subviews = view.subviews
        
        view.backgroundColor = choiceBackgroundColor
        
        if let choiceTitle = subviews.filter({
            $0.accessibilityIdentifier == choiceTitleId
        }).first as? UILabel {
            configure(choiceTitle: choiceTitle, using: choice, using: self)
        }
    }
    
    /// Configure the choice title label.
    ///
    /// - Parameters:
    ///   - choiceTitle: A UILabel instance.
    ///   - choice: A ChoiceDetailType instance.
    ///   - decorator: A ChoiceItemDecoratorType instance.
    open func configure(choiceTitle: UILabel,
                        using choice: ChoiceDetailType,
                        using decorator: ChoiceItemDecoratorType) {
        choiceTitle.text = choice.value
        choiceTitle.textColor = decorator.choiceTitleTextColor
        choiceTitle.font = decorator.choiceTitleFont
    }
}

extension ChoiceItemViewBuilder: ChoiceItemViewBuilderType {}
extension ChoiceItemViewBuilder: ChoiceItemViewIdentifierType {}

extension ChoiceItemViewBuilder: ChoiceItemDecoratorType {
    
    public var choiceBackgroundColor: UIColor {
        return decorator.choiceBackgroundColor ?? .clear
    }
    
    public var choiceTitleFontName: String {
        return decorator.choiceTitleFontName ?? DefaultFont.normal.value
    }
    
    public var choiceTitleFontSize: CGFloat {
        return decorator.choiceTitleFontSize ?? TextSize.medium.value ?? 0
    }
    
    public var choiceTitleTextColor: UIColor {
        return decorator.choiceTitleTextColor ?? .darkGray
    }
}
