//
//  Ticket.swift
//
//
//  Created by Keith Staines on 25/11/2023.
//

import Foundation

/// A ticket represents an item in a todo list
public struct Ticket: Codable {
    
    /// Uniquely identifies the object in a type safe way
    public let id: Id<Ticket>
    
    /// The title describes at the highest level the purpose of the ticket
    public let title: String
    
    /// The date the ticket was created
    public let createdDate: Date
    
    /// Initializes a new instance
    /// - Parameters:
    ///   - id: Uniquely identifies the ticket in a type safe way
    ///   - title: Title of the ticket
    ///   - createdDate: Date on which the ticket was created
    public init(id: UUID = UUID(), title: String, createdDate: Date = Date.now) {
        self.id = Id<Ticket>(uuid: id)
        self.title = title
        self.createdDate = createdDate
    }
}
