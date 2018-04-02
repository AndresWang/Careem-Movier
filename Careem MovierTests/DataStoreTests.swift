//
//  DataStoreTests.swift
//  Careem MovierTests
//
//  Created by Andres Wang on 2018/4/2.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import XCTest
import CoreData
@testable import Careem_Movier

class DataStoreTests: XCTestCase {
    var sut: CoreDataStore!
    
    // MARK: - Lifecyle
    override func setUp() {
        super.setUp()
        sut = TestCoreDataStore()
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    func testSaveSuccessfulQueryShouldSaveTheQuery() {
        // given
        let queryText = "Batman"
        
        // when
        sut.saveSuccessfulQuery(text: queryText)
        
        // then
        let results = sut.fetchSuggestionQueries()
        XCTAssert(results.count == 1)
        XCTAssertEqual(results.first!.text, queryText)
    }
    func testSaveSuccessfulQueryShouldAvoidDuplicateQuery() {
        // given
        let firstQuery = "Batman"
        let duplicateQuery = "batman"
        
        // when
        sut.saveSuccessfulQuery(text: firstQuery)
        sut.saveSuccessfulQuery(text: duplicateQuery)
        
        // then
        let results = sut.fetchSuggestionQueries()
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first!.text, firstQuery)
    }
    func testSaveSuccessfulQueryShouldKeepRecordsUnder10() {
        // given, when
        for i in 0...12 {sut.saveSuccessfulQuery(text: String(i))}
        
        // then
        let results = sut.fetchSuggestionQueries()
        XCTAssertEqual(results.count, 10)
    }
    func testFetchSuggestionQueriesShouldFetchSortedArrayWithAllQueriesNewestFirst() {
        // given
        let currentTime = Date()
        let queries = ["Mermaid", "Batman", "Harry Potter"]
        for (i, query) in queries.enumerated() {
            let newQuery = NSEntityDescription.insertNewObject(forEntityName: ManagedQuery.entityName(), into: sut.context) as! ManagedQuery
            newQuery.text = query
            newQuery.date = Date(timeInterval: TimeInterval(i * 60), since: currentTime)
        }
        
        // when
        let results = sut.fetchSuggestionQueries()
        
        // then
        XCTAssertEqual(results.count, 3)
        XCTAssertEqual(results[0].text, queries[2])
        XCTAssertEqual(results[1].text, queries[1])
        XCTAssertEqual(results[2].text, queries[0])
    }
}
