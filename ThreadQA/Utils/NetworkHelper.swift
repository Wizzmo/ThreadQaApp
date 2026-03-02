//
//  NetworkHelper.swift
//  ThreadQA
//
//  Created by Maxim Makarov on 02.03.2026.
//

import Foundation

class NetworkHelper {
    
    static func createRequest(url: String, method: String = "GET", parameters: [String: Any]? = nil) -> URLRequest? {
        guard let requestURL = URL(string: url) else {
            print("Invalid URL: \(url)")
            return nil
        }
        
        var request = URLRequest(url: requestURL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
        request.httpMethod = method
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("ThreadQA/1.0 (iOS)", forHTTPHeaderField: "User-Agent")
        
        request.addValue("reqres_794ab2987830423dae66d4fdab1f2a27", forHTTPHeaderField: "x-api-key")
        
        if method == "POST", let parameters = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch {
                print("Failed to serialize parameters: \(error)")
                return nil
            }
        }
        
        return request
    }
}
