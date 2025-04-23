//
//  SUIPokemonProfileView.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 23/04/25.
//

import SwiftUI

public struct SUIPokemonProfileView: View {
    @StateObject private var viewModel: ObservablePokemonProfileViewModel = .init()

    private let pokemon: String

    public init(pokemon: String) {
        self.pokemon = pokemon
    }

    public var body: some View {
        VStack(spacing: 8) {
            if let imageData = viewModel.imageData, let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 200, height: 200)
            }

            Text(viewModel.description)
                .font(.callout)

            if viewModel.status == .error {
                Button("Retry") {
                    Task { await viewModel.load(for: pokemon) }
                }
            }
        }
        .overlay {
            if viewModel.status == .loading {
                ProgressView()
            }
        }
        .task {
            await viewModel.load(for: pokemon)
        }
    }
}

#if DEBUG
#Preview {
    SUIPokemonProfileView(pokemon: "Charizard")
}
#endif
