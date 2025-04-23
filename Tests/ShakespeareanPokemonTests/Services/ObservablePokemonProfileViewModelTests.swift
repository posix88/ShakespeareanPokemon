//
//  ObservablePokemonProfileViewModelTests.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 23/04/25.
//

import XCTest
@testable import ShakespeareanPokemon

final class ObservablePokemonProfileViewModelTests: XCTestCase {
    var sut: ObservablePokemonProfileViewModel!
    var mockBaseViewModel: MockPokemonProfileViewModelType!

    override func tearDown() {
        super.tearDown()
        mockBaseViewModel = nil
        sut = nil
    }

    @MainActor
    func testLoad() async {
        mockBaseViewModel = .init()
        sut = .init(base: mockBaseViewModel)

        await sut.load(for: "Pikachu")

        XCTAssertEqual(sut.status, .loading)
        XCTAssertTrue(mockBaseViewModel.invokedLoad)
    }

    @MainActor
    func testOnError() {
        mockBaseViewModel = .init()
        sut = .init(base: mockBaseViewModel)

        mockBaseViewModel.onError?("some error")

        XCTAssertEqual(sut.status, .error)
        XCTAssertEqual(sut.description, "some error")
    }

    @MainActor
    func testOnDataLoaded() {
        let imageData = Data()
        mockBaseViewModel = .init()
        sut = .init(base: mockBaseViewModel)

        mockBaseViewModel.onDataLoaded?(imageData, "Pikachu")

        XCTAssertEqual(sut.status, .idle)
        XCTAssertEqual(sut.description, "Pikachu")
        XCTAssertEqual(sut.imageData, imageData)
    }
}
