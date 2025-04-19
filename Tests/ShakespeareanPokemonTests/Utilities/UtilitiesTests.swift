//
//  UtilitiesTests.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 18/04/25.
//

import XCTest
@testable import ShakespeareanPokemon

final class UtilitiesTests: XCTestCase {

    func testAsURL() {
        let urlString = "https://www.test.it/1/mock?id=1"
        XCTAssertNotNil(urlString.asURL)

        let notURL = ""
        XCTAssertNil(notURL.asURL)
    }
}
