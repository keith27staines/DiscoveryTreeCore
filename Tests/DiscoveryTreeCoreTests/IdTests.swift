//
//  IdTests.swift
//  
//
//  Created by Keith Staines on 25/11/2023.
//

import XCTest
import DiscoveryTreeCore

final class IdTests: XCTestCase {

    func test_equality_with_sameUUID_sameTypes() throws {
        let uuid = UUID()
        let id1 = Id<String>(uuid: uuid)
        let id2 = Id<String>(uuid: uuid)
        XCTAssertEqual(id1, id2)
    }
    
    func test_equality_with_differentUUID_sameTypes() throws {
        let uuid1 = UUID()
        let uuid2 = UUID()
        let id1 = Id<String>(uuid: uuid1)
        let id2 = Id<String>(uuid: uuid2)
        XCTAssertNotEqual(id1, id2)
    }
    
    func test_defaultInitialisation() throws {
        let id1 = Id<String>()
        let id2 = Id<String>()
        XCTAssertNotEqual(id1, id2)
    }
    
    func test_codingAndDecoding() throws {
        let id1 = Id<String>()
        let id2 = Id<String>()
        let data1 = try JSONEncoder().encode(id1)
        let data2 = try JSONEncoder().encode(id2)
        let unencodedId1 = try JSONDecoder().decode(Id<String>.self, from: data1)
        let unencodedId2 = try JSONDecoder().decode(Id<String>.self, from: data2)
        XCTAssertEqual(id1, unencodedId1)
        XCTAssertEqual(id2, unencodedId2)
        XCTAssertNotEqual(unencodedId1, unencodedId2)
    }

}
