//
//  MockChoice.swift
//  SwiftChoiceView
//
//  Created by Hai Pham on 5/2/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftBaseViews

public enum MockChoice {
    case dataMarketing
    case externalAudit
    case internalAudit
    case investmentBanking
    case mobileDeveloper
    case humanResource
    case webDeveloper
    
    public static var allChoices: [MockChoice] {
        return [
            .dataMarketing,
            .externalAudit,
            .internalAudit,
            .investmentBanking,
            .mobileDeveloper,
            .humanResource,
            .webDeveloper
        ]
    }
    
    public var identifier: String { return String(describing: self) }
    public var value: String { return identifier }
    public var decorator: ChoiceItemDecoratorType { return ChoiceItemDecorator() }
    public var viewBuilderType: ChoiceItemViewBuilderType.Type? { return nil }
    
    public var section: ListSectionType? {
        let section: MockChoiceSection
        
        switch self {
        case .dataMarketing:
            section = .marketing
            
        case .externalAudit, .internalAudit:
            section = .accounting
            
        case .investmentBanking:
            section = .finance
            
        case .humanResource:
            section = .administrative
            
        case .mobileDeveloper, .webDeveloper:
            section = .developer
        }
        
        return section
    }
}

extension MockChoice: ChoiceDetailType {}

public class ChoiceItemDecorator: ChoiceItemDecoratorType {
    public init() {}
}

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
    
    public static var randomSectionHolders: [ChoiceSectionHolder] {
        let holders = choiceSectionHolders
        return holders.randomize(Int.random(0, holders.count))
    }
}

public class ChoiceSectionDecorator: ListHeaderDecoratorType {
    public init() {}
    public var backgroundColor: UIColor { return .darkGray }
    public var headerTitleTextColor: UIColor { return .white }
    public var headerTitleTextAlignment: NSTextAlignment { return .center }
}

public class ChoiceViewDecorator: ChoiceViewDecoratorType {
    public var choiceTitle: String { return "Select occupation" }
}
