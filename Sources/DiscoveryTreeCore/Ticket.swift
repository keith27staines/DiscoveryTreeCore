//
//  Ticket.swift
//
//
//  Created by Keith Staines on 25/11/2023.
//

import Foundation

struct Ticket: Codable {
    let id: Id<Ticket>
    let name: String
    let createdDate: Date
    
    init(id: UUID = UUID(), name: String, createdDate: Date = Date.now) {
        self.id = Id<Ticket>(uuid: id)
        self.name = name
        self.createdDate = createdDate
    }
}
