//
//  CharacterRepository.swift
//  RickAndMortyApp
//
//  Created by Bladimir Salinas on 28/03/26.
//

import Foundation

protocol CharacterRepository {
    
    func getCharacterList(pageNumber: String?) async throws -> CharacterListResponse
    func searchCharacter(by name: String, and pageNumber: String?) async throws -> CharacterListResponse
    
}

class DefaultCharacterRepository: CharacterRepository {
    
    
    private let apiService: ApiService
    
    private let cache = DefaultNSCacheStoreDatasource<String, CharacterListResponse>()
    
    init(apiService: ApiService = DefaultApiService()) {
        self.apiService = apiService
    }
    
    func getCharacterList(pageNumber: String?) async throws -> CharacterListResponse {
        
        if let cachedResponse = retreive(by: pageNumber ?? "1") {
            return cachedResponse
        }
        
        do {
            
            let endpoint = RemoteURL.baseUrl + RemoteURL.characterUrl + "\(RemoteURL.pagination)\(pageNumber ?? "1")"
            let response: CharacterListResponse = try await apiService.getDataFromGetRequest(from: endpoint)
            self.save(whit: pageNumber ?? "1", response: response)
            return response
            
        } catch {
            throw error
        }
    }
    
    func searchCharacter(by name: String, and pageNumber: String?) async throws -> CharacterListResponse {
        do {
            return try await apiService.getDataFromGetRequest(from: getEndpointForPagination(by: name, and: pageNumber))
        } catch {
            throw error
        }
    }
}

//MARK: - Cache Handling

extension DefaultCharacterRepository {
    ///Obtener el cache
    private func retreive(by pageNumber: String) -> CharacterListResponse? {
        
        cache[pageNumber]
    }
    ///Guardar el cache
    private func save(whit pageNumber: String, response: CharacterListResponse) {
        let cache = DefaultNSCacheStoreDatasource<String, CharacterListResponse>()
        cache[pageNumber] = response
    }
}

//MARK: - endpoint construction

extension DefaultCharacterRepository {
    private func getEndpointForPagination(by name: String, and pageNumber: String?) -> String {
        if let pageNumber = pageNumber {
            return RemoteURL.baseUrl + RemoteURL.characterUrl + "\(RemoteURL.name)" + "\(RemoteURL.searchPagination)\(pageNumber)"
        } else {
            return RemoteURL.baseUrl + RemoteURL.characterUrl + "\(RemoteURL.name)"
        }
    }
}
