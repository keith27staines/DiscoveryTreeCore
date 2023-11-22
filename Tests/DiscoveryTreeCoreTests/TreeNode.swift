import XCTest
@testable import DiscoveryTreeCore

final class TreeNodeTests: XCTestCase {
    
    func test_init() throws {
        let sut = TreeNode()
        XCTAssertNil(sut.parent)
        XCTAssertTrue(sut.children.isEmpty)
    }
}
