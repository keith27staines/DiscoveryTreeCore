//
//  CodableTreeTests.swift
//  
//
//  Created by Keith Staines on 25/11/2023.
//

import XCTest
import DiscoveryTreeCore

final class CodableTreeTests: XCTestCase {

    func test_code_and_decode() throws {
        let root = Tree<String>()
        let child = Tree<String>()
        let childOfChild = Tree<String>()
        try root.appendChild(child)
        try child.appendChild(childOfChild)
        XCTAssertEqual(root.id, root.children[0].parent?.id)
        let data = try JSONEncoder().encode(root)
        let decodedRoot = try JSONDecoder().decode(Tree<String>.self, from: data)
        XCTAssertEqual(root.id, decodedRoot.id)
        XCTAssertEqual(root.children[0].id, decodedRoot.children[0].id)
        XCTAssertEqual(decodedRoot.id, decodedRoot.children[0].parent?.id)
    }

}
