//
//  Id.swift
//
//
//  Created by Keith Staines on 25/11/2023.
//

import Foundation

public struct Id<A>: Codable, Equatable {
    public let uuid: UUID
    
    init(uuid: UUID) {
        self.uuid = uuid
    }
    
    init() {
        self.uuid = UUID()
    }
}
