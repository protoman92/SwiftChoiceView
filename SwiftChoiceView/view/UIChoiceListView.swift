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
            view.register(with: UIChoiceCell.self)
            view.dataSource = self
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
                .doOnNext({[weak self, weak view] _ in
                    self?.reloadData(for: view)
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

extension UIChoiceListView.Presenter: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return choices.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return choices.element(at: section)?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell
    {
        let cls = UIChoiceCell.self
        
        guard
            let cell = collectionView.deque(with: cls, for: indexPath),
            let section = choices.element(at: indexPath.section),
            let choice = section.items.element(at: indexPath.row)
        else {
            return UICollectionViewCell()
        }
        
        let builder = choice.viewBuilder()
        cell.populateSubviews(with: builder)
        return cell
    }
}

extension UIChoiceListView.Presenter: ChoiceListViewDecoratorType {}

final class UIChoiceCell: UICollectionViewCell {}
