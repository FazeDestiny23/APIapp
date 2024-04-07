//
//  FunctionsManager.swift
//  APIapp
//
//  Created by FRANCISCO AQUINO on 06/04/24.
//

import Foundation

// Class responsible for managing network operations
class NetworkManager {
    // Singleton instance
    static let shared = NetworkManager()
    
    // Enum to represent network errors
    enum NetworkError: Error {
        case invalidURL
        case invalidResponse
    }
    // Private initializer for singleton
    private init() {}
    
    // Retrieves all users from the server
    func getUsers(completion: @escaping ([User]?) -> Void) {
        // Construct the URL for fetching users
        guard let url = URL(string: "http://localhost:3005/users") else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        // Perform a data task to fetch users from the server
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for any errors during the network request
            if let error = error {
                print("Error fetching users: \(error)")
                completion(nil)
                return
            }
            
            // Check if data was received from the server
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                // Attempt to decode the JSON data into UserResponse object
                let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                // Extract the array of users from the response and pass it to the completion handler
                completion(userResponse.users.data.rows)
            } catch {
                // Handle any decoding errors and pass nil to the completion handler
                print("Error decoding users: \(error)")
                completion(nil)
            }
        // Resume the data task to initiate the network request
        }.resume()
    }

    
    // Search for a user by ID
    func searchUserByID(userID: Int, completion: @escaping (User?) -> Void) {
        guard let url = URL(string: "http://localhost:3005/users/\(userID)") else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching user: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                if let user = users.first {
                    completion(user)
                } else {
                    completion(nil)
                }
            } catch {
                print("Error decoding user: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    /// Adds a new user to the server.
    func addUser(user: User) {
        guard let jsonData = try? JSONEncoder().encode(user) else {
            print("Error encoding user data")
            return
        }
        
        guard let url = URL(string: "http://localhost:3005/users/add") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error adding user: \(error)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    print("User added successfully")
                } else {
                    print("Error adding user. Status code: \(response.statusCode)")
                }
            }
        }.resume()
    }
    
    /// Deletes a user from the server by ID.
    func deleteUserByID(userID: Int, completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: "http://localhost:3005/users/delete/\(userID)") else {
            completion(NetworkError.invalidURL)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                completion(nil)
            } else {
                completion(NetworkError.invalidResponse)
            }
        }.resume()
    }
}
