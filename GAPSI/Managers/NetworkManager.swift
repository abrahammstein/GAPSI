//
//  NetworkManager.swift
//  GAPSI
//
//  Created by Abraham on 3/13/21.
//

import UIKit

class NetworkManager {
    
    static let shared   = NetworkManager()
    private let baseURL = "https://00672285.us-south.apigw.appdomain.cloud/demo-gapsi/search?&query="
    private let apiKey = "adb8204d-d574-4394-8c1a-53226a40876e"
    let cache           = NSCache<NSString, UIImage>()
    
    private init() {}
    
    
    func getProducts(for productSearch: String, completed: @escaping (Result<[Product], GAPSIError>) -> Void) {
        let endpoint = baseURL + "\(productSearch)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidProductSearch))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "X-IBM-Client-Id")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let searchResponse = try decoder.decode(SearchResponse.self, from: data)
                completed(.success(searchResponse.items))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    // Method that will download the Image of the Product when using the class GAPSIProductImageView
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let self = self,
                error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                    completed(nil)
                    return
                }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        
        task.resume()
    }
}
