//
//  PokemonProfileViewModelIntegrationTests.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 22/04/25.
//

import XCTest
@testable import ShakespeareanPokemon

final class PokemonProfileViewModelIntegrationTests: XCTestCase {
    
    let PokemonResponseJSON: String = """
        {
            "id": 25,
            "name": "pikachu",
             "sprites": {
                "back_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/25.png",
                "back_female": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/25.png",
                "back_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/25.png",
                "back_shiny_female": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/25.png",
                "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png",
                "front_female": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/25.png",
                "front_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/25.png",
                "front_shiny_female": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/25.png"
            }
        }
        """

    let PokemonSpeciesResponseJSON: String = """
        {
        "flavor_text_entries": [
        {
        "flavor_text": "しっぽを　たてて　まわりの ようすを　さぐっていると　ときどき かみなりが　しっぽに　おちてくる。",
        "language": {
        "name": "ja-Hrkt",
        "url": "https://pokeapi.co/api/v2/language/1/"
        },
        "version": {
        "name": "x",
        "url": "https://pokeapi.co/api/v2/version/23/"
        }
        },
        {
        "flavor_text": "꼬리를 세우고 주변의 상황을 살피다 보면 가끔 꼬리에 번개가 친다.",
        "language": {
        "name": "ko",
        "url": "https://pokeapi.co/api/v2/language/3/"
        },
        "version": {
        "name": "x",
        "url": "https://pokeapi.co/api/v2/version/23/"
        }
        },
        {
        "flavor_text": "Il élève sa queue pour surveiller les environs. Elle attire souvent la foudre dans cette position.",
        "language": {
        "name": "fr",
        "url": "https://pokeapi.co/api/v2/language/5/"
        },
        "version": {
        "name": "x",
        "url": "https://pokeapi.co/api/v2/version/23/"
        }
        },
        {
        "flavor_text": "Es streckt seinen Schweif nach oben, um seine Umgebung zu prüfen. Häufig fährt ein Blitz hinein.",
        "language": {
        "name": "de",
        "url": "https://pokeapi.co/api/v2/language/6/"
        },
        "version": {
        "name": "x",
        "url": "https://pokeapi.co/api/v2/version/23/"
        }
        },
        {
        "flavor_text": "Levanta su cola para vigilar los alrededores. A veces, puede ser alcanzado por un rayo en esa pose.",
        "language": {
        "name": "es",
        "url": "https://pokeapi.co/api/v2/language/7/"
        },
        "version": {
        "name": "x",
        "url": "https://pokeapi.co/api/v2/version/23/"
        }
        },
        {
        "flavor_text": "Solleva la coda per esaminare l’ambiente circostante. A volte la coda è colpita da un fulmine quando è in questa posizione.",
        "language": {
        "name": "it",
        "url": "https://pokeapi.co/api/v2/language/8/"
        },
        "version": {
        "name": "x",
        "url": "https://pokeapi.co/api/v2/version/23/"
        }
        },
        {
        "flavor_text": "It raises its tail to check its surroundings. The tail is sometimes struck by lightning in this pose.",
        "language": {
        "name": "en",
        "url": "https://pokeapi.co/api/v2/language/9/"
        },
        "version": {
        "name": "x",
        "url": "https://pokeapi.co/api/v2/version/23/"
        }
        },
        {
        "flavor_text": "尻尾を　立てて　まわりの　様子を 探っていると　ときどき 雷が　尻尾に　落ちてくる。",
        "language": {
        "name": "ja",
        "url": "https://pokeapi.co/api/v2/language/11/"
        },
        "version": {
        "name": "x",
        "url": "https://pokeapi.co/api/v2/version/23/"
        }
        }
        ],
        "id": 25,
        "name": "pikachu"
        }
        """

    let shakespeareResponse = """
        {
        "success": {
        "total": 1
        },
        "contents": {
        "translated": "Thee did giveth mr. Tim a hearty meal,  but unfortunately what he did doth englut did maketh him kicketh the bucket.",
        "text": "You gave Mr. Tim a hearty meal, but unfortunately what he ate made him die.",
        "translation": "shakespeare"
        }
        }
        """

    var sut: PokemonProfileViewModel!
    var mockNetworkLayer: MockNetworkLayer!

    override func setUp() {
        super.setUp()
        mockNetworkLayer = MockNetworkLayer()
    }

    @MainActor
    func testLoad() async {
        let descriptor = ShakespeareanPokemonDescriptor(networkWorker: mockNetworkLayer)
        let imageProvider = PokemonImageProvider(networkWorker: mockNetworkLayer)
        sut = .init(descriptor: descriptor, imageProvider: imageProvider)

        let imageData = Data()
        mockNetworkLayer.stubbedRequestData[PokeAPIService.pokemonSpecies(name: "Pikachu").endpoint.absoluteString] = PokemonSpeciesResponseJSON.data(using: .utf8)!
        mockNetworkLayer.stubbedRequestData[PokeAPIService.pokemon(name: "Pikachu").endpoint.absoluteString] = PokemonResponseJSON.data(using: .utf8)!
        mockNetworkLayer.stubbedRequestData[FunTranslationService.shakespeare(text: "It raises its tail to check its surroundings. The tail is sometimes struck by lightning in this pose.").endpoint.absoluteString] = shakespeareResponse.data(using: .utf8)!
        mockNetworkLayer.fetchDataStubbedData = imageData
        
        await sut.load(for: "Pikachu")

        sut.onDataLoaded = { image, description in
            XCTAssert(true)
        }

        sut.onError = { _ in
            XCTFail()
        }
    }

}
