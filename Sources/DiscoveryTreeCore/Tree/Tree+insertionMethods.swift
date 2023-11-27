//
//  Tree+insertionMethods.swift
//
//
//  Created by Keith Staines on 27/11/2023.
//

import Foundation

extension Tree {
    
    /// Inserts a new node above the receiver
    ///
    /// * The receiver is appended to the new node's  children
    /// * If the receiver is already has a parent then the receiver is removed from the parent' and the new node is inserted  at the same child index
    /// - Returns: The new node
    /// - Throws: If there is an unexpected error
    public func insertNewTreeAbove() throws -> Tree {
        let new = Tree<Content>()
        guard let parent = parent else {
            try new.appendChild(self)
            return new
        }
        guard let childIndex = self.childIndex() else {
            throw TreeError.unexpectedError
        }
        try _ = parent.replaceChild(at: childIndex, with: new)
        try new.appendChild(self)
        return new
    }
    
}
