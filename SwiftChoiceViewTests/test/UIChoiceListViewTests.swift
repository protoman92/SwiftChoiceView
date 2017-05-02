//
//  UIChoiceListViewTests.swift
//  SwiftChoiceView
//
//  Created by Hai Pham on 5/2/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftBaseViews
import SwiftUIUtilities
import SwiftUtilitiesTests
import XCTest

class UIChoiceListViewTests: XCTestCase {
    fileprivate var choiceListView: UIChoiceListView!
    fileprivate var presenter: Presenter!
    fileprivate let tries = 1000
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        choiceListView = UIChoiceListView(
            frame: CGRect.zero,
            collectionViewLayout: UICollectionViewLayout()
        )
        
        presenter = Presenter(view: choiceListView)
        choiceListView.presenter = presenter
    }
    
    func test_setChoices_shouldTriggerReload() {
        // Setup
        let choices = MockChoiceSection.choiceSectionHolders
        
        // When
        for _ in 0..<tries {
            choiceListView.choices = choices
        }
        
        // Then
        XCTAssertEqual(presenter.fake_reloadData.methodCount, tries + 1)
    }
}

fileprivate class Presenter: UIChoiceListView.Presenter {
    fileprivate let fake_reloadData = FakeDetails.builder().build()
    
    override init(view: UIChoiceListView) { super.init(view: view) }
    
    // Override this to prevent a call to reloadData when decorator is set
    // to nil.
    override func setupDecoratorObserver(
        for view: UICollectionView,
        with current: BaseCollectionViewPresenter) {}
    
    override func reloadData(for view: UICollectionView?) {
        fake_reloadData.onMethodCalled(withParameters: view)
        super.reloadData(for: view)
    }
}
