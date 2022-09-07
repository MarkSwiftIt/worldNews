//
//  NetworkService.swift
//  World News
//
//  Created by Mark Goncharov on 19.07.2022.
//

import Foundation


final class NetworkService {
        
    static let shared = NetworkService()
     
//MARK: - Struct Constants
    
    struct Constants {
        static let topHeadUrlString = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=d6627b8fc18d437984808fe1fd371bbc")
        
        static let searchUrlString = "https://newsapi.org/v2/everything?sortedBy=popularity&apiKey=d7e78f9ab838419bb7e85c765883be9a&q="
    }
    
    private init() {}
    
//MARK: - API Get

    public func getTopNews(completion: @escaping (Result<[Articles], Error>) -> Void) {
        
        guard let url = Constants.topHeadUrlString else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                
                do {
                    let result = try JSONDecoder().decode(ApiResponse.self, from: data)
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
//MARK: - API Search

    public func search(with query: String, completion: @escaping (Result<[Articles], Error>) -> Void) {
        
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        let urlString = Constants.searchUrlString + query
        guard let url = URL(string: urlString   ) else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                
                do {
                    let result = try JSONDecoder().decode(ApiResponse.self, from: data)
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
