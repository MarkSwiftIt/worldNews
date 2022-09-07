//
//  ModelApi.swift
//  World News
//
//  Created by Mark Goncharov on 19.07.2022.
//

import Foundation


struct ApiResponse: Codable {
    let articles: [Articles]
}

struct Articles: Codable {
    
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let name: String
}

