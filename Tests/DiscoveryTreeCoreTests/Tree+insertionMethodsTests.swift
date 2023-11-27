//
//  Tree+insertionMethodsTests.swift
//
//
//  Created by Keith Staines on 27/11/2023.
//

import XCTest
import DiscoveryTreeCore

final class TreeInsertionMethodsTests: XCTestCase {
    
    func test_insertAbove_whenNoParentExists() throws {
        let sut = Tree<String>(content: "sut")
        let parent = try sut.insertNewTreeAbove()
        XCTAssertFalse(sut.isRoot)
        XCTAssertTrue(sut.isLeaf)
        XCTAssertTrue(parent.isRoot)
        XCTAssertTrue(parent.contains(sut))
        XCTAssertFalse(sut.contains(parent))
    }
    
    func test_insertAbove_whenParentExists() throws {
        let sut = Tree<String>(content: "sut")
        let originalParent = try sut.insertNewTreeAbove()
        let newParent = try sut.insertNewTreeAbove()
        XCTAssertTrue(originalParent.isRoot)
        XCTAssertFalse(originalParent.isLeaf)
        XCTAssertTrue(originalParent.contains(newParent))
        XCTAssertTrue(originalParent.contains(sut))
        XCTAssertFalse(newParent.isRoot)
        XCTAssertFalse(newParent.isLeaf)
        XCTAssertTrue(newParent.contains(sut))
        XCTAssertFalse(sut.isRoot)
        XCTAssertTrue(sut.isLeaf)
        XCTAssertFalse(sut.contains(originalParent))
        XCTAssertFalse(sut.contains(newParent))
    }
}
