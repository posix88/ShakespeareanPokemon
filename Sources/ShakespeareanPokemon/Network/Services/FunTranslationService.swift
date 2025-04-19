//
//  FunTranslationService.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 18/04/25.
//

import Foundation

enum FunTranslationService {
    case shakespeare(text: String)
}

extension FunTranslationService: Service {

    var serviceBaseURL : String {
        "https://api.funtranslations.com/translate"
    }

    var endpoint: URL {
        guard let url = URL(string: serviceBaseURL) else { fatalError("baseURL could not be configured.")}
        return url.appendingPathComponent(path)
    }

    var path: String {
        switch self {
        case .shakespeare:
            return "/shakespeare.json"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .shakespeare:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case .shakespeare(let text):
            return [
                "text": text
            ]
        }
    }
}

extension FunTranslationService: Equatable {}
