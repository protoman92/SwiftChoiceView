//
//  ChoiceDetailType.swift
//  SwiftChoiceView
//
//  Created by Hai Pham on 4/29/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftBaseViews
import SwiftUtilities

/// Implement this protocol to provide information about each choice item.
public protocol ChoiceDetailType: SectionableListItemType {
    
    /// Use this identifier to differentiate different ChoiceDetailType
    /// instances.
    var identifier: String { get }
    
    /// Get a human-readable description of the current choice. This value
    /// will be displayed by the choice label.
    var value: String { get }
    
    /// Get a decorator associated with the current ChoiceDetailType instance.
    var decorator: ChoiceItemDecoratorType { get }
    
    /// Get a ChoiceItemViewBuilderType type to construct choice item views
    /// dynamically. If this returns nil, use a default type.
    var viewBuilderType: ChoiceItemViewBuilderType.Type? { get }
}

public extension ChoiceDetailType {
    
    /// Get a ChoiceItemViewBuilderType instance by initializing it with the
    /// current ChoiceDetailType.
    ///
    /// - Returns: A ChoiceItemViewBuilderType instance.
    public func viewBuilder() -> ChoiceItemViewBuilderType {
        let type = viewBuilderType ?? ChoiceItemViewBuilder.self
        return type.init(choice: self)
    }
}
