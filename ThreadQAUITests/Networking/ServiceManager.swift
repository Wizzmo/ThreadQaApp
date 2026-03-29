//
//  ServiceManager.swift
//  ThreadQA
//
//  Created by Maxim Makarov on 10.03.2026.
//


import Foundation

struct ServiceManager {
    func getUsers(page: Int) -> URL {
        return URL(string: "https://reqres.in/api/users?page=\(page)")!
    }
}

extension ServiceManager {
    
    private func createRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 30
        
        // Добавляем стандартные заголовки
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("ThreadQA/1.0 (iOS)", forHTTPHeaderField: "User-Agent")
        
        // Ваш API ключ
        request.addValue("reqres_794ab2987830423dae66d4fdab1f2a27", forHTTPHeaderField: "x-api-key")
        
        return request
    }
    
    func getRequest<T:Decodable>(resource: URL, decodeType: T.Type) -> T {
        let request = createRequest(url: resource)
        
        var decodedData: T? = nil
        let semaphor = DispatchSemaphore(value: 0)
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, err) in
            if let error = err {
                print("REQUEST ERROR: \(error.localizedDescription)")
                semaphor.signal()
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("RESPONSE STATUS: \(httpResponse.statusCode)")
                print("RESPONSE URL: \(httpResponse.url?.absoluteString ?? "N/A")")
            }
            
            guard let data = data else {
                print("NO DATA RECEIVED")
                semaphor.signal()
                return
            }
            
            print("DATA SIZE: \(data.count) bytes")
            
            do {
                decodedData = try JSONDecoder().decode(T.self, from: data)
                print("JSON DECODE SUCCESS")
            } catch {
                print("JSON DECODE ERROR: \(error.localizedDescription)")
                if let rawString = String(data: data, encoding: .utf8) {
                    print("RAW DATA: \(rawString)")
                }
            }
            
            semaphor.signal()
        }.resume()
        
        semaphor.wait()
        return decodedData!
    }
    
    func getRequestAsString(resource: URL) -> String {
        let request = createRequest(url: resource)
        
        var decodedData = ""
        let semaphor = DispatchSemaphore(value: 0)
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, err) in
            if let error = err {
                print("REQUEST ERROR: \(error.localizedDescription)")
                semaphor.signal()
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("RESPONSE STATUS: \(httpResponse.statusCode)")
                print("RESPONSE URL: \(httpResponse.url?.absoluteString ?? "N/A")")
            }
            
            guard let data = data else {
                print("NO DATA RECEIVED")
                semaphor.signal()
                return
            }
            
            print("DATA SIZE: \(data.count) bytes")
            
            if let stringData = String(data: data, encoding: .utf8) {
                decodedData = stringData
                print("STRING DECODE SUCCESS")
            } else {
                print("STRING DECODE ERROR")
            }
            
            semaphor.signal()
        }.resume()
        
        semaphor.wait()
        return decodedData
    }
}
