//
//  Routes.swift
//  APIapp
//
//  Created by FRANCISCO AQUINO on 05/04/24.
//

import Foundation

// Handles requests to the server routes
struct Routes {
    // Instance of UserService
    private let userService = UserService()
    
    // Handles a generic request to the server
    func handleRequest(_ request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: request, completionHandler: completion).resume()
    }
    
    // Gets all users from the server
    func getAllUsers(completion: @escaping ([User]?, Error?) -> Void) {
        let url = URL(string: "http://localhost:3005/users")!
        let request = URLRequest(url: url)
        
        // Makes a request to fetch all users
        handleRequest(request) { data, _, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "Routes", code: 1, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                return
            }
            
            // Parses the response data to get the users
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                completion(users, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    // Gets a user by ID from the server
    func getUser(id: Int, completion: @escaping (User?, Error?) -> Void) {
        let url = URL(string: "http://localhost:3005/users/\(id)")!
        let request = URLRequest(url: url)
        
        // Makes a request to fetch a user by ID
        handleRequest(request) { data, _, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "Routes", code: 1, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                return
            }
            
            // Parses the response data to get the user
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(user, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    // Adds a new user to the server
    func addUser(user: User, completion: @escaping (Error?) -> Void) {
        var request = URLRequest(url: URL(string: "http://localhost:3005/users/add")!)
        request.httpMethod = "POST"
        
        // Encodes user data and sets the request body
        do {
            let userData = try JSONEncoder().encode(user)
            request.httpBody = userData
        } catch {
            completion(error)
            return
        }
        
        // Makes a request to add a new user
        handleRequest(request) { data, _, error in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    // Updates an existing user on the server
    func updateUser(id: Int, updatedUser: User, completion: @escaping (Error?) -> Void) {
        var request = URLRequest(url: URL(string: "http://localhost:3005/users/update/\(id)")!)
        request.httpMethod = "PUT"
        
        // Encodes updated user data and sets the request body
        do {
            let updatedUserData = try JSONEncoder().encode(updatedUser)
            request.httpBody = updatedUserData
        } catch {
            completion(error)
            return
        }
        
        // Makes a request to update an existing user
        handleRequest(request) { data, _, error in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    // Deletes a user from the server by ID
    func deleteUser(id: Int, completion: @escaping (Error?) -> Void) {
        var request = URLRequest(url: URL(string: "http://localhost:3005/users/delete/\(id)")!)
        request.httpMethod = "DELETE"
        
        // Makes a request to delete a user by ID
        handleRequest(request) { data, _, error in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
}
