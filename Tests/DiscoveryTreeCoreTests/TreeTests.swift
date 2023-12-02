import XCTest
import DiscoveryTreeCore

final class TreeNodeTests: XCTestCase {
    
    func test_init() throws {
        let root = Tree<String>()
        XCTAssertNil(root.parent)
        XCTAssertTrue(root.children.isEmpty)
        XCTAssertTrue(root.contains(root))
        XCTAssertTrue(root.isRoot)
        XCTAssertTrue(root.isLeaf)
    }
    
    func test_addFirstChild() throws {
        let root = Tree<String>()
        let child = Tree<String>()
        try root.appendChild(child)
        XCTAssertEqual(child.parent?.id, root.id)
        XCTAssertEqual(child.id, root.children[0].id)
        XCTAssertTrue(root.contains(child))
        XCTAssertTrue(root.isRoot)
        XCTAssertFalse(root.isLeaf)
        XCTAssertFalse(child.isRoot)
        XCTAssertTrue(child.isLeaf)
    }
    
    func test_addSameChildTwice_fails() throws {
        let root = Tree<String>()
        let child = Tree<String>()
        try root.appendChild(child)
        XCTAssertThrowsError(try root.appendChild(child))
    }
    
    func test_addingTwoDifferentChildren_succeeds() throws {
        let root = Tree<String>()
        let child1 = Tree<String>()
        let child2 = Tree<String>()
        try root.appendChild(child1)
        try root.appendChild(child2)
        XCTAssertEqual(root.children.count,2)
        XCTAssertTrue(root.contains(child1))
        XCTAssertTrue(root.contains(child2))
    }
    
    func test_insertChildAtIndex() throws {
        let root = Tree<String>()
        let child1 = Tree<String>()
        let child2 = Tree<String>()
        let child3 = Tree<String>()
        try root.appendChild(child1)
        try root.appendChild(child2)
        try root.appendChild(child3)
        let newChild = Tree<String>()
        try root.insertChild(newChild, at: 0)
        XCTAssert(root.contains(newChild))
        XCTAssertEqual(root.children[0].id, newChild.id)
        newChild.removeFromParent()
        try root.insertChild(newChild, at: 1)
        XCTAssertEqual(root.children[1].id, newChild.id)
    }
    
    func test_addingChildToChild() throws {
        let root = Tree<String>()
        let child = Tree<String>()
        let childOfChild = Tree<String>()
        try root.appendChild(child)
        try child.appendChild(childOfChild)
        XCTAssertTrue(root.contains(child))
        XCTAssertTrue(root.contains(childOfChild))
        XCTAssertTrue(child.contains(childOfChild))
    }
    
    func test_removeFromParent() throws {
        let root = Tree<String>()
        let child = Tree<String>()
        let childOfChild = Tree<String>()
        try root.appendChild(child)
        try child.appendChild(childOfChild)
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
        try root.appendChild(child)
        try child.appendChild(childOfChild)
        XCTAssertTrue(childOfChild.hasAncestor(child))
        XCTAssertTrue(childOfChild.hasAncestor(root))
        XCTAssertTrue(child.hasAncestor(root))
        XCTAssertFalse(child.hasAncestor(childOfChild))
    }
    
    func test_root() throws {
        let root = Tree<String>()
        let child = Tree<String>()
        let childOfChild = Tree<String>()
        try root.appendChild(child)
        try child.appendChild(childOfChild)
        XCTAssertEqual(childOfChild.root().id, root.id)
        XCTAssertEqual(child.root().id, root.id)
        XCTAssertEqual(root.root().id, root.id)
    }
    
    func test_content() throws {
        let content = TestContent(title: "")
        let root = Tree(content: content)
        XCTAssertEqual(root.content?.id, content.id)
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

fileprivate func makeTestTree() -> Tree<TestContent> {
    func makeContent(x: Int, y: Int) -> TestContent {
        TestContent(title: "x: \(x), y:\(y)")
    }
    
    let t00 = Tree(content: makeContent(x: 0, y: 0))
    let t01 = Tree(content: makeContent(x: 0, y: 1))
    let t11 = Tree(content: makeContent(x: 1, y: 1))
    let t21 = Tree(content: makeContent(x: 2, y: 1))
    let t22 = Tree(content: makeContent(x: 2, y: 2))
    try? t00.appendChild(t01)
    try? t00.appendChild(t11)
    try? t00.appendChild(t21)
    try? t21.appendChild(t22)
    return t00
}
