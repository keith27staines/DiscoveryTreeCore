import XCTest
@testable import DiscoveryTreeCore

final class TreeNodeTests: XCTestCase {
    
    func test_init() throws {
        let root = Tree()
        XCTAssertNil(root.parent)
        XCTAssertTrue(root.children.isEmpty)
        XCTAssertTrue(root.contains(root))
    }
    
    func test_addFirstChild() throws {
        let root = Tree()
        let child = Tree()
        try root.add(child)
        XCTAssertEqual(child.parent?.id, root.id)
        XCTAssertEqual(child.id, root.children[0].id)
        XCTAssertTrue(root.contains(child))
    }
    
    func test_addSameChildTwice_fails() throws {
        let root = Tree()
        let child = Tree()
        try root.add(child)
        XCTAssertThrowsError(try root.add(child))
    }
    
    func test_addingTwoDifferentChildren_succeeds() throws {
        let root = Tree()
        let child1 = Tree()
        let child2 = Tree()
        try root.add(child1)
        try root.add(child2)
        XCTAssertEqual(root.children.count,2)
        XCTAssertTrue(root.contains(child1))
        XCTAssertTrue(root.contains(child2))
    }
    
    func test_addingChildToChild() throws {
        let root = Tree()
        let child = Tree()
        let childOfChild = Tree()
        try root.add(child)
        try child.add(childOfChild)
        XCTAssertTrue(root.contains(child))
        XCTAssertTrue(root.contains(childOfChild))
        XCTAssertTrue(child.contains(childOfChild))
    }
    
    func test_removeFromParent() throws {
        let root = Tree()
        let child = Tree()
        let childOfChild = Tree()
        try root.add(child)
        try child.add(childOfChild)
        XCTAssertTrue(root.contains(child))
        XCTAssertTrue(root.contains(childOfChild))
        XCTAssertTrue(root.contains(childOfChild))
        XCTAssertTrue(child.contains(childOfChild))
        child.removeFromParent()
        XCTAssertFalse(root.contains(child))
        XCTAssertFalse(root.contains(childOfChild))
        XCTAssertTrue(child.contains(childOfChild))
    }
    
    func test_hasAncestor() throws {
        let root = Tree()
        let child = Tree()
        let childOfChild = Tree()
        try root.add(child)
        try child.add(childOfChild)
        XCTAssertTrue(childOfChild.hasAncestor(child))
        XCTAssertTrue(childOfChild.hasAncestor(root))
        XCTAssertTrue(child.hasAncestor(root))
        XCTAssertFalse(child.hasAncestor(childOfChild))
    }
    
    func test_root() throws {
        let root = Tree()
        let child = Tree()
        let childOfChild = Tree()
        try root.add(child)
        try child.add(childOfChild)
        XCTAssertEqual(childOfChild.root().id, root.id)
        XCTAssertEqual(child.root().id, root.id)
        XCTAssertEqual(root.root().id, root.id)
    }
}
