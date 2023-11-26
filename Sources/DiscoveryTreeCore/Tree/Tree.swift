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
    
    /// Add a child tree to the current instance
    /// - Parameter child: the ``Tree`` to add as a child of the receiver
    /// - throws if the child tree any of its own children has the same id as the current instance
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
    
    /// Tests whether  the receiver, or any of its descendents, has the same `id` as `tree`
    /// - Note: a Tree always contains itself
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


