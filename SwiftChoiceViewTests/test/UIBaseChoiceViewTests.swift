//
//  UIBaseChoiceViewTests.swift
//  SwiftChoiceView
//
//  Created by Hai Pham on 5/2/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit
import XCTest
@testable import SwiftChoiceView

class UIBaseChoiceViewTests: XCTestCase {
    fileprivate var choiceView: UIBaseChoiceView!
    fileprivate var presenter: ChoicePresenter!
    
    override func setUp() {
        super.setUp()
        let decorator = ChoiceViewDecorator()
        let builder = ChoiceViewBuilder(with: decorator)
        choiceView = UIBaseChoiceView(with: builder)
        presenter = choiceView.choicePresenter
    }
    
    func test_choiceViewBuilding_shouldWork() {
        // Setup & When & Then
        XCTAssertNotNil(choiceView.choiceListView)
    }
    
    func test_setChoices_shouldWork() {
        // Setup
        let sectionHolders = MockChoiceSection.choiceSectionHolders
        
        // When
        choiceView.choices = sectionHolders
        
        // Then
        let addedSectionHolders = choiceView.choiceListView!.choices
        
        for (h1, h2) in zip(sectionHolders, addedSectionHolders) {
            XCTAssertEqual(h1.section?.identifier, h2.section?.identifier)
        }
    }
}
