//
//  Configure.swift
//  APIapp
//
//  Created by FRANCISCO AQUINO on 05/04/24.
//

import Foundation

struct APIClient {
    static let baseURL = URL(string: "http://localhost:3005/users")!

    static func fetchData(completion: @escaping (Result<Data, Error>) -> Void) {
        let url = baseURL.appendingPathComponent("/api/data")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }.resume()
    }

    static func addData(newData: Data, completion: @escaping (Error?) -> Void) {
        let url = baseURL.appendingPathComponent("/api/data")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = newData

        URLSession.shared.dataTask(with: request) { _, response, error in
            handleResponse(data: nil, response: response, error: error, completion: { result in
                if case .failure(let error) = result {
                    completion(error)
                } else {
                    completion(nil)
                }
            })
        }.resume()
    }

    static func updateData(updatedData: Data, completion: @escaping (Error?) -> Void) {
        let url = baseURL.appendingPathComponent("/api/data")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = updatedData

        URLSession.shared.dataTask(with: request) { _, response, error in
            handleResponse(data: nil, response: response, error: error, completion: { result in
                if case .failure(let error) = result {
                    completion(error)
                } else {
                    completion(nil)
                }
            })
        }.resume()
    }

    static func deleteData(completion: @escaping (Error?) -> Void) {
        let url = baseURL.appendingPathComponent("/api/data")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { _, response, error in
            handleResponse(data: nil, response: response, error: error, completion: { result in
                if case .failure(let error) = result {
                    completion(error)
                } else {
                    completion(nil)
                }
            })
        }.resume()
    }

    private static func handleResponse(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<Data, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            let unknownError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
            completion(.failure(unknownError))
            return
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let statusCodeError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)])
            completion(.failure(statusCodeError))
            return
        }

        if let data = data {
            completion(.success(data))
        } else {
            let unknownError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
            completion(.failure(unknownError))
        }
    }
}
