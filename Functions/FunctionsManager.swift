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
        
        // Performs a data task to fetch users from the server
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Checks for any errors during the network request
            if let error = error {
                print("Error fetching users: \(error)")
                completion(nil)
                return
            }
            
            // Checks if data was received from the server
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                // Attempts to decode the JSON data into UserResponse object
                let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                // Extracts the array of users from the response and pass it to the completion handler
                completion(userResponse.users.data.rows)
            } catch {
                // Handles any decoding errors and pass nil to the completion handler
                print("Error decoding users: \(error)")
                completion(nil)
            }
        // Resumes the data task to initiate the network request
        }.resume()
    }
    
    
    // Searches for a user by ID on the server
    func searchUserByID(userID: Int, completion: @escaping (User?) -> Void) {
        // Constructs the URL to search for a user by ID
        guard let url = URL(string: "http://localhost:3005/users/\(userID)") else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        // Creates a GET request with the specified URL
        let request = URLRequest(url: url)
        
        // Performs the GET request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handles the response of the request
            if let error = error {
                print("Error searching user by ID: \(error)")
                completion(nil)
                return
            }
            
            // Checks if any data was received from the server
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                // Tries to decode the received JSON into an array of User objects
                let users = try JSONDecoder().decode([User].self, from: data)
                // If the array has at least one user, return the first one (assuming it's unique)
                if let user = users.first {
                    completion(user)
                } else {
                    print("User not found")
                    completion(nil)
                }
            } catch {
                // Handles any decoding error
                print("Error decoding user: \(error)")
                completion(nil)
            }
        // Resumes the data task to initiate the network request
        }.resume()
    }

    
    // Adds a new user to the server
    func addUser(user: User) {
        // Encodes the user object to JSON data
        guard let jsonData = try? JSONEncoder().encode(user) else {
            print("Error encoding user data")
            return
        }
        
        // Defines the URL for adding a new user
        guard let url = URL(string: "http://localhost:3005/users/add") else {
            print("Invalid URL")
            return
        }
        
        // Creates a POST request with the JSON data
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // Performs the POST request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Checks for any errors during the network request
            if let error = error {
                print("Error adding user: \(error)")
                return
            }
            
            // Checks the HTTP response for success or failure
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    print("User added successfully")
                } else {
                    print("Error adding user. Status code: \(response.statusCode)")
                }
            }
        // Resumes the data task to initiate the network request
        }.resume()
    }

    
    // Deletes a user from the server by ID
    func deleteUserByID(userID: Int, completion: @escaping (Error?) -> Void) {
        // Constructs the URL for deleting a user by ID
        guard let url = URL(string: "http://localhost:3005/users/delete/\(userID)") else {
            // If the URL is invalid, invoke the completion handler with an invalid URL error
            completion(NetworkError.invalidURL)
            return
        }
        
        // Creates a DELETE request with the specified URL
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        // Performs the DELETE request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Checks for any errors during the network request
            if let error = error {
                // If there's an error, invoke the completion handler with the error
                completion(error)
                return
            }
            
            // Checks the HTTP response for success or failure
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                // If the response status code is 200 (OK), invoke the completion handler with nil
                completion(nil)
            } else {
                // If the response status code is not 200, invoke the completion handler with an invalid response error
                completion(NetworkError.invalidResponse)
            }
        // Resumes the data task to initiate the network request
        }.resume()
    }

}
