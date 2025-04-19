//
//  NetworkLayerWorkerTests.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 18/04/25.
//
import XCTest
@testable import ShakespeareanPokemon

final class NetworkLayerWorkerTests: XCTestCase {
    var mockSession: MockNetworkSession!
    var mockURLEncoder: MockURLParameterEncoder!

    override func setUp() {
        super.setUp()
        mockSession = .init()
        mockURLEncoder = .init()
    }

    override func tearDown() {
        super.tearDown()
        mockSession = nil
        mockURLEncoder = nil
    }

    func testRequestSuccess() async throws {
        // GIVEN
        let url = URL(string: "https://www.test.it/1/mock?id=1")!
        let data = Data(base64Encoded: "test")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        mockSession.stubbedDataForRequestResult = (data, response)
        let manager = NetworkLayerWorker(session: mockSession, urlEncoder: mockURLEncoder)

        // WHEN:
        let result = try await manager.request(MockService.mock(id: 1))

        // THEN:
        XCTAssertTrue(mockURLEncoder.invokedEncode)
        XCTAssertTrue(mockSession.invokedDataForRequest)
        XCTAssertEqual(result, data)
    }

    func testRequestFailURLEncoder() async {
        // GIVEN
        let url = URL(string: "https://www.test.it/1/mock?id=1")!
        let data = Data()
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        mockSession.stubbedDataForRequestResult = (data, response)
        mockURLEncoder.stubbedError = .missingURL
        let manager = NetworkLayerWorker(session: mockSession, urlEncoder: mockURLEncoder)

        // WHEN:
        await XCTAssertThrowsErrorAsync(
            try await manager.request(MockService.mock(id: 1)),
            NetworkError.missingURL
        )
    }

    func testRequestFailNoData() async {
        // GIVEN
        let url = URL(string: "https://www.test.it/1/mock?id=1")!
        let data = Data()
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        mockSession.stubbedDataForRequestResult = (data, response)
        let manager = NetworkLayerWorker(session: mockSession, urlEncoder: mockURLEncoder)

        // WHEN:
        await XCTAssertThrowsErrorAsync(
            try await manager.request(MockService.mock(id: 1)),
            NetworkError.noData
        )
    }

    func testRequestFailNetworkErrorNotFound() async {
        // GIVEN
        let url = URL(string: "https://www.test.it/1/mock?id=1")!
        let data = Data()
        let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)!
        mockSession.stubbedDataForRequestResult = (data, response)
        let manager = NetworkLayerWorker(session: mockSession, urlEncoder: mockURLEncoder)

        // WHEN:
        await XCTAssertThrowsErrorAsync(
            try await manager.request(MockService.mock(id: 1)),
            NetworkError.responseIssue(.notFound)
        )
    }

    func testRequestFailNetworkErrorAuth() async {
        // GIVEN
        let url = URL(string: "https://www.test.it/1/mock?id=1")!
        let data = Data()
        let response = HTTPURLResponse(url: url, statusCode: 401, httpVersion: nil, headerFields: nil)!
        mockSession.stubbedDataForRequestResult = (data, response)
        let manager = NetworkLayerWorker(session: mockSession, urlEncoder: mockURLEncoder)

        // WHEN:
        await XCTAssertThrowsErrorAsync(
            try await manager.request(MockService.mock(id: 1)),
            NetworkError.responseIssue(.authenticationError)
        )
    }

    func testRequestFailNetworkErrorBadReq() async {
        // GIVEN
        let url = URL(string: "https://www.test.it/1/mock?id=1")!
        let data = Data()
        let response = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)!
        mockSession.stubbedDataForRequestResult = (data, response)
        let manager = NetworkLayerWorker(session: mockSession, urlEncoder: mockURLEncoder)

        // WHEN:
        await XCTAssertThrowsErrorAsync(
            try await manager.request(MockService.mock(id: 1)),
            NetworkError.responseIssue(.badRequest)
        )
    }

    func testRequestFailNetworkErrorServer() async {
        // GIVEN
        let url = URL(string: "https://www.test.it/1/mock?id=1")!
        let data = Data()
        let response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)!
        mockSession.stubbedDataForRequestResult = (data, response)
        let manager = NetworkLayerWorker(session: mockSession, urlEncoder: mockURLEncoder)

        // WHEN:
        await XCTAssertThrowsErrorAsync(
            try await manager.request(MockService.mock(id: 1)),
            NetworkError.responseIssue(.serverError)
        )
    }

    func testRequestFailNetworkSessionError() async {
        enum OtherError: Error {
            case other
        }
        // GIVEN
        mockSession.stubbedDataForRequestError = OtherError.other
        let manager = NetworkLayerWorker(session: mockSession, urlEncoder: mockURLEncoder)

        // WHEN:
        await XCTAssertThrowsErrorAsync(
            try await manager.request(MockService.mock(id: 1)),
            NetworkError.unknownError(OtherError.other)
        )
    }

    func testFetchDataErrorNoData() async {
        // GIVEN
        let url = URL(string: "https://www.test.it/1/mock?id=1")!
        let data = Data()
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        mockSession.stubbedDataFromURLResult = (data, response)
        let manager = NetworkLayerWorker(session: mockSession, urlEncoder: mockURLEncoder)

        // WHEN:
        await XCTAssertThrowsErrorAsync(
            try await manager.fetchData(from: url),
            NetworkError.noData
        )
    }

    func testFetchDataNetworkSessionError() async {
        enum OtherError: Error {
            case other
        }
        // GIVEN
        mockSession.stubbedDataForRequestError = OtherError.other
        let manager = NetworkLayerWorker(session: mockSession, urlEncoder: mockURLEncoder)

        // WHEN:
        await XCTAssertThrowsErrorAsync(
            try await manager.request(MockService.mock(id: 1)),
            NetworkError.unknownError(OtherError.other)
        )
    }

    func testFetchDataSuccess() async throws {
        // GIVEN
        let url = URL(string: "https://www.test.it/1/mock?id=1")!
        let data = Data(base64Encoded: "test")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        mockSession.stubbedDataFromURLResult = (data, response)
        let manager = NetworkLayerWorker(session: mockSession, urlEncoder: mockURLEncoder)

        // WHEN:
        let result = try await manager.fetchData(from: url)

        // THEN:
        XCTAssertTrue(mockSession.invokedDataFromURL)
        XCTAssertEqual(mockSession.invokedDataFromURLParameter, url)
        XCTAssertEqual(result, data)
    }

    func testFetchDataFailNetworkSessionError() async {
        enum OtherError: Error {
            case other
        }
        // GIVEN
        let url = URL(string: "https://www.test.it/1/mock?id=1")!
        mockSession.stubbedDataFromURLError = OtherError.other
        let manager = NetworkLayerWorker(session: mockSession, urlEncoder: mockURLEncoder)

        // WHEN:
        await XCTAssertThrowsErrorAsync(
            try await manager.fetchData(from: url),
            NetworkError.unknownError(OtherError.other)
        )
    }
}



func XCTAssertThrowsErrorAsync<T, R>(
    _ expression: @autoclosure () async throws -> T,
    _ errorThrown: @autoclosure () -> R,
    _ message: @autoclosure () -> String = "This method should fail",
    file: StaticString = #filePath,
    line: UInt = #line
) async where R: Equatable, R: Error  {
    do {
        let _ = try await expression()
        XCTFail(message(), file: file, line: line)
    } catch {
        XCTAssertEqual(error as? R, errorThrown())
    }
}
