//
//  FakeApiService.swift
//  RickAndMortyAppTests
//
//  Created by Bladimir Salinas on 29/03/26.
//

import Foundation
@testable import RickAndMortyApp


class CharacterListFakeApiServiceSuccess: ApiService {
    
    func getDataFromGetRequest<Response: Codable>(from url: String) async throws -> Response {
        do {
           
            let json = CharacterListFake.makeCharacterListJsonfake()
            let decodedData = try JSONDecoder().decode(Response.self, from: json)
            return decodedData
            
        } catch {
            
            if (error as? DecodingError ) != nil {
                throw AppError.parseError
            }
            throw AppError.serviceError(error: error)
            
        }
    }
}


class CharacterListFakeApiServiceFailure: ApiService {
    func getDataFromGetRequest<Response: Codable>(from url: String) async throws -> Response {
        throw AppError.missingData
    }
}

class CharacterListFakeApiServiceParseErrorFailure: ApiService {
    func getDataFromGetRequest<Response: Codable>(from url: String) async throws -> Response {
        do {
            
            let json = CharacterListFake.makeCharacterListJsonfakeParseError()
            let decodedData = try JSONDecoder().decode(Response.self, from: json)
            return decodedData
            
        } catch {
            
            if (error as? DecodingError) != nil {
                throw AppError.parseError
            }
            throw AppError.serviceError(error: error)
            
        }
    }
}
