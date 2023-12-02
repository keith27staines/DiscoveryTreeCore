//
//  Id.swift
//
//
//  Created by Keith Staines on 25/11/2023.
//

import Foundation

/// Id is a type safe unique identifier based on a UUID
///
/// Use Id as a safer alternative to using a plain UUID as an object identifier.
/// Id has the advantage that it will only allow comparisons between objects of the same type
///
public struct Id<A>: Codable, Equatable, Hashable {
    
    /// A unique identifier
    public let uuid: UUID
    
    public init(uuid: UUID) {
        self.uuid = uuid
    }
    
    public init() {
        self.uuid = UUID()
    }
}
