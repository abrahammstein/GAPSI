//
//  PersistenceManager.swift
//  GAPSI
//
//  Created by Abraham on 3/13/21.
//

import Foundation

enum PersistenceActionType {
    case add
}

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    enum Keys {
        static let history = "history"
    }
    
    
    static func updateWith(productSearched: ProductSearched, actionType: PersistenceActionType,
                           completed: @escaping (GAPSIError?) -> Void) {
        retrieveSearchHistory { result in
            switch result {
            case .success(var products):
                
                switch actionType {
                case .add:
                    guard !products.contains(productSearched) else {
                        completed(.alreadyInHistory)
                        return
                    }
                    
                    products.append(productSearched)
                    
                }
                
                completed(save(favorites: products))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    
    static func retrieveSearchHistory(completed: @escaping (Result<[ProductSearched], GAPSIError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.history) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([ProductSearched].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToSaveToHistory))
        }
    }
    
    
    static func save(favorites: [ProductSearched]) -> GAPSIError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.history)
            return nil
        } catch {
            return .unableToSaveToHistory
        }
    }
}
