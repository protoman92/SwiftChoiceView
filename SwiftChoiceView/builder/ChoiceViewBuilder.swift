//
//  ChoiceViewBuilder.swift
//  SwiftChoiceView
//
//  Created by Hai Pham on 5/1/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftBaseViews
import SwiftUIUtilities
import SwiftUtilities
import UIKit

/// Implement this protocol to provide subviews for a UIChoiceView instance.
@objc public protocol ChoiceViewBuilderType: ViewBuilderType {
    
    /// Initialize with an optional ChoiceViewDecoratorType instance. If this
    /// is nil, use default values.
    ///
    /// - Parameter decorator: A ChoiceViewDecoratorType instance.
    init(with decorator: ChoiceViewDecoratorType?)
    
    /// Access the decorator that was set above.
    var decorator: ChoiceViewDecoratorType? { get }
}

/// This class will be the default builder whenever a ChoiceViewBuilderType is
/// required.
open class ChoiceViewBuilder {
    public let decorator: ChoiceViewDecoratorType?
    
    public required init(with decorator: ChoiceViewDecoratorType?) {
        self.decorator = decorator
    }
    
    // MARK: ViewBuilderType.
    
    /// Get an Array of UIView subviews to be added to a UIView.
    /// - Parameter view: The parent UIView instance.
    /// - Returns: An Array of ViewBuilderComponentType.
    open func subviews(for view: UIView) -> [UIView] {
        var subviews = [UIView]()
        subviews.append(choiceList())
        
        if let titleLabel = self.titleLabel() {
            subviews.append(titleLabel)
        }
        
        return subviews
    }
    
    /// Create a UIChoiceListView instance to be added to the parent UIView.
    ///
    /// - Returns: A ViewBuilderComponent instance.
    open func choiceList() -> UIChoiceListView {
        let layout = UICollectionViewFlowLayout()
        let frame = CGRect.zero
        let choiceList = UIChoiceListView(frame: frame, collectionViewLayout: layout)
        choiceList.accessibilityIdentifier = choiceListId
        return choiceList
    }
    
    /// Create a UILabel instance to be used as the choice title. We only
    /// create a label if there is a valid title i.e. non-empty string.
    ///
    /// - Returns: A UILabel instance.
    open func titleLabel() -> UILabel? {
        if hasTitle {
            let label = UIBaseLabel()
            label.accessibilityIdentifier = choiceTitleId
            return label
        } else {
            return nil
        }
    }
    
    /// Get an Array of NSLayoutConstraint to be added to a UIView.
    ///
    /// - Parameter view: The parent UIView instance.
    /// - Returns: An Array of NSLayoutConstraint.
    open func constraints(for view: UIView) -> [NSLayoutConstraint] {
        let subviews = view.subviews
        
        var allConstraints = [NSLayoutConstraint]()
        
        if let choiceList = subviews.filter({
            $0.accessibilityIdentifier == choiceListId
        }).first {
            let cs = constraints(forChoiceList: choiceList, for: view)
            allConstraints.append(contentsOf: cs)
        }
        
        if let titleLabel = subviews.filter({
            $0.accessibilityIdentifier == choiceTitleId
        }).first {
            let cs = constraints(forTitleLabel: titleLabel, for: view)
            allConstraints.append(contentsOf: cs)
        }
        
        return allConstraints
    }
    
    /// Create an Array of NSLayoutConstraint for the choice list view.
    ///
    /// - Parameters:
    ///   - choiceList: A UIView instance.
    ///   - view: The parent UIView instance.
    /// - Returns: An Array of NSLayoutConstraint.
    open func constraints(forChoiceList choiceList: UIView, for view: UIView)
        -> [NSLayoutConstraint]
    {
        var constraints = [NSLayoutConstraint]()
        
        let fitConstraintBuilder = FitConstraintSet
            .builder()
            .with(parent: view)
            .with(child: choiceList)
            .add(left: true)
            .add(right: true)
            .add(bottom: true)
        
        if let titleLabel = view.subviews.filter({
            $0.accessibilityIdentifier == choiceTitleId
        }).first {
            let top = NSLayoutConstraint(item: choiceList,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: titleLabel,
                                         attribute: .bottom,
                                         multiplier: 1,
                                         constant: Space.small.value ?? 0)
            
            constraints.append(top)
        } else {
            _ = fitConstraintBuilder.add(top: true)
        }
        
        let fitConstraints = fitConstraintBuilder.build().constraints
        constraints.append(contentsOf: fitConstraints)
        return constraints
    }
    
