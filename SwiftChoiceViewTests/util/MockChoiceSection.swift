//
//  MockChoiceSection.swift
//  SwiftChoiceView
//
//  Created by Hai Pham on 5/2/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftBaseViews

public enum MockChoiceSection {
    case accounting
    case administrative
    case developer
    case finance
    case marketing
    
    public static var allSections: [MockChoiceSection] {
        return [.accounting, .administrative, .developer, .finance, .marketing]
    }
}

extension MockChoiceSection: ListSectionType {
    public var identifier: String { return String(describing: self) }
    public var viewBuilderType: ListHeaderBuilderType.Type? { return nil }
    
    public var decorator: ListHeaderDecoratorType {
        return ChoiceSectionDecorator()
    }
    
    public var header: String { return identifier }
}

public extension MockChoiceSection {
    public static var choiceSectionHolders: [ChoiceSectionHolder] {
        var holders = [ChoiceSectionHolder]()
        let choices = MockChoice.allChoices
        
        for section in self.allSections {
            let sectionChoices = choices.filter({
                $0.section?.identifier == section.identifier
            }).map({$0 as ChoiceDetailType})
            
            holders.append(ChoiceSectionHolder.builder()
                .with(items: sectionChoices)
                .with(section: section)
                .build())
        }
        
        return holders
    }
}

public class ChoiceSectionDecorator: ListHeaderDecoratorType {
    public init() {}
    public var backgroundColor: UIColor { return .darkGray }
    public var headerTitleTextColor: UIColor { return .white }
    public var headerTitleTextAlignment: NSTextAlignment { return .center }
}
