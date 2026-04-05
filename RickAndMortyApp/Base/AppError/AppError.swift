//
//  AppError.swift
//  RickAndMortyApp
//
//  Created by Bladimir Salinas on 26/03/26.
//

import Foundation


enum AppError: Error {
    case serviceError(error: Error)
    case invalidUrl
    case missingData
    case unEspectedError
    case parseError
}

extension AppError {
    var errorDescription: String? {
        switch self {
        case .serviceError(let error):
            return NSLocalizedString("\(error.localizedDescription)", comment: "Service Error")
            
        case .invalidUrl:
            return NSLocalizedString("App Error", comment: "Invalid URL")
            
        case .missingData:
            return NSLocalizedString("App Error", comment: "Missing Data")
            
        case .unEspectedError:
            return NSLocalizedString("App Error", comment: "Error inesperado, inténtelo mas tarde")
            
        case .parseError:
            return NSLocalizedString("App Error", comment: "Parse Error")
        }
    }
}
