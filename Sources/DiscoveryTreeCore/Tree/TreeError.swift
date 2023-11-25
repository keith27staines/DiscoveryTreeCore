//
//  TreeError.swift
//  
//
//  Created by Keith Staines on 25/11/2023.
//

extension Tree {
    enum TreeError: Error {
        case addingChildWithSameIdAsParent
        case addingChildThatIsAlreadyAChild
    }
}
