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
            view.allowsSelection = true
            view.allowsMultipleSelection = false
            view.showsHorizontalScrollIndicator = false
            view.showsVerticalScrollIndicator = false
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
                .doOnNext({[weak current, weak view] in
                    current?.updateHeight(for: view, using: $0, with: current)
                })
                .subscribe()
                .addDisposableTo(current.disposeBag)
        }
        
        /// Highlight a cell once it is selected, or unhighlight it if it is
        /// not. The arguments are optional because we are weakly referencing
        /// them in order to avoid strong captures.
        ///
        /// - Parameters:
        ///   - selected: A Bool value.
        ///   - cell: A UICollectionViewCell instance.
        ///   - indexPath: The current IndexPath of the cell. This value
        ///                will be used as a backup when indexPath(for:)
        ///                returns nil (e.g. when the cell is being reused
        ///                and dequeued, but is not yet visible, while the 
        ///                collectionView is bouncing up after being flung up).
        ///   - view: The current UICollectionView instance.
        ///   - current: The current Presenter instance.
        func onCellSelectionChanged(toBe selected: Bool,
                                    for cell: UICollectionViewCell?,
                                    at indexPath: IndexPath?,
                                    with view: UICollectionView?,
                                    with current: Presenter?) {
            guard
                let current = current,
                let cell = cell,
                let indexPath = view?.indexPath(for: cell) ?? indexPath,
                let choice = current.choices
                    .element(at: indexPath.section)?
                    .items.element(at: indexPath.row),
                let itemTitle = cell.subviews.filter({
                    $0.accessibilityIdentifier == current.choiceItemTitleId
                }).first as? UILabel
            else {
                return
            }

            let decorator = choice.decorator
            let background: UIColor
            let textColor: UIColor
            
            if selected {
                background = decorator.choiceItemHighlightedColor ?? .darkGray
                textColor = decorator.choiceItemHighlightedTextColor ?? .white
            } else {
                background = .clear
                textColor = decorator.choiceItemTitleTextColor ?? .darkGray
            }
            
            let animations: () -> Void = {
                cell.layer.backgroundColor = background.cgColor
                itemTitle.textColor = textColor
            }
            
            // Use a transition animation to animate background color changes.
            UIView.transition(with: cell,
                              duration: Duration.short.rawValue,
                              options: .curveEaseInOut,
                              animations: animations,
                              completion: nil)
        }
        
        /// Setup the selection observer for each cell. When a cell is selected
        /// or deselected, we mark it with a different background color and 
        /// change its text color as well.
        ///
        /// This method needs to be called on each cell that is dequeued.
        ///
        /// - Parameters:
        ///   - cell: A UIChoiceCell instance.
        ///   - indexPath: The cell's index path.
        ///   - view: A UICollectionView instance.
        ///   - current: The current Presenter instance.
        func setupSelectionObserver(for cell: UIChoiceCell,
                                    at indexPath: IndexPath,
                                    with view: UICollectionView,
                                    with current: Presenter) {
            cell.selectionObserver
                .asObservable()
                .doOnNext({[weak current, weak view, weak cell] in
                    current?.onCellSelectionChanged(toBe: $0,
                                                    for: cell,
                                                    at: indexPath,
                                                    with: view,
                                                    with: current)
                })
                .subscribe()
                .addDisposableTo(current.disposeBag)
        }
        
        /// Get the current choice list's height constraint, if available.
        ///
        /// - Parameter view: The current UIChoiceListView instance.
        /// - Returns: An optional NSLayoutConstraint instance.
        func heightConstraint(for view: UICollectionView) -> NSLayoutConstraint? {
            return view.heightConstraint
        }
        
        /// Update height constraint, if applicable.
        ///
        /// - Parameters:
        ///   - view: The current UIChoiceListView instance.
        ///   - choices: The currently active choices.
        ///   - current: The current Presenter instance.
        func updateHeight(for view: UICollectionView?,
                          using choices: [ChoiceSectionHolder],
                          with current: Presenter?) {
            guard
                let current = current,
                let view = view,
                let constraint = current.heightConstraint(for: view)
            else {
                return
            }
            
            let fitHeight = current.fitHeight(using: choices, with: current)
            constraint.constant = fitHeight
        }
        
        /// Get the height that fits all contents. Useful for height update
        /// if there is a height constraint.
        ///
        /// - Parameters:
        ///   - choices: The currently active choices.
        ///   - current: The current Presenter instance.
        /// - Returns: A CGFloat value.
        func fitHeight(using choices: [ChoiceSectionHolder],
                       with current: Presenter) -> CGFloat {
            let itemCount = choices.flatMap({$0.items}).count
            let sectionCount = choices.count
            let totalIH = current.itemHeight * CGFloat(itemCount)
            let totalIS = current.itemSpacing * CGFloat(itemCount - 1)
            let totalSS = current.sectionSpacing * 2 * CGFloat(sectionCount)
            let totalSH = current.sectionHeight * CGFloat(sectionCount)
            return Swift.max(totalIH + totalIS + totalSS + totalSH, 0)
        }
    }
}

public extension UIChoiceListView {
    
    /// When choices are set, pass them to the presenter.
    public var choices: [ChoiceSectionHolder] {
        get { return presenter.rxChoices.value }
        set { presenter.rxChoices.value = newValue }
    }
    
    /// Subscribe to this Observable to get notified when an item is selected.
    public var rxSelection: Observable<ChoiceDetailType> {
        return rx.itemSelected.asObservable()
            .map({[weak self] in
                self?.choices
                    .element(at: $0.section)?
                    .items.element(at: $0.row)
            })
            .filter({$0 != nil}).map({$0!})
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
        
        // Remove all subviews to avoid duplicates when reusing cells.
        cell.subviews.forEach({$0.removeFromSuperview()})
        
        let builder = choice.viewBuilder()
        cell.populateSubviews(with: builder)
        
        setupSelectionObserver(for: cell,
                               at: indexPath,
                               with: collectionView,
                               with: self)
        
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
    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.contentInset = UIEdgeInsets.zero
        
        return super.collectionView(collectionView,
                                    layout: collectionViewLayout,
                                    sizeForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int)
        -> CGSize
    {
        guard choices.element(at: section)?.section != nil else {
            return CGSize.zero
        }
        
        let width = collectionView.bounds.width
        let height = sectionHeight
        return CGSize(width: width, height: height)
    }
}

extension UIChoiceListView.Presenter: ChoiceListViewDecoratorType {
    
    /// Override this to use a default itemHeight if no decorator is set.
    override open var itemHeight: CGFloat {
        return decorator?.itemHeight ?? Size.medium.value ?? 0
    }
    
    /// Override this to use a default sectionHeight if no decorator is set.
    override open var sectionHeight: CGFloat {
        return decorator?.sectionHeight ?? Size.small.value ?? 0
    }
    
    override open var sectionSpacing: CGFloat {
        return decorator?.sectionSpacing ?? Size.smallest.value ?? 0
    }
}

extension UIChoiceListView.Presenter: ChoiceItemViewIdentifierType {}

final class UIChoiceCell: UICollectionViewCell {
    
    // Use this instead of isSelected.
    let selectionObserver = Variable<Bool>(false)
    
    override var isSelected: Bool {
        get { return selectionObserver.value }
        set { selectionObserver.value = newValue }
    }
}

final class UIChoiceHeader: UICollectionReusableView {
    static var kind: ReusableViewKind { return .header }
}

extension UIChoiceHeader: ReusableViewIdentifierType {}
