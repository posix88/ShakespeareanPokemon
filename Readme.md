# 🔬 ShakespeareanPokemon SDK

A lightweight, modular Swift SDK for fetching Pokémon descriptions and images — with a twist! Transforms standard Pokémon flavor text into Shakespearean English using the [FunTranslations API](https://funtranslations.com) and data from the [PokéAPI](https://pokeapi.co).

---

## 🚀 Features

- 🔎 Retrieve flavor text descriptions for any Pokémon.
- 🎭 Translate descriptions into Shakespearean English.
- 🖼 Fetch official Pokémon sprite images.
- ⚡️ Async/await API design.

---

## 📆 Installation

> This SDK is designed to be used via Swift Package Manager.

1. Open your Xcode project.
2. Go to **File > Add Packages**.
3. Paste the repository URL:
   ```
   https://github.com/posix88/ShakespeareanPokemon.git
   ```
4. Select the version or branch you want to install.

---

## 🧑‍💻 Usage

### 👩‍🎓 Shakespearean Description

```swift
let descriptor = ShakespeareanPokemonDescriptor()
let description = try await descriptor.shakespeareanDescription(for: "charizard")

print(description)
// Output: "Charizard, yond flames burneth with valorous fire."
```

### 🖼 Pokémon Image

```swift
let imageProvider = PokemonImageProvider()
let imageData = try await imageProvider.image(for: "pikachu")
let image = UIImage(data: imageData)
```

---

## 🧩 UI Components

- Fetches and displays both the image and translated description.
- Includes loading and error state handling.

### UIKit View

```swift
let profileView = PokemonProfileView()
profileView.pokemonName = "bulbasaur"
```

### SwiftUI View

```swift
var body: some View {
    SUIPokemonProfileView(pokemon: "Charizard")
}
```

---

## 🧱 Architecture Overview

- `NetworkLayer`: Abstracts networking operations with protocol-based injection and testability.
- `Parser`: Generic, decodable-based parser to transform `Data` into Swift models.
- `PokemonImageProvider`: Retrieves and decodes Pokémon sprite data.
- `ShakespeareanPokemonDescriptor`: Fetches Pokémon flavor text and translates it using the FunTranslations API.
- `Service`: Represents individual endpoints used throughout the SDK.

---

## ⚠️ Notes

- The FunTranslations API has rate limiting (5 requests/hour for free tier).
- Network failures and translation errors are gracefully handled via typed error enums (`PokemonImageError`, `ShakespeareanError`).
- I found some issues on iOS 18.4 simulator going always on timeout, not the case using iOS 18.2 simulator


