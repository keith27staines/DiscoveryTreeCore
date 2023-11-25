//
//  CodableTreeTests.swift
//  
//
//  Created by Keith Staines on 25/11/2023.
//

import XCTest
@testable import DiscoveryTreeCore

final class CodableTreeTests: XCTestCase {

    func test_code_and_decode() throws {
        let root = Tree()
        let child = Tree()
        let childOfChild = Tree()
        try root.add(child)
        try child.add(childOfChild)
        XCTAssertEqual(root.id, root.children[0].parent?.id)
        let data = try JSONEncoder().encode(root)
        let decodedRoot = try JSONDecoder().decode(Tree.self, from: data)
        XCTAssertEqual(root.id, decodedRoot.id)
        XCTAssertEqual(root.children[0].id, decodedRoot.children[0].id)
        XCTAssertEqual(decodedRoot.id, decodedRoot.children[0].parent?.id)
    }

}
