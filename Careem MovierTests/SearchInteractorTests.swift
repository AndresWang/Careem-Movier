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
    var successfulResponse: HTTPURLResponse!
    
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
        var fetchSuggestionQueriesWasCalled = false
        
        func saveSuccessfulQuery(text: String) {
            saveSuccessfulQueryWasCalled = true
        }
        func fetchSuggestionQueries() -> [Query] {
            fetchSuggestionQueriesWasCalled = true
            return []
        }
    }
    
    // MARK: Helper Methods
    func getData() -> Data? {
        let url = MoviedbAPI.searchURL(with: "Batman", page: 1)
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            print(error.localizedDescription)
            return nil
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
        successfulResponse = HTTPURLResponse(url: MoviedbAPI.searchURL(with: "Batman", page: 1), statusCode: 200, httpVersion: nil, headerFields: nil)
    }
    override func tearDown() {
        sut = nil
        api = nil
        dataStore = nil
        request = nil
        successfulResponse = nil
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
    func testLoadMoreShouldSetIsLoadMoreToTrue() {
        // given
        sut.searchRequest = request
        sut.isLoadMore = false
        
        // when
        sut.loadMore()
        
        // then
        XCTAssertTrue(sut.isLoadMore)
    }
    func testLoadMoreShouldIncrementPageBy1() {
        // given
        request.page = 4
        sut.searchRequest = request
        
        // when
        sut.loadMore()
        
        // then
        XCTAssertEqual(sut.searchRequest!.page, 5)
    }
    func testLoadMoreShouldDelegateToAPI() {
        // given
        sut.searchRequest = request
        
        // when
        sut.loadMore()
        
        // then
        XCTAssertTrue(api.startDataTaskWasCalled)
    }
    func testLoadMoreShouldGiveCorrectURLToAPI() {
        // given
        request.page = 3
        sut.searchRequest = request
        let expectURL = MoviedbAPI.searchURL(with: request.text, page: request.page + 1)
        
        // when
        sut.loadMore()
        
        // then
        XCTAssertEqual(api.givenURL, expectURL)
    }
    
    func testUpdateSuggestionQueriesShouldDelegateToDataStore() {
        // given, when
        sut.updateSuggestionQueries()
        
        // then
        XCTAssertTrue(dataStore.fetchSuggestionQueriesWasCalled)
    }
    
    func testDidRecieveResponseShouldIncrementSearchResponsePageBy1WhenSuccessfullyLoadMore() {
        // given
        sut.isLoadMore = true
        let searchResponse = Movie.Response(page: 3, total_results: 23, total_pages: 2, results: [])
        sut.searchResponse = searchResponse

        // when
        sut.didRecieveResponse(data: getData(), response: successfulResponse, error: nil)
        
        // then
        XCTAssertEqual(sut.searchResponse?.page, 4)
    }
    
    func testDidRecieveResponseShouldAppendNewQueriesWhenSuccessfullyLoadMore() {
        // given
        sut.isLoadMore = true
        let searchResponse = Movie.Response(page: 3, total_results: 23, total_pages: 2, results: [])
        sut.searchResponse = searchResponse
        let data = getData()
        let newQueriesCount = data?.parseTo(jsonType: MoviedbAPI.JSON.Response.self)?.results?.count ?? 0
        
        // when
        sut.didRecieveResponse(data: data, response: successfulResponse, error: nil)
        
        // then
        XCTAssertEqual(sut.searchResponse!.results!.count, newQueriesCount)
    }
    
    func testDidRecieveResponseShouldSaveResponseAfterSuccessfulSearch() {
        // given
        sut.isLoadMore = false
        sut.searchResponse = nil
        
        // when
        sut.didRecieveResponse(data: getData(), response: successfulResponse, error: nil)
        
        // then
        XCTAssertNotNil(sut.searchResponse)
    }
}
