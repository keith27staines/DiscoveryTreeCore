//
//  Tree.swift
//
//
//  Created by Keith Staines on 22/11/2023.
//

import Foundation

/// A data structure representing a tree, where each node of the tree is itself a tree
public class Tree<Content: Codable>: Codable {
    
    public let id: Id<Tree<Content>>
    public var content: Content?
    
    public private(set) weak var parent: Tree?
    public private(set) var children: [Tree]
    
    /// Initialises a new ``Tree`` instance
    /// - Parameter parent: The parent tree of the new tree, if there is one
    public init(parent: Tree? = nil, content: Content? = nil) {
        self.id = Id()
        self.parent = parent
        self.children = []
        self.content = content
    }
    
    ///  Returns `true` if the node has no parent, otherwise `false`
    public var isRoot: Bool { parent == nil }
    
    
    /// Returns `true` if the node has no children, otherwise `false`
    public var isLeaf: Bool { children.isEmpty }
    
    /// Inserts a new node above the receiver
    ///
    /// * The receiver is appended to the new node's  children
    /// * If the receiver already has a parent then the receiver is removed from the parent and the new node is inserted  at the same child index
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
    
    public func insertAbove(_ node: Tree<Content>) throws {
        guard let parent = parent else {
            try node.appendChild(self)
            return
        }
        guard let childIndex = self.childIndex() else {
            throw TreeError.unexpectedError
        }
        try _ = parent.replaceChild(at: childIndex, with: node)
        try node.appendChild(self)
    }
    
    /// Add a child tree to the current instance
    /// - Parameter child: The ``Tree`` to insert intto the receiver's children array
    /// - Parameter index: The index at which to insert the child
    /// - Throws: If the proposed child contains the receiver, or if the receiver contains the proposed child
    public func insertChild(_ child: Tree, at index: Int) throws {
        guard !contains(child)
        else { throw TreeError.proposedChildIsAlreadyADescendant }
        guard !child.contains(self)
        else { throw TreeError.proposedChildIsAnAncestor }
        child.parent = self
        children.insert(child, at: index)
    }
    
    /// Add a child tree to the current instance
    /// - Parameter child: the ``Tree`` to append to the receiver's children
    /// - Throws: If the proposed child contains the receiver, or if the receiver contains the proposed child
    public func appendChild(_ child: Tree) throws {
        guard !contains(child)
        else { throw TreeError.proposedChildIsAlreadyADescendant }
        guard !child.contains(self)
        else { throw TreeError.proposedChildIsAnAncestor }
        child.parent = self
        children.append(child)
    }
    
    /// Replaces the child at the specified index
    /// - Parameters:
    ///   - index: The index of the child to be replaced
    ///   - replacement: The Tree that is to become a new child
    /// - Returns: The child that has been replaced
    public func replaceChild(at index: Int, with replacement: Tree) throws -> Tree {
        guard !contains(replacement)
        else { throw TreeError.proposedChildIsAlreadyADescendant }
        guard !replacement.contains(self)
        else { throw TreeError.proposedChildIsAnAncestor }
        let childBeingReplaced = children[index]
        children[index] = replacement
        replacement.parent = self
        return childBeingReplaced
    }
    
    /// Tests whether  the receiver, or any of its descendents, has the same `id` as `tree`
    /// - Note: a ``Tree`` always contains itself
    /// - Parameter tree: The tree to search for
    /// - Returns: `true` if the receiver contains the specified tree, otherwise `false`
    public func contains(_ tree: Tree) -> Bool {
        if tree.id == self.id { return true }
        for child in children {
            if child.contains(tree) { return true }
        }
        return false
    }
    
    /// Removes the receiver from its immediate parent's list of children.
    ///
    /// After removal the receiver's parent will be nil, and the parent's children will no longer include the receiver
    public func removeFromParent() {
        parent?.children.removeAll(where: { child in
            child.id == id
        })
        parent = nil
    }
    
    /// Returns true if one of the the receiver's ancestors is the ancestor being checked for
    /// - Parameter ancestor: A possible ancestor ``Tree``
    /// - Returns: `true` if the receiver does have the specified tree as an ancestor, otherise `false`
    public func hasAncestor(_ ancestor: Tree) -> Bool {
        guard let parent = parent else { return false }
        if parent.id == ancestor.id { return true }
        return parent.hasAncestor(ancestor)
    }
    
    /// Returns the root node of the tree
    /// - Note: If a tree has no parent, then it is its own root
    /// - Returns: The root node of the receiver
    public func root() -> Tree {
        guard let parent = parent else { return self }
        return parent.root()
    }
    
    /// Calculates the depth of the receiver relative to the root
    /// * The root has depth 0.
    /// * All direct children  of the root have depth 1.
    /// * All direct children of a direct child of root have depth 2, etc.
    /// - Returns: Depth relative to root
    public func depthFromRoot() -> Int {
        depthFromRoot(accumulatedDepth: 0)
    }
    
    /// Calculates the offset of the receiver relative to the root.
    ///
    /// The recursive sum of the node's offset relative to its parent, all the way to the root.
    ///
    /// Examples:
    /// * The root has offset 0.
    /// * The first direct child  of the root have offset 0.
    /// * The second direct child of a of root have offset 1.
    /// - Returns: Offset relative to root
    public func offsetFromRoot() -> Int {
        (childIndex() ?? 0) + (parent?.offsetFromRoot() ?? 0)
    }
    
    /// Returns the index of the this node relative to its parent's children collection
    /// - Returns: The index of the receiver
    public func childIndex() -> Int? {
        return parent?.children.firstIndex { node in
            node.id == self.id
        }
    }
    
    private func depthFromRoot(accumulatedDepth: Int = 0) -> Int {
        guard let parent = parent else { return accumulatedDepth }
        return parent.depthFromRoot(accumulatedDepth: accumulatedDepth + 1)
    }
    
    /// Init required for JSONDecoder
    required public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Tree<Content>.CodingKeys> 
        = try decoder.container(keyedBy: Tree<Content>.CodingKeys.self)
        
        self.id = try container.decode(
            Id<Tree<Content>>.self,
            forKey: Tree<Content>.CodingKeys.id
        )
        self.children = try container.decode(
            [Tree<Content>].self,
            forKey: Tree<Content>.CodingKeys.children
        )
        self.content = try container.decodeIfPresent(
            Content.self,
            forKey: Tree<Content>.CodingKeys.content
        )
        children.forEach { child in
            child.parent = self
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case children
        case content
    }
}


