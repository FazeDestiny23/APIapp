//
//  Configure.swift
//  APIapp
//
//  Created by FRANCISCO AQUINO on 05/04/24.
//

import Foundation

// API client for interacting with the backend server
struct APIClient {
    // Base URL for API endpoints
    static let baseURL = URL(string: "http://localhost:3005/users")!

    // Gets data from the server
    static func getData(completion: @escaping (Result<Data, Error>) -> Void) {
        // Constructs the URL for fetching data
        let url = baseURL.appendingPathComponent("/api/data")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Performs a GET request to fetch data
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handles the response from the server
            handleResponse(data: data, response: response, error: error, completion: completion)
        }.resume()
    }

    // Adds new data to the server
    static func addData(newData: Data, completion: @escaping (Error?) -> Void) {
        // Constructs the URL for adding data
        let url = baseURL.appendingPathComponent("/api/data")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = newData

        // Performs a POST request to add data
        URLSession.shared.dataTask(with: request) { _, response, error in
            // Handles the response from the server
            handleResponse(data: nil, response: response, error: error) { result in
                if case .failure(let error) = result {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        }.resume()
    }

    // Updates existing data on the server
    static func updateData(updatedData: Data, completion: @escaping (Error?) -> Void) {
        // Constructs the URL for updating data
        let url = baseURL.appendingPathComponent("/api/data")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = updatedData

        // Performs a PUT request to update data
        URLSession.shared.dataTask(with: request) { _, response, error in
            // Handles the response from the server
            handleResponse(data: nil, response: response, error: error) { result in
                if case .failure(let error) = result {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        }.resume()
    }

    // Deletes data from the server
    static func deleteData(completion: @escaping (Error?) -> Void) {
        // Constructs the URL for deleting data
        let url = baseURL.appendingPathComponent("/api/data")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        // Performs a DELETE request to delete data
        URLSession.shared.dataTask(with: request) { _, response, error in
            // Handles the response from the server
            handleResponse(data: nil, response: response, error: error) { result in
                if case .failure(let error) = result {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        }.resume()
    }

    // Handles the response from the server
    private static func handleResponse(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<Data, Error>) -> Void) {
        if let error = error {
            // If there's an error, invoke the completion handler with the error
            completion(.failure(error))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            // If the response is not an HTTPURLResponse, return an unknown error
            let unknownError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
            completion(.failure(unknownError))
            return
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            // If the status code indicates an error, return the appropriate error
            let statusCodeError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)])
            completion(.failure(statusCodeError))
            return
        }

        if let data = data {
            // If there's data, invoke the completion handler with the data
            completion(.success(data))
        } else {
            // If there's no data, return an unknown error
            let unknownError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
            completion(.failure(unknownError))
        }
    }
}
