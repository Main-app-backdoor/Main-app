// Proprietary Software License Version 1.0
//
// Copyright (C) 2025 BDG
//
// Backdoor App Signer is proprietary software. You may not use, modify, or distribute it except as expressly permitted under the terms of the Proprietary Software License.

import Foundation
import UIKit

/// Search result model
struct WebSearchResult {
    let title: String
    let description: String
    let url: URL
}

/// Possible search errors
enum SearchError: Error {
    case invalidQuery
    case networkError(Error)
    case parsingError
    case emptyResults
}

/// Manages web search functionality for the AI assistant
class WebSearchManager {
    // Singleton instance
    static let shared = WebSearchManager()
    
    // Private initializer for singleton pattern
    private init() {}
    
    /// Performs a web search for the given query
    /// - Parameters:
    ///   - query: The search query string
    ///   - completion: Callback with search results or error
    func performSearch(query: String, completion: @escaping (Result<[WebSearchResult], Error>) -> Void) {
        Debug.shared.log(message: "Performing web search for: \(query)", type: .info)
        
        // Create a search-safe URL query
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(SearchError.invalidQuery))
            return
        }
        
        // Use DuckDuckGo as a privacy-focused search engine
        let searchURLString = "https://api.duckduckgo.com/?q=\(encodedQuery)&format=json"
        guard let searchURL = URL(string: searchURLString) else {
            completion(.failure(SearchError.invalidQuery))
            return
        }
        
        // Create and configure the search task
        let task = URLSession.shared.dataTask(with: searchURL) { [weak self] (data, response, error) in
            // Handle network errors
            if let error = error {
                Debug.shared.log(message: "Search network error: \(error.localizedDescription)", type: .error)
                completion(.failure(SearchError.networkError(error)))
                return
            }
            
            // Ensure we have data
            guard let data = data else {
                Debug.shared.log(message: "No data returned from search", type: .error)
                completion(.failure(SearchError.emptyResults))
                return
            }
            
            // Process the search results
            self?.processSearchResults(data: data, query: query, completion: completion)
        }
        
        // Start the search
        task.resume()
    }
    
    /// Process search results from raw data
    private func processSearchResults(data: Data, query: String, completion: @escaping (Result<[WebSearchResult], Error>) -> Void) {
        do {
            // Try to parse the JSON response
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let results = extractSearchResults(from: json) {
                
                // Log the success and number of results
                Debug.shared.log(message: "Found \(results.count) search results for query: \(query)", type: .info)
                
                // Send the results to AI learning for improvement
                if !results.isEmpty {
                    let resultURLs = results.map { $0.url.absoluteString }
                    DispatchQueue.global(qos: .background).async {
                        AILearningManager.shared.processWebSearchData(query: query, results: resultURLs)
                    }
                }
                
                completion(.success(results))
            } else {
                Debug.shared.log(message: "Failed to parse search results", type: .error)
                completion(.failure(SearchError.parsingError))
            }
        } catch {
            Debug.shared.log(message: "Search result parsing error: \(error.localizedDescription)", type: .error)
            completion(.failure(SearchError.parsingError))
        }
    }
    
    /// Extract structured search results from DuckDuckGo response
    private func extractSearchResults(from json: [String: Any]) -> [WebSearchResult]? {
        var results: [WebSearchResult] = []
        
        // Extract the AbstractText if available (featured snippet)
        if let abstractText = json["AbstractText"] as? String,
           !abstractText.isEmpty,
           let abstractURL = json["AbstractURL"] as? String,
           let url = URL(string: abstractURL) {
            
            let abstractSource = json["AbstractSource"] as? String ?? "Source"
            let result = WebSearchResult(
                title: abstractSource,
                description: abstractText,
                url: url
            )
            results.append(result)
        }
        
        // Extract Related Topics (main results)
        if let relatedTopics = json["RelatedTopics"] as? [[String: Any]] {
            for topic in relatedTopics {
                if let text = topic["Text"] as? String,
                   let urlString = (topic["FirstURL"] as? String) ?? ((topic["Results"] as? [[String: Any]])?.first?["FirstURL"] as? String),
                   let url = URL(string: urlString) {
                    
                    // Split text into title and description if possible
                    var title = text
                    var description = ""
                    
                    if let separatorRange = text.range(of: " - ") {
                        title = String(text[..<separatorRange.lowerBound])
                        description = String(text[separatorRange.upperBound...])
                    }
                    
                    let result = WebSearchResult(
                        title: title,
                        description: description,
                        url: url
                    )
                    results.append(result)
                }
            }
        }
        
        return results
    }
    
    /// Format search results as a readable string
    func formatSearchResults(_ results: [WebSearchResult]) -> String {
        var formattedResults = ""
        
        for (index, result) in results.prefix(3).enumerated() {
            formattedResults += "\(index + 1). \(result.title)\n"
            if !result.description.isEmpty {
                formattedResults += "   \(result.description)\n"
            }
            formattedResults += "   \(result.url.absoluteString)\n\n"
        }
        
        if results.count > 3 {
            formattedResults += "...and \(results.count - 3) more results."
        }
        
        return formattedResults
    }
}
