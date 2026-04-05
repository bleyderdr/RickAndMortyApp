//
//  CharacterListResponse.swift
//  RickAndMortyApp
//
//  Created by Bladimir Salinas on 28/03/26.
//

import Foundation

// MARK: - CharacterListResponse
struct CharacterListResponse: Codable {
    let info: InfoResponse
    let results: [CharacterResponse]
}

// MARK: - Info
struct InfoResponse: Codable {
    let count: Int
    let pages: Int
    let next: String
    let prev: String? // ✅ puede ser string o null
}

// MARK: - Result
struct CharacterResponse: Codable {
    let id: Int
    let name: String
    let status: StatusResponse
    let species: SpeciesResponse
    let type: String
    let gender: GenderResponse
    let origin: LocationResponse
    let location: LocationResponse
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

// MARK: - Location
struct LocationResponse: Codable {
    let name: String
    let url: String
}

//////////////////////////////////////////////////////////
// MARK: - Enums con fallback (NO rompen el decode)
//////////////////////////////////////////////////////////

enum StatusResponse: Codable {
    case alive
    case dead
    case unknown

    init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        switch value {
        case "Alive":
            self = .alive
        case "Dead":
            self = .dead
        default:
            self = .unknown
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let value: String
        switch self {
        case .alive: value = "Alive"
        case .dead: value = "Dead"
        case .unknown: value = "unknown"
        }
        try container.encode(value)
    }
}

enum GenderResponse: Codable {
    case female
    case male
    case unknown

    init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        switch value {
        case "Female":
            self = .female
        case "Male":
            self = .male
        default:
            self = .unknown
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let value: String
        switch self {
        case .female: value = "Female"
        case .male: value = "Male"
        case .unknown: value = "unknown"
        }
        try container.encode(value)
    }
}

enum SpeciesResponse: Codable {
    case alien
    case human
    case humanoid
    case mythologicalCreature
    case unknown(String) // 👈 guarda valores raros

    init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        switch value {
        case "Alien":
            self = .alien
        case "Human":
            self = .human
        case "Humanoid":
            self = .humanoid
        case "Mythological Creature":
            self = .mythologicalCreature
        default:
            self = .unknown(value) // 👈 nunca rompe
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let value: String
        switch self {
        case .alien: value = "Alien"
        case .human: value = "Human"
        case .humanoid: value = "Humanoid"
        case .mythologicalCreature: value = "Mythological Creature"
        case .unknown(let raw): value = raw
        }
        try container.encode(value)
    }
}
