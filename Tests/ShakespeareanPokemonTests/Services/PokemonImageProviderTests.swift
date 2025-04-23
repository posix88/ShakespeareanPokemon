//
//  PokemonImageProviderTests.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 19/04/25.
//

import XCTest
@testable import ShakespeareanPokemon

final class PokemonImageProviderTests: XCTestCase {
    var sut: PokemonImageProvider!
    var mockNetworkLayer: MockNetworkLayer!
    var mockParser: MockCodableParser!

    override func setUp() {
        super.setUp()
        mockParser = MockCodableParser()
        mockNetworkLayer = MockNetworkLayer()
        sut = PokemonImageProvider(
            networkWorker: mockNetworkLayer,
            parser: mockParser
        )
    }

    override func tearDown() {
        super.tearDown()
        mockParser = nil
        mockNetworkLayer = nil
        sut = nil
    }

    func testImageSuccess() async throws {
        // GIVEN:
        let imageData = Data()
        mockParser.stub(
            PokemonResponse.self,
            with: PokemonResponse(
                id: 1,
                name: "Pikachu",
                sprites: .init(front: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/6.png")
            )
        )
        mockNetworkLayer.stubbedRequestData[PokeAPIService.pokemon(name: "Pikachu").endpoint.absoluteString] = Data()
        mockNetworkLayer.fetchDataStubbedData = imageData

        // WHEN:
        let result = try await sut.image(for: "Pikachu")

        // THEN:
        XCTAssertTrue(mockParser.parseCalled)
        XCTAssertTrue(mockNetworkLayer.requestInvoked)
        XCTAssertTrue(mockNetworkLayer.fetchDataInvoked)
        XCTAssertEqual(result, imageData)
    }

    func testImageFailMissingImage() async {
        // GIVEN:
        let imageData = Data()
        mockParser.stub(
            PokemonResponse.self,
            with: PokemonResponse(
                id: 1,
                name: "Pikachu",
                sprites: .init(front: "")
            )
        )
        mockNetworkLayer.stubbedRequestData[PokeAPIService.pokemon(name: "Pikachu").endpoint.absoluteString] = Data()
        mockNetworkLayer.fetchDataStubbedData = imageData

        // WHEN:
        await XCTAssertThrowsErrorAsync(
            try await sut.image(for: "Pikachu"),
            PokemonImageError.missingImage
        )

        // THEN:
        XCTAssertTrue(mockParser.parseCalled)
        XCTAssertTrue(mockNetworkLayer.requestInvoked)
        XCTAssertFalse(mockNetworkLayer.fetchDataInvoked)
    }

    func testImageFailRequestNetworkFailure() async {
        // GIVEN:
        mockNetworkLayer.stubbedRequestError = .responseIssue(.failed)

        // WHEN:
        await XCTAssertThrowsErrorAsync(
            try await sut.image(for: "Pikachu"),
            PokemonImageError.networkFailure
        )

        // THEN:
        XCTAssertTrue(mockNetworkLayer.requestInvoked)
        XCTAssertFalse(mockParser.parseCalled)
        XCTAssertFalse(mockNetworkLayer.fetchDataInvoked)
    }

    func testImageFailFetchDataNetworkFailure() async {
        // GIVEN:
        mockParser.stub(
            PokemonResponse.self,
            with: PokemonResponse(
                id: 1,
                name: "Pikachu",
                sprites: .init(front: "imageURL")
            )
        )
        mockNetworkLayer.stubbedRequestData[PokeAPIService.pokemon(name: "Pikachu").endpoint.absoluteString] = Data()
        mockNetworkLayer.stubbedFetchDataError = .responseIssue(.failed)

        // WHEN:
        await XCTAssertThrowsErrorAsync(
            try await sut.image(for: "Pikachu"),
            PokemonImageError.networkFailure
        )

        // THEN:
        XCTAssertTrue(mockNetworkLayer.requestInvoked)
        XCTAssertTrue(mockParser.parseCalled)
        XCTAssertTrue(mockNetworkLayer.fetchDataInvoked)
    }

    func testImageFailParseFailure() async {
        // GIVEN:
        mockNetworkLayer.stubbedRequestData[PokeAPIService.pokemon(name: "Pikachu").endpoint.absoluteString] = Data()

        // WHEN:
        await XCTAssertThrowsErrorAsync(
            try await sut.image(for: "Pikachu"),
            PokemonImageError.parsingFailure
        )

        // THEN:
        XCTAssertTrue(mockNetworkLayer.requestInvoked)
        XCTAssertTrue(mockParser.parseCalled)
        XCTAssertFalse(mockNetworkLayer.fetchDataInvoked)
    }
}
