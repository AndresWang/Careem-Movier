//
//  SearchInteractorTests.swift
//  Careem MovierTests
//
//  Created by Andres Wang on 2018/4/2.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import XCTest
@testable import Careem_Movier

class SearchInteractorTests: XCTestCase {
    var sut: SearchInteractor!
    var api: APISpy!
    var dataStore: DataStoreSpy!
    var request: SearchRequest!
    
    // MARK: - APISpy
    class APISpy: APIDelegate {
        var startDataTaskWasCalled = false
        var givenURL: URL!
        
        var output: APIOutputDelegate?
        var dataTask: URLSessionDataTask?
        func startDataTask(url: URL) {
            startDataTaskWasCalled = true
            givenURL = url
        }
    }
    
    // MARK: - DataStoreSpy
    class DataStoreSpy: DataStoreDelegate {
        var saveSuccessfulQueryWasCalled = false
        func saveSuccessfulQuery(text: String) {
            saveSuccessfulQueryWasCalled = true
        }
        func fetchSuggestionQueries() -> [Query] {
            return []
        }
    }
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        sut = SearchInteractor()
        api = APISpy()
        dataStore = DataStoreSpy()
        sut.api = api
        sut.dataStore = dataStore
        request = SearchRequest(text: "Batman", page: 1, successHandler: { (_, _) in}, errorHandler: {})
    }
    override func tearDown() {
        sut = nil
        api = nil
        dataStore = nil
        request = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    func testSearchShouldSetIsLoadMoreToFalse() {
        // given
        sut.isLoadMore = true
        
        // when
        sut.search(request: request)
        
        // then
        XCTAssertFalse(sut.isLoadMore)
    }
    func testSearchShouldSaveSearchRequest() {
        // given
        sut.searchRequest = nil
        
        // when
        sut.search(request: request)
        
        // then
        XCTAssertNotNil(sut.searchRequest)
    }
    func testSearchShouldDelegateToAPI() {
        // given, when
        sut.search(request: request)
        
        // then
        XCTAssertTrue(api.startDataTaskWasCalled)
    }
    func testSearchShouldGiveCorrectURLToAPI() {
        // given
        request.page = 3
        let expectURL = MoviedbAPI.searchURL(with: request.text, page: request.page)
        
        // when
        sut.search(request: request)
        
        // then
        XCTAssertEqual(api.givenURL, expectURL)
    }
    func testSaveSuccessfulQueryShouldDelegateToDataStore() {
        // given
        let searchText = "Batman"
        
        // when
        sut.saveSuccessfulQuery(searchText: searchText)
        
        // then
        XCTAssertTrue(dataStore.saveSuccessfulQueryWasCalled)
    }
    
}
