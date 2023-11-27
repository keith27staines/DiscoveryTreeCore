//
//  TestContent.swift
//
//
//  Created by Keith Staines on 25/11/2023.
//

import Foundation
import DiscoveryTreeCore

struct TestContent: Codable {
    
    let id: Id<TestContent>
    let title: String
    
    init(id: UUID = UUID(), title: String) {
        self.id = Id<TestContent>(uuid: id)
        self.title = title
    }
}
