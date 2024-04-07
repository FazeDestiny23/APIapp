//
//  UserService.swift
//  APIapp
//
//  Created by FRANCISCO AQUINO on 05/04/24.
//

import Foundation

struct UserService {
    // Base URL for the user service
    private let baseURL = URL(string: "http://localhost:3005/users")!
    
    // Function to get all users from the server
    func getAllUsers(completion: @escaping ([User]?, Error?) -> Void) {
        let url = baseURL
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                // Invokes completion handler with error if there's an error during the network request
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                // Invokes completion handler with error if no data is received
                completion(nil, NSError(domain: "UserService", code: 1, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                return
            }
            
            do {
                // Decodes JSON data into an array of users
                let users = try JSONDecoder().decode([User].self, from: data)
                completion(users, nil)
            } catch {
                // Invokes completion handler with error if decoding fails
                completion(nil, error)
            }
        // Resumes the data task to initiate the network request
        }.resume()
    }

    // Function to get a user by ID from the server
    func getUser(id: Int, completion: @escaping (User?, Error?) -> Void) {
        let url = baseURL.appendingPathComponent(String(id))
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: url) { data, response, error in
        // Process the response similar to getAllUsers
        // Resumes the data task to initiate the network request
        }.resume()
    }

    // Function to add a new user to the server
    func addUser(user: User, completion: @escaping (Error?) -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        
        guard let jsonData = try? JSONEncoder().encode(user) else {
            // Invokes completion handler with error if encoding fails
            completion(NSError(domain: "UserService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Error encoding user data"]))
            return
        }
        
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
        // Process the response similar to getAllUsers
        // Resumes the data task to initiate the network request
        }.resume()
    }

    // Function to update an existing user on the server
    func updateUser(id: Int, updatedUser: User, completion: @escaping (Error?) -> Void) {
        let url = baseURL.appendingPathComponent(String(id))
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        guard let jsonData = try? JSONEncoder().encode(updatedUser) else {
            // Invokes completion handler with error if encoding fails
            completion(NSError(domain: "UserService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Error encoding user data"]))
            return
        }
        
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
        // Process the response similar to getAllUsers
        // Resumes the data task to initiate the network request
        }.resume()
    }

    // Function to delete an existing user from the server
    func deleteUser(id: Int, completion: @escaping (Error?) -> Void) {
        let url = baseURL.appendingPathComponent(String(id))
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
        // Process the response similar to getAllUsers
        // Resumes the data task to initiate the network request
        }.resume()
    }
}
