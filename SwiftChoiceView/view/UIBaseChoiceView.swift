//
//  UIBaseChoiceView.swift
//  SwiftChoiceView
//
//  Created by Hai Pham on 5/1/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxSwift
import SwiftBaseViews
import SwiftDialogController
import SwiftUIUtilities
import UIKit

/// Implement this protocol to provide presenter interface for choice views.
public protocol ChoicePresenterType { init(view: UIBaseChoiceView) }

/// Implement this protocol to provide delegation interface for 
/// UIBaseChoiceView. Since we intend to use it with UIDialogController, we
/// can ask this delegate to implement OrientationDetectorType as well
@objc public protocol UIBaseChoiceViewDelegate: class, OrientationDetectorType {}

/// Base choice view class that can be extended to conform to DialogViewType.
/// For e.g. if we want to have a simple choice list view, define a sublass
/// and make it conform to RatioDialogViewType.
public class UIBaseChoiceView: UIView {
    
    /// Override this variable to provide custom presenter type.
    open var choicePresenterType: ChoicePresenter.Type {
        return ChoicePresenter.self
    }
    
    public lazy var choicePresenter
        : ChoicePresenter
        = self.choicePresenterType.init(view: self)
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        choicePresenter.layoutSubviews(for: self)
    }
}

/// Presenter class for UIBaseChoiceView. We separate it from UIBaseChoiceView
/// so that choice view subclasses can easily override and provide their own
/// presenters.
open class ChoicePresenter: BaseViewPresenter {
    weak var orientationDetector: OrientationDetectorType?
    
    /// This servers as both the delegate and the orientation detector.
    weak var choiceDelegate: UIBaseChoiceViewDelegate?
    
    public let disposeBag = DisposeBag()
    
    public required init(view: UIBaseChoiceView) {
        super.init(view: view)
    }
}

public extension UIBaseChoiceView {
    
    /// Get the choice list view from subviews.
    public var choiceListView: UIChoiceListView? {
        return subviews.flatMap({$0 as? UIChoiceListView}).first
    }
    
    /// When choices are set, pass them to the choice list view so that it
    /// can be reloaded.
    public var choices: [ChoiceSectionHolder] {
        get { return choiceListView?.choices ?? [] }
        set { choiceListView?.choices = newValue }
    }
    
    /// When choiceDelegate is set, pass it to the presenter.
    public var choiceDelegate: UIBaseChoiceViewDelegate? {
        get { return choicePresenter.choiceDelegate }
        set { choicePresenter.choiceDelegate = newValue }
    }
    
    /// Subscribe to this Observable to receive selection notifications.
    public var rxSelection: Observable<ChoiceDetailType> {
        return choiceListView?.rxSelection ?? Observable.empty()
    }
}

extension UIBaseChoiceView: DialogViewType {
    public weak var orientationDetector: OrientationDetectorType? {
        return choicePresenter.choiceDelegate
    }
    
    /// Create an Array of NSLayoutConstraint to attach to the dialog
    /// controller's main view.
    ///
    /// - Parameters:
    ///   - parent: The parent UIView instance.
    ///   - child: The current dialog view instance.
    /// - Returns: An Array of NSLayoutConstraint.
    public func dialogConstraints(for parent: UIView, for child: UIView)
        -> [NSLayoutConstraint]
    {
        return []
    }
}

extension ChoicePresenter: ChoicePresenterType {}
extension ChoicePresenter: ChoiceViewIdentifierType {}
