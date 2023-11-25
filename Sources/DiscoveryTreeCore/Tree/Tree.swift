//
//  Tree.swift
//
//
//  Created by Keith Staines on 22/11/2023.
//

import Foundation

public class Tree: Codable {
    public let id: UUID
    private(set) weak var parent: Tree?
    private(set) var children: [Tree]
    
    public init(parent: Tree? = nil) {
        self.id = UUID()
        self.parent = parent
        self.children = []
    }
    
    public func add(_ child: Tree) throws {
        guard child.id != self.id else {
            throw TreeError.addingChildWithSameIdAsParent
        }
        let alreadyAChild = children.contains { existingChild in
            existingChild.id == child.id
        }
        guard !alreadyAChild else {
            throw TreeError.addingChildThatIsAlreadyAChild
        }
        child.parent = self
        children.append(child)
    }
    
    public func contains(_ tree: Tree) -> Bool {
        if tree.id == self.id { return true }
        for child in children {
            if child.contains(tree) { return true }
        }
        return false
    }
    
    public func removeFromParent() {
        parent?.children.removeAll(where: { child in
            child.id == id
        })
        parent = nil
    }
    
    public func hasAncestor(_ ancestor: Tree) -> Bool {
        guard let parent = parent else { return false }
        if parent.id == ancestor.id { return true }
        return parent.hasAncestor(ancestor)
    }
    
    public func root() -> Tree {
        guard let parent = parent else { return self }
        return parent.root()
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.children = try container.decode([Tree].self, forKey: .children)
        children.forEach { child in
            child.parent = self
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case children
    }
}

extension Tree {
    enum TreeError: Error {
        case addingChildWithSameIdAsParent
        case addingChildThatIsAlreadyAChild
    }
}


