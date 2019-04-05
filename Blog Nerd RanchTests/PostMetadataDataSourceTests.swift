//
//  PostMetadataDataSourceTests.swift
//  Blog Nerd RanchTests
//
//  Created by Chris Downie on 8/28/18.
//  Copyright © 2018 Chris Downie. All rights reserved.
//

import XCTest
@testable import Blog_Nerd_Ranch

class PostMetadataDataSourceTests: XCTestCase {
    
    var testMetadataList: [PostMetadata]!
    
    private let postData1 = """
        [{
          "title" : "A Title",
          "postId": "3",
          "summary" : "test",
          "publishDate" : "2018-08-15T23:03:29Z",
          "author" : {
            "name" : "Zeke"
          }
        },

        {
          "title" : "C Title",
          "postId": "2",
          "summary" : "test",
          "publishDate" : "2018-08-22T23:03:29Z",
          "author" : {
            "name" : "Tom"
          }
        },
        {
          "title" : "B Title",
          "postId": "1",
          "summary" : "test",
          "publishDate" : "2018-08-30T23:03:29Z",
          "author" : {
            "name" : "Anna"
          }
        }]
        """
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        continueAfterFailure = false
        
        let decoder = JSONDecoder();
        let jsonData = postData1.data(using: .utf8)
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            testMetadataList = try decoder.decode(Array.self, from: jsonData!)
        } catch(let error) {
            XCTFail(error.localizedDescription)
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOrderWithNoPosts() {
        let ordering = DisplayOrdering(grouping: .none, sorting: .byPublishDate(recentFirst: false))
        
        let dataSource = PostMetadataDataSource(ordering: ordering)
        
        XCTAssertEqual(dataSource.numberOfSections(), 1)
        XCTAssertNil(dataSource.titleForSection(0))
        XCTAssertEqual(dataSource.numberOfPostsInSection(0), 0)
    }
    
    func testSortByAuthor() {
        // Sorting Author A-Z
        let ordering = DisplayOrdering(grouping: .none, sorting: .alphabeticalByAuthor(ascending: true))
        let dataSource = PostMetadataDataSource(ordering: ordering, postMetadata: testMetadataList!)
        let firstAuthor = dataSource.postMetadata(at: IndexPath(item: 0, section: 0 )).author["name"]
        XCTAssertEqual(firstAuthor, "Anna")
        
        // Sorting Author Z-A
        let ordering2 = DisplayOrdering(grouping: .none, sorting: .alphabeticalByAuthor(ascending: false))
        let dataSource2 = PostMetadataDataSource(ordering: ordering2, postMetadata: testMetadataList!)
        let firstAuthor2 = dataSource2.postMetadata(at: IndexPath(item: 0, section: 0 )).author["name"]
        XCTAssertEqual(firstAuthor2, "Zeke")
    }
    
    func testSortByTitle() {
        // Sorting Author A-Z
        let ordering = DisplayOrdering(grouping: .none, sorting: .alphabeticalByTitle(ascending: true))
        let dataSource = PostMetadataDataSource(ordering: ordering, postMetadata: testMetadataList!)
        let firstTitle = dataSource.postMetadata(at: IndexPath(item: 0, section: 0 )).title
        XCTAssertEqual(firstTitle, "A Title")
        
        // Sorting Author Z-A
        let ordering2 = DisplayOrdering(grouping: .none, sorting: .alphabeticalByTitle(ascending: false))
        let dataSource2 = PostMetadataDataSource(ordering: ordering2, postMetadata: testMetadataList!)
        let firstTitle2 = dataSource2.postMetadata(at: IndexPath(item: 0, section: 0 )).title
        XCTAssertEqual(firstTitle2, "C Title")
    }
    
}
