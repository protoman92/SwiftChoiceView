//
//  UIChoiceListView.swift
//  SwiftChoiceView
//
//  Created by Hai Pham on 4/29/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxSwift
import RxCocoa
import SwiftBaseViews
import SwiftUtilities
import SwiftUIUtilities
import UIKit

/// This view is responsible for displaying choices.
public final class UIChoiceListView: UIBaseCollectionView {
    override public var presenterInstance: BaseCollectionViewPresenter {
        return presenter
    }
    
    lazy var presenter: Presenter = Presenter(view: self)
    
    /// Presenter class for UIChoiceListView.
    class Presenter: BaseCollectionViewPresenter {
        
        /// Get the current ChoiceSectionHolder Array.
        public var choices: [ChoiceSectionHolder] { return rxChoices.value }
        
        /// Listen to data changes with a variable.
        fileprivate let rxChoices: Variable<[ChoiceSectionHolder]>
        
        init(view: UIChoiceListView) {
            rxChoices = Variable<[ChoiceSectionHolder]>([])
            super.init(view: view)
            view.backgroundColor = .clear
            view.register(with: UIChoiceCell.self)
            view.register(with: UIChoiceHeader.self)
            setupChoiceObserver(for: view, with: self)
        }
        
        /// Setup choice observer so that when choices are changed, we can
        /// catch the notification and perform a series of actions, e.g.
        /// reload the current collection view.
        ///
        /// - Parameters:
        ///   - view: The current UIChoiceListView instance.
        ///   - current: The current Presenter instance.
        func setupChoiceObserver(for view: UIChoiceListView,
                                 with current: Presenter) {
            rxChoices.asObservable()
                .doOnNext({[weak current, weak view] _ in
                    current?.reloadData(for: view)
                })
                .subscribe()
                .addDisposableTo(disposeBag)
        }
    }
}

public extension UIChoiceListView {
    
    /// When choices are set, pass them to the presenter.
    public var choices: [ChoiceSectionHolder] {
        get { return presenter.rxChoices.value }
        set { presenter.rxChoices.value = newValue }
    }
}

extension UIChoiceListView.Presenter {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return choices.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return choices.element(at: section)?.items.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell
    {
        let cls = UIChoiceCell.self
        
        guard
            let cell = collectionView.deque(with: cls, for: indexPath),
            let section = choices.element(at: indexPath.section),
            let choice = section.items.element(at: indexPath.row)
        else {
            debugException()
            return UICollectionViewCell()
        }
        
        let builder = choice.viewBuilder()
        cell.populateSubviews(with: builder)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let viewType = UIChoiceHeader.self
        
        guard
            let view = collectionView.deque(with: viewType, at: indexPath),
            let section = choices.element(at: indexPath.section)?.section
        else {
            return UICollectionReusableView()
        }
        
        let builder = section.viewBuilder()
        view.populateSubviews(with: builder)
        return view
    }
}

extension UIChoiceListView.Presenter {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int)
        -> CGSize
    {
        guard let _ = choices.element(at: section)?.section else {
            return CGSize.zero
        }
        
        return CGSize(width: collectionView.bounds.width, height: sectionHeight)
    }
}

extension UIChoiceListView.Presenter {
    
    /// Override this to use a default itemHeight if no decorator is set.
    override open var itemHeight: CGFloat {
        return decorator?.itemHeight ?? Size.medium.value ?? 0
    }
    
    /// Override this to use a default sectionHeight if no decorator is set.
    override open var sectionHeight: CGFloat {
        return decorator?.sectionHeight ?? Size.small.value ?? 0
    }
}

extension UIChoiceListView.Presenter: ChoiceListViewDecoratorType {}

final class UIChoiceCell: UICollectionViewCell {}
final class UIChoiceHeader: UICollectionReusableView {
    static var kind: ReusableViewKind { return .header }
}

extension UIChoiceHeader: ReusableViewIdentifierType {}