    /// Create an Array of NSLayoutConstraint for the title label.
    ///
    /// - Parameters:
    ///   - label: A UILabel instance.
    ///   - view: The parent UIView instance.
    /// - Returns: An Array of NSLayoutConstraint.
    open func constraints(forTitleLabel label: UIView, for view: UIView)
        -> [NSLayoutConstraint]
    {
        var constraints = [NSLayoutConstraint]()
        
        let fitConstraints = FitConstraintSet.builder()
            .with(parent: view)
            .with(child: label)
            .add(top: true)
            .add(left: true)
            .add(right: true)
            .build()
            .constraints
        
        let height = NSLayoutConstraint(item: label,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1,
                                        constant: choiceTitleHeight)
        
        constraints.append(contentsOf: fitConstraints)
        constraints.append(height)
        return constraints
    }
    
    // MARK: ViewBuilderConfigType.
    
    /// Configure the current UIView, after populating it with a
    /// ViewBuilderType.
    ///
    /// - Parameter view: The UIView to be configured.
    open func configure(for view: UIView) {
        let subviews = view.subviews
        
        if let choiceList = subviews.filter({
            $0.accessibilityIdentifier == choiceListId
        }).first as? UIChoiceListView {
            configure(choiceList: choiceList, using: self)
        }
        
        if let titleLabel = subviews.filter({
            $0.accessibilityIdentifier == choiceTitleId
        }).first as? UILabel {
            configure(choiceTitle: titleLabel, using: self)
        }
    }
    
    /// Configure the title label using a ChoiceViewDecoratorType instance.
    ///
    /// - Parameters:
    ///   - title: A UILabel instance.
    ///   - decorator: A ChoiceViewDecoratorType instance.
    open func configure(choiceTitle title: UILabel,
                        using decorator: ChoiceViewDecoratorType) {
        title.text = decorator.choiceTitle
        title.textAlignment = decorator.choiceTitleTextAlignment ?? .center
        title.textColor = decorator.choiceTitleTextColor
        title.font = decorator.choiceTitleFont
    }
    
    /// Configure the choice list using a ChoiceViewDecoratorType instance.
    ///
    /// - Parameters:
    ///   - choiceList: A UIChoiceListView instance.
    ///   - decorator: A ChoiceViewDecoratorType instance.
    open func configure(choiceList: UIChoiceListView,
                        using decorator: ChoiceViewDecoratorType) {
        choiceList.decorator = decorator
    }
}

extension ChoiceViewBuilder: ChoiceViewBuilderType {}
extension ChoiceViewBuilder: ChoiceViewIdentifierType {}
extension ChoiceViewBuilder: ChoiceViewDecoratorType {
    
    /// Use a default value if the decorator does not produce any title String.
    public var choiceTitle: String {
        return decorator?.choiceTitle ?? ""
    }
    
    /// Use a default value if not implemented.
    public var choiceTitleHeight: CGFloat {
        return decorator?.choiceTitleHeight ?? Size.medium.value ?? 0
    }
    
    /// Use a default value if not implemented.
    public var choiceTitleFontName: String {
        return decorator?.choiceTitleFontName ?? DefaultFont.bold.value
    }
    
    /// Use a default value if not implemented.
    public var choiceTitleFontSize: CGFloat {
        return decorator?.choiceTitleFontSize ?? TextSize.largest.value ?? 0
    }
    
    /// Use a default value if not implemented.
    public var choiceTitleTextColor: UIColor {
        return decorator?.choiceTitleTextColor ?? .darkGray
    }
    
    public var choiceTitleTextAlignment: NSTextAlignment {
        return decorator?.choiceTitleTextAlignment ?? .center
    }
}

public extension ChoiceViewBuilder {
    
    /// Check if the builder produces any valid title string.
    public var hasTitle: Bool { return choiceTitle.isNotEmpty }
}
