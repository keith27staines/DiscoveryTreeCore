import XCTest
import DiscoveryTreeCore

final class TreeNodeTests: XCTestCase {
    
    func test_init() throws {
        let root = Tree<String>()
        XCTAssertNil(root.parent)
        XCTAssertTrue(root.children.isEmpty)
        XCTAssertTrue(root.contains(root))
    }
    
    func test_addFirstChild() throws {
        let root = Tree<String>()
        let child = Tree<String>()
        try root.add(child)
        XCTAssertEqual(child.parent?.id, root.id)
        XCTAssertEqual(child.id, root.children[0].id)
        XCTAssertTrue(root.contains(child))
    }
    
    func test_addSameChildTwice_fails() throws {
        let root = Tree<String>()
        let child = Tree<String>()
        try root.add(child)
        XCTAssertThrowsError(try root.add(child))
    }
    
    func test_addingTwoDifferentChildren_succeeds() throws {
        let root = Tree<String>()
        let child1 = Tree<String>()
        let child2 = Tree<String>()
        try root.add(child1)
        try root.add(child2)
        XCTAssertEqual(root.children.count,2)
        XCTAssertTrue(root.contains(child1))
        XCTAssertTrue(root.contains(child2))
    }
    
    func test_addingChildToChild() throws {
        let root = Tree<String>()
        let child = Tree<String>()
        let childOfChild = Tree<String>()
        try root.add(child)
        try child.add(childOfChild)
        XCTAssertTrue(root.contains(child))
        XCTAssertTrue(root.contains(childOfChild))
        XCTAssertTrue(child.contains(childOfChild))
    }
    
    func test_removeFromParent() throws {
        let root = Tree<String>()
        let child = Tree<String>()
        let childOfChild = Tree<String>()
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
        let root = Tree<String>()
        let child = Tree<String>()
        let childOfChild = Tree<String>()
        try root.add(child)
        try child.add(childOfChild)
        XCTAssertTrue(childOfChild.hasAncestor(child))
        XCTAssertTrue(childOfChild.hasAncestor(root))
        XCTAssertTrue(child.hasAncestor(root))
        XCTAssertFalse(child.hasAncestor(childOfChild))
    }
    
    func test_root() throws {
        let root = Tree<String>()
        let child = Tree<String>()
        let childOfChild = Tree<String>()
        try root.add(child)
        try child.add(childOfChild)
        XCTAssertEqual(childOfChild.root().id, root.id)
        XCTAssertEqual(child.root().id, root.id)
        XCTAssertEqual(root.root().id, root.id)
    }
    
    func test_content() throws {
        let ticket = Ticket(title: "name")
        let root = Tree(content: ticket)
        XCTAssertEqual(root.content?.id, ticket.id)
    }
    
    func test_depthFromRootOfRoot() {
        let tree = makeTestTree()
        XCTAssertEqual(tree.depthFromRoot(), 0)
    }
    
    func test_depthFromRootOfChildOfRoot() {
        let tree = makeTestTree()
        XCTAssertEqual(tree.children[0].depthFromRoot(), 1)
    }
    
    func test_depthFromRootOfChildOfThirdChildOfRoot() {
        let tree = makeTestTree()
        XCTAssertEqual(tree.children[2].children[0].depthFromRoot(), 2)
    }
    
    func test_offsetFromRootOfRoot() {
        let tree = makeTestTree()
        XCTAssertEqual(tree.offsetFromRoot(), 0)
    }
    
    func test_offsetFromRootOfFirstChildOfRoot() {
        let tree = makeTestTree()
        XCTAssertEqual(tree.children[0].offsetFromRoot(), 0)
    }
    
    func test_offsetFromRootOfSecondChildOfRoot() {
        let tree = makeTestTree()
        XCTAssertEqual(tree.children[1].offsetFromRoot(), 1)
    }
    
    func test_offsetFromRootOfChildOfThirdChildOfRoot() {
        let tree = makeTestTree()
        XCTAssertEqual(tree.children[2].children[0].offsetFromRoot(), 2)
    }
}

fileprivate func makeTestTree() -> Tree<Ticket> {
    func ticket(x: Int, y: Int) -> Ticket {
        Ticket(title: "x: \(x), y:\(y)")
    }
    
    let t00 = Tree(content: ticket(x: 0, y: 0))
    let t01 = Tree(content: ticket(x: 0, y: 1))
    let t11 = Tree(content: ticket(x: 1, y: 1))
    let t21 = Tree(content: ticket(x: 2, y: 1))
    let t22 = Tree(content: ticket(x: 2, y: 2))
    try? t00.add(t01)
    try? t00.add(t11)
    try? t00.add(t21)
    try? t21.add(t22)
    return t00
}
