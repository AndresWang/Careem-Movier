//
//  MoviedbAPITests.swift
//  Careem MovierTests
//
//  Created by Andres Wang on 2018/3/31.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import XCTest
@testable import Careem_Movier

class MoviedbAPITests: XCTestCase {
    var sut: MoviedbAPI!
    var output: APIOutputDelegate!
    
    // MARK: - Dummy Output
    class APIOutputDummy: APIOutputDelegate {
        func didRecieveResponse(data: Data?, response: URLResponse?, error: Error?) {}
    }
    
    // MARK: - Lifecyle
    override func setUp() {
        super.setUp()
        output = APIOutputDummy()
        sut = MoviedbAPI(output: output)
    }
    override func tearDown() {
        sut = nil
        output = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    func testMoviedbSearchURLIsWorking() {
        // given
        let url = MoviedbAPI.searchURL(with: "Batman", page: 1)
        var result: MoviedbAPI.JSON.Response?
        
        // when
        do {
            let data = try Data(contentsOf: url)
            result = data.parseTo(jsonType: MoviedbAPI.JSON.Response.self)
        } catch {
            print(error.localizedDescription)
        }
        
        // then
        XCTAssertNotNil(result)
    }
    func testMoviedbImageURLIsWorking() {
        // given
        let posterURL = "/cXqyVkLY2FElBl3rF6vHL3LUbHw.jpg"
        let url = MoviedbAPI.imageURL(size: .small, path: posterURL)
        var result: UIImage?
        
        // when
        do {
            let data = try Data(contentsOf: url)
            result = UIImage(data: data)
        } catch {
            print(error.localizedDescription)
        }
        
        // then
        XCTAssertNotNil(result)
    }
    func testStartDataTask() {
        
    }
}
