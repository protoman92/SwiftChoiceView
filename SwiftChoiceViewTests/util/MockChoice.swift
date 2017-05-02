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
