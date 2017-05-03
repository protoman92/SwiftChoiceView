//
//  ChoiceViewIdentifierType.swift
//  SwiftChoiceView
//
//  Created by Hai Pham on 4/29/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

/// Implement this protocol to provide choice view identifiers.
public protocol ChoiceViewIdentifierType {}

public extension ChoiceViewIdentifierType {
    
    /// Identifier for choice list view. Usually this would be a 
    /// UICollectionView that accepts a list of choices.
    public var choiceListId: String { return "choiceList" }
    
    /// Identifier for the label that will serve as the choice title view.
    public var choiceTitleId: String { return "choiceTitle" }
}

/// Implement this protocol to provide choice item view identifiers.
public protocol ChoiceItemViewIdentifierType {}

public extension ChoiceItemViewIdentifierType {
    
    /// Identifier for the choice title - a label that displays a human-readble
    /// description of the choice.
    public var choiceTitleId: String { return "choiceTitle" }
}
