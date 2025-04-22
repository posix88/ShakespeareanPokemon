//
//  PokemonProfileViewModelTests.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 22/04/25.
//

import XCTest
@testable import ShakespeareanPokemon

final class PokemonProfileViewModelTests: XCTestCase {
    var mockPokemonImageService: MockPokemonImageProvider!
    var mockShakespeareanService: MockShakespeareanPokemonDescriptor!
    var sut: PokemonProfileViewModel!

    override func setUp() {
        super.setUp()
        mockPokemonImageService = .init()
        mockShakespeareanService = .init()
    }

    override func tearDown() {
        super.tearDown()
        mockShakespeareanService = nil
        mockPokemonImageService = nil
        sut = nil
    }

    @MainActor
    func testLoad() async {
        let imageData = Data()
        let descriptor = "Lorem ipsum"
        mockPokemonImageService.stubbedImageForPokemonResult = imageData
        mockShakespeareanService.stubbedShakespeareanDescriptionForPokemonResult = descriptor

        sut = .init(
            descriptor: mockShakespeareanService,
            imageProvider: mockPokemonImageService
        )

        sut.onDataLoaded = { image, description in
            XCTAssertEqual(image, imageData)
            XCTAssertEqual(description, descriptor)
        }

        sut.onError = { _ in
            XCTFail()
        }

        await sut.load(for: "Pikachu")

        XCTAssertTrue(mockShakespeareanService.invokedShakespeareanDescriptionForPokemon)
        XCTAssertEqual(mockShakespeareanService.invokedShakespeareanDescriptionForPokemonParameterPokemon, "Pikachu")
        XCTAssertEqual(mockShakespeareanService.invokedShakespeareanDescriptionForPokemonParameterLanguage, .english)

        XCTAssertTrue(mockPokemonImageService.invokedImageForPokemon)
        XCTAssertEqual(mockPokemonImageService.invokedImageForPokemonParameter, "Pikachu")
    }

    @MainActor
    func testLoadFail() async {
        let descriptor = "Lorem ipsum"
        mockPokemonImageService.stubbedImageForPokemonError = .missingImage
        mockShakespeareanService.stubbedShakespeareanDescriptionForPokemonResult = descriptor

        sut = .init(
            descriptor: mockShakespeareanService,
            imageProvider: mockPokemonImageService
        )

        sut.onDataLoaded = { image, description in
            XCTFail()
        }

        sut.onError = { _ in
            XCTAssert(true)
        }

        await sut.load(for: "Pikachu")

        XCTAssertTrue(mockShakespeareanService.invokedShakespeareanDescriptionForPokemon)
        XCTAssertEqual(mockShakespeareanService.invokedShakespeareanDescriptionForPokemonParameterPokemon, "Pikachu")
        XCTAssertEqual(mockShakespeareanService.invokedShakespeareanDescriptionForPokemonParameterLanguage, .english)

        XCTAssertTrue(mockPokemonImageService.invokedImageForPokemon)
        XCTAssertEqual(mockPokemonImageService.invokedImageForPokemonParameter, "Pikachu")
    }
}
