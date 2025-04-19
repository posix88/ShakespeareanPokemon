//
//  ShakespeareTranslation.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 18/04/25.
//

struct ShakespeareTranslation: Decodable {
    let translated: String
}

extension ShakespeareTranslation {
    private enum RootKeys: String, CodingKey {
        case contents
    }

    private enum ContentsKeys: String, CodingKey {
        case translated
    }

    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        let contentsContainer = try rootContainer.nestedContainer(keyedBy: ContentsKeys.self, forKey: .contents)
        let translated = try contentsContainer.decode(String.self, forKey: .translated)
        self.translated = translated.removingPercentEncoding ?? translated
    }
}
