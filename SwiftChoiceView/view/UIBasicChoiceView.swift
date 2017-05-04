//
//  UIBasicChoiceView.swift
//  SwiftChoiceView
//
//  Created by Hai Pham on 5/4/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftDialogController
import SwiftUIUtilities
import UIKit

/// This class should be used for simple choices, such as gender selection -
/// whereby the choices are limited and can fit in one small screen without
/// scrolling.
public final class UIBasicChoiceView: UIBaseChoiceView {
    override public var choicePresenterType: ChoicePresenter.Type {
        return Presenter.self
    }
    
    /// Throw an error if this initializer is called. This is because we
    /// are going to populate subviews in layoutSubviews().
    public convenience init(with builder: ViewBuilderType) {
        fatalError("Cannot call this initializer directly")
    }
    
    public convenience init(withDecorator decorator: ChoiceViewDecoratorType) {
        self.init()
        let builder = BasicChoiceViewBuilder(with: decorator)
        populateSubviews(with: builder)
    }
    
    /// Presenter class for UIBasicChoiceView.
    final class Presenter: ChoicePresenter {}
}

extension UIBasicChoiceView: RatioConstantDialogViewType {
    
    /// We do not want to update constraints when orientation is changed,
    /// because we want to keep the choice view's height fixed.
    public var updateConstraintsOnOrientationChanged: Bool { return false }
    
    public var longSideConstant: CGFloat {
        let totalChildHeight = subviews
            .flatMap({$0.heightConstraint})
            .map({$0.constant})
            .reduce(0, +)
        
        return totalChildHeight + 5
    }
    
    public var shortSideRatio: CGFloat { return 3 / 4 }
    
    override public func dialogConstraints(for parent: UIView, for child: UIView)
        -> [NSLayoutConstraint]
    {
        return ratioConstantConstraints(for: parent, for: child)
    }
}
