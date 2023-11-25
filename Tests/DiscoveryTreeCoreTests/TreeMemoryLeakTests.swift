//
//  TreeMemoryLeakTests.swift
//  
//
//  Created by Keith Staines on 25/11/2023.
//

import XCTest
import DiscoveryTreeCore

final class TreeMemoryLeakTests: XCTestCase {

    weak var weakRoot: Tree<String>?
    weak var weakChild: Tree<String>?

    override func tearDownWithError() throws {
        XCTAssertNil(weakRoot)
        XCTAssertNil(weakChild)
    }

    func testExample() throws {
        let root = Tree<String>()
        let child = Tree<String>()
        weakRoot = root
        weakChild = child
        try root.add(child)
    }
}
