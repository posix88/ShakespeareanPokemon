//
//  MockService.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 18/04/25.
//
import Foundation
@testable import ShakespeareanPokemon

enum MockService {
    case mock(id:Int)
}

extension MockService: Service {

    var endpoint: URL {
        baseURL.appendingPathComponent(path)
    }

    var environmentBaseURL : String {
        "https://www.test.it/"
    }

    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }

    var path: String {
        switch self {
        case .mock(let id):
            return "\(id)/mock"
        }
    }

    var httpMethod: HTTPMethod {
        return .get
    }

    var parameters: Parameters? {
        switch self {
        case .mock(let id):
            return ["id": id]
        }
    }
}
