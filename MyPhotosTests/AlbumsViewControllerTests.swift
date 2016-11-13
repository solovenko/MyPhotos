//
//  AlbumsViewControllerTests.swift
//  MyPhotos
//
//  Created by Артем Соловьенко on 13.11.16.
//  Copyright © 2016 Artem Solovenko. All rights reserved.
//

import XCTest
import Photos
@testable import MyPhotos

class AlbumsViewControllerTests: XCTestCase {
    
    let albumVC = AlbumsViewController()
    var smartAlbumCount = 0
    
    override func setUp() {
        super.setUp()
        
        smartAlbumCount = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil).count
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFetchMethod() {
        let albums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        if let firstAlbum = albums.firstObject {
            
            let startFirstTime = Date().timeIntervalSince1970
            print("Common approach")
            print("Album name: \(getAlbumName(from: firstAlbum))")
            print("Album's photos count: \(getAlbumPhotosCount(from: firstAlbum))")
            let firstResultTime = Date().timeIntervalSince1970 - startFirstTime
            
            print("My Approach")
            
            let id = firstAlbum.localIdentifier
            let startSecondTime = Date().timeIntervalSince1970
            print("Album name: \(getAlbumName(from: id))")
            print("Album's photos count: \(getAlbumPhotosCount(from: id))")
            let secondResultTime = Date().timeIntervalSince1970 - startSecondTime
            
            print("First time log: \(firstResultTime)")
            print("Second time log: \(secondResultTime)")
            
            print("End!")
        }
    }
    
    private func getAlbumName(from asset: PHAssetCollection) -> String? {
        return asset.localizedTitle
    }
    
    private func getAlbumName(from identifier: String) -> String? {
        let assets = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [identifier], options: nil)
        print("\(#function) albumCount by identifier = \(assets.count)")
        return getAlbumName(from: assets.firstObject!)
    }
    
    
    private func getAlbumPhotosCount(from asset: PHAssetCollection) -> Int {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        
        let assets = PHAsset.fetchAssets(in: asset, options: fetchOptions)
        return assets.count
    }
    
    private func getAlbumPhotosCount(from identifier: String) -> Int {
        let assets = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [identifier], options: nil)
        print("\(#function) albumCount by identifier = \(assets.count)")
        return getAlbumPhotosCount(from: assets.firstObject!)
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
