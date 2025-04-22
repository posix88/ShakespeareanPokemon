//
//  ShakespeareanPokemonDescriptorTests.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 19/04/25.
//

import XCTest
@testable import ShakespeareanPokemon

final class ShakespeareanPokemonDescriptorTests: XCTestCase {
    var sut: ShakespeareanPokemonDescriptor!
    var mockNetworkLayer: MockNetworkLayer!
    var mockParser: MockCodableParser!

    override func setUp() {
        super.setUp()
        mockParser = MockCodableParser()
        mockNetworkLayer = MockNetworkLayer()
        sut = ShakespeareanPokemonDescriptor(
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

    func testShakespeareanDescriptorSuccess() async throws {
        // GIVEN:
        let expectedTranslation: String = "Lorem ipsum dolor sit amet consectetur adipisicing elit."
        mockParser.stub(
            PokemonSpecieResponse.self,
            with: PokemonSpecieResponse(
                id: 1,
                name: "Pikachu",
                flavorTextEntries: [
                    .init(
                        flavorText: "I am electric!",
                        language: .init(code: .english)
                    )
                ]
            )
        )
        mockParser.stub(
            ShakespeareTranslation.self,
            with: ShakespeareTranslation(translated: expectedTranslation)
        )
        mockNetworkLayer.stubbedRequestData[PokeAPIService.pokemonSpecies(name: "Pikachu").endpoint.absoluteString] = Data()
        mockNetworkLayer.stubbedRequestData[FunTranslationService.shakespeare(text: "Lorem ipsum dolor sit amet consectetur adipisicing elit.").endpoint.absoluteString] = Data()

        // WHEN:
        let result = try await sut.shakespeareanDescription(for: "Pikachu", language: .english)

        // THEN:
        XCTAssertTrue(mockNetworkLayer.requestInvoked)
        XCTAssertEqual(mockNetworkLayer.requestInvokedCount, 2)
        XCTAssertEqual(mockParser.parseCalledCount, 2)
        XCTAssertEqual(result, expectedTranslation)
    }

    func testShakespeareanDescriptorFailParsePokemonResponse() async throws {
        // GIVEN:
        mockNetworkLayer.stubbedRequestData[PokeAPIService.pokemonSpecies(name: "Pikachu").endpoint.absoluteString] = Data()

        // WHEN:
        await XCTAssertThrowsErrorAsync(
            try await sut.shakespeareanDescription(for: "Pikachu", language: .english),
            ShakespeareanPokemonDescriptor.SPDError.parsingFailure
        )

        // THEN:
        XCTAssertTrue(mockNetworkLayer.requestInvoked)
        XCTAssertEqual(mockNetworkLayer.requestInvokedCount, 1)
        XCTAssertTrue(mockParser.parseCalled)
        XCTAssertEqual(mockParser.parseCalledCount, 1)
    }

    func testShakespeareanDescriptorFailMissingTranslation() async throws {
        // GIVEN:
        mockParser.stub(
            PokemonSpecieResponse.self,
            with: PokemonSpecieResponse(
                id: 1,
                name: "Pikachu",
                flavorTextEntries: [
                    .init(
                        flavorText: "Sono elettrico!",
                        language: .init(code: .italian)
                    )
                ]
            )
        )
        mockNetworkLayer.stubbedRequestData[PokeAPIService.pokemonSpecies(name: "Pikachu").endpoint.absoluteString] = Data()

        // WHEN:
        await XCTAssertThrowsErrorAsync(
            try await sut.shakespeareanDescription(for: "Pikachu", language: .english),
            ShakespeareanPokemonDescriptor.SPDError.missingTranslation
        )

        // THEN:
        XCTAssertTrue(mockNetworkLayer.requestInvoked)
        XCTAssertEqual(mockNetworkLayer.requestInvokedCount, 1)
        XCTAssertTrue(mockParser.parseCalled)
        XCTAssertEqual(mockParser.parseCalledCount, 1)
    }

    func testShakespeareanDescriptorFailParsingTranslation() async throws {
        // GIVEN:
        mockParser.stub(
            PokemonSpecieResponse.self,
            with: PokemonSpecieResponse(
                id: 1,
                name: "Pikachu",
                flavorTextEntries: [
                    .init(
                        flavorText: "I am electric!",
                        language: .init(code: .english)
                    )
                ]
            )
        )
        mockNetworkLayer.stubbedRequestData[PokeAPIService.pokemonSpecies(name: "Pikachu").endpoint.absoluteString] = Data()
        mockNetworkLayer.stubbedRequestData[FunTranslationService.shakespeare(text: "Lorem ipsum dolor sit amet consectetur adipisicing elit.").endpoint.absoluteString] = Data()
        
        // WHEN:
        await XCTAssertThrowsErrorAsync(
            try await sut.shakespeareanDescription(for: "Pikachu", language: .english),
            ShakespeareanPokemonDescriptor.SPDError.parsingFailure
        )

        // THEN:
        XCTAssertTrue(mockNetworkLayer.requestInvoked)
        XCTAssertEqual(mockNetworkLayer.requestInvokedCount, 2)
        XCTAssertTrue(mockParser.parseCalled)
        XCTAssertEqual(mockParser.parseCalledCount, 2)
    }

    func testShakespeareanDescriptorFailNetworkError() async throws {
        // GIVEN:
        mockNetworkLayer.stubbedRequestError = .responseIssue(.failed)

        // WHEN:
        await XCTAssertThrowsErrorAsync(
            try await sut.shakespeareanDescription(for: "Pikachu", language: .english),
            ShakespeareanPokemonDescriptor.SPDError.networkFailure
        )

        // THEN:
        XCTAssertTrue(mockNetworkLayer.requestInvoked)
        XCTAssertEqual(mockNetworkLayer.requestInvokedCount, 1)
        XCTAssertFalse(mockParser.parseCalled)
        XCTAssertEqual(mockParser.parseCalledCount, .zero)
    }
}
