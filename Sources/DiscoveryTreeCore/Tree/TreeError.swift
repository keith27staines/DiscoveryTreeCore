//
//  TreeError.swift
//  
//
//  Created by Keith Staines on 25/11/2023.
//

extension Tree {
    /// Errors that might be thrown while performing operations on a ``Tree``
    public enum TreeError: Error {
        /// An attempt was made to add a node to itself
        case addingChildWithSameIdAsParent
        /// An attempt was made to add a node to a tree that already contained that node
        case addingChildThatIsAlreadyAChild
    }
}
