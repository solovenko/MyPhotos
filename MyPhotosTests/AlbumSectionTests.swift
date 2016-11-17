//
//  AlbumSectionTests.swift
//  MyPhotos
//
//  Created by Артем Соловьенко on 17.11.16.
//  Copyright © 2016 Artem Solovenko. All rights reserved.
//

import XCTest
@testable import MyPhotos

class AlbumSectionTests: XCTestCase {
    
    var smarAlbumSection: SmartAlbumSection!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        smarAlbumSection = SmartAlbumSection()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFetchAlbumsMethod() {
        smarAlbumSection.fetchAlbums { [weak self] in
            guard let strongSelf = self else { return }
            XCTAssert(strongSelf.smarAlbumSection.albums.count > 0, "Smart Albums count is greater then 0")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
