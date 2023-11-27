//
//  TreeError.swift
//  
//
//  Created by Keith Staines on 25/11/2023.
//

extension Tree {
    /// Errors that might be thrown while performing operations on a ``Tree``
    public enum TreeError: Error {
        case unexpectedError
        case proposedChildIsAlreadyADescendant
        case proposedChildIsAnAncestor
    }
}
