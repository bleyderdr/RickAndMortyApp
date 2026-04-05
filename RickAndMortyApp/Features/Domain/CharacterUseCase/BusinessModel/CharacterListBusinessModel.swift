//
//  CharacterListBusinessModel.swift
//  RickAndMortyApp
//
//  Created by Bladimir Salinas on 30/03/26.
//

import Foundation

// MARK: - CharacterListBusinessModel
struct CharacterListBusinessModel: Codable{
    let info: InfoBusinessModel
    let results: [CharacterBusinessModel]
    
    init(response: CharacterListResponse) {
        info = InfoBusinessModel(
            next: response.info.next,
            prev: response.info.prev
        )
        
        results = response.results.map {response in
            CharacterBusinessModel(response: response )
        }
    }}

// MARK: - Info
struct InfoBusinessModel: Codable {
    let next: String?
    let prev: String?
    
    init(next: String?, prev: String?) {
        self.next = next
        self.prev = prev
    }
    
}

// MARK: - Result
struct CharacterBusinessModel: Codable {
    let id: Int
    let name: String
    let status: StatusBusinessModel
    let species: SpeciesBusinessModel
    let type: String
    let gender: GenderBusinessModel
    let origin: LocationBusinessModel
    let location: LocationBusinessModel
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
    var listOfEpisodes: String {
        episode.compactMap { URL(string: $0)?.lastPathComponent}.joined(separator: ", ")
    }
    
    init(response: CharacterResponse) {
        self.id = response.id
        self.name = response.name
        self.status = StatusBusinessModel(response: response.status)
        self.species = SpeciesBusinessModel(response: response.species)
        self.type = response.type
        self.gender = GenderBusinessModel(response: response.gender)
        self.origin = LocationBusinessModel(
            name: response.origin.name,
            url: response.origin.url
        )
        self.location = LocationBusinessModel(
            name: response.location.name,
            url: response.location.url
        )
        self.image = response.image
        self.episode = response.episode
        self.url = response.url
        self.created = response.created
    }
    
}

// MARK: - Location
struct LocationBusinessModel: Codable {
    let name: String
    let url: String
}

//////////////////////////////////////////////////////////
// MARK: - Enums con fallback (NO rompen el decode)
//////////////////////////////////////////////////////////

enum StatusBusinessModel: Codable {
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

enum GenderBusinessModel: Codable {
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

enum SpeciesBusinessModel: Codable {
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



//MARK: - init helper

extension StatusBusinessModel {
    init(response: StatusResponse) {
        switch response {
        case .alive:
            self = .alive
        case .dead:
            self = .dead
        case .unknown:
            self = .unknown
        }
    }
}

extension GenderBusinessModel {
    init(response: GenderResponse) {
        switch response {
        case .female:
            self = .female
        case .male:
            self = .male
        case .unknown:
            self = .unknown
        }
    }
}

extension SpeciesBusinessModel {
    init(response: SpeciesResponse) {
        switch response {
        case .alien:
            self = .alien
        case .human:
            self = .human
        case .humanoid:
            self = .humanoid
        case .mythologicalCreature:
            self = .mythologicalCreature
        case .unknown(let value):
            self = .unknown(value)
        }
    }
}
