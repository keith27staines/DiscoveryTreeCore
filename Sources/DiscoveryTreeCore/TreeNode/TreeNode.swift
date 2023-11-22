//
//  TreeNode.swift
//
//
//  Created by Keith Staines on 22/11/2023.
//

import Foundation

class TreeNode {
    let parent: TreeNode?
    let children: [TreeNode]
    
    init(parent: TreeNode? = nil, children: [TreeNode] = []) {
        self.parent = parent
        self.children = children
    }
}
