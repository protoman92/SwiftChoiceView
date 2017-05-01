//
//  ChoiceViewBuilder.swift
//  SwiftChoiceView
//
//  Created by Hai Pham on 5/1/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftBaseViews
import SwiftUIUtilities
import UIKit

/// Implement this protocol to provide subviews for a UIChoiceView instance.
public protocol ChoiceViewBuilderType: ViewBuilderType {
    
}

/// This class will be the default builder whenever a ChoiceViewBuilderType is
/// required.
open class ChoiceViewBuilder {
    
    // MARK: ViewBuilderType.
    
    /// Get an Array of UIView subviews to be added to a UIView.
    /// - Parameter view: The parent UIView instance.
    /// - Returns: An Array of ViewBuilderComponentType.
    open func subviews(for view: UIView) -> [UIView] {
        return [choiceList()]
    }
    
    /// Create a UIChoiceListView instance to be added to the parent UIView.
    ///
    /// - Returns: A ViewBuilderComponent instance.
    open func choiceList() -> UIChoiceListView {
        let choiceList = UIChoiceListView(
            frame: CGRect.zero,
            collectionViewLayout: UICollectionViewLayout()
        )
        
        choiceList.accessibilityIdentifier = choiceListId
        return choiceList
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
        return FitConstraintSet
            .fit(forParent: view, andChild: choiceList)
            .constraints
    }
    
    // MARK: ViewBuilderConfigType.
    
    /// Configure the current UIView, after populating it with a
    /// ViewBuilderType.
    ///
    /// - Parameter view: The UIView to be configured.
    open func configure(for view: UIView) {}
}

extension ChoiceViewBuilder: ChoiceViewBuilderType {}
extension ChoiceViewBuilder: ChoiceViewIdentifierType {}
