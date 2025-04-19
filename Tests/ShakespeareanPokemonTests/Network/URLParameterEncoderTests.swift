//
//  URLParameterEncoderTests.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 18/04/25.
//

import XCTest
@testable import ShakespeareanPokemon

final class URLParameterEncoderTests: XCTestCase {
    var sut: URLParameterEncoder!

    override func setUpWithError() throws {
        sut = URLParameterEncoder()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_success_good_parameters() throws {
        let service = MockService.mock(id: 2)
        var request = URLRequest(url: service.endpoint)

        try sut.encode(urlRequest: &request, with: service.parameters)

        XCTAssertEqual(request.url?.absoluteString, "https://www.test.it/2/mock?id=2")
    }

    func test_success_no_parameters() throws {
        let service = MockService.mock(id: 2)
        var request = URLRequest(url: service.endpoint)

        try sut.encode(urlRequest: &request, with: nil)

        XCTAssertEqual(request.url?.absoluteString, "https://www.test.it/2/mock")
    }

    func test_success_no_value_parameters() throws {
        let service = MockService.mock(id: 2)
        var request = URLRequest(url: service.endpoint)

        try sut.encode(urlRequest: &request, with: ["json": nil])

        XCTAssertEqual(request.url?.absoluteString, "https://www.test.it/2/mock?json")
    }
}
