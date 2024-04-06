//
//  Routes.swift
//  APIapp
//
//  Created by FRANCISCO AQUINO on 05/04/24.
//

import Foundation

struct Routes {
    private let userService = UserService()
    
    func handleRequest(_ request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: request, completionHandler: completion).resume()
    }
    
    func getAllUsers(completion: @escaping ([User]?, Error?) -> Void) {
        let url = URL(string: "http://localhost:3005/users")!
        let request = URLRequest(url: url)
        
        handleRequest(request) { data, _, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "Routes", code: 1, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                return
            }
            
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                completion(users, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    func getUser(id: Int, completion: @escaping (User?, Error?) -> Void) {
        let url = URL(string: "http://localhost:3005/users/\(id)")!
        let request = URLRequest(url: url)
        
        handleRequest(request) { data, _, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "Routes", code: 1, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                return
            }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(user, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    func addUser(user: User, completion: @escaping (Error?) -> Void) {
        var request = URLRequest(url: URL(string: "http://localhost:3005/users/add")!)
        request.httpMethod = "POST"
        
        do {
            let userData = try JSONEncoder().encode(user)
            request.httpBody = userData
        } catch {
            completion(error)
            return
        }
        
        handleRequest(request) { data, _, error in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    func updateUser(id: Int, updatedUser: User, completion: @escaping (Error?) -> Void) {
        var request = URLRequest(url: URL(string: "http://localhost:3005/users/update/\(id)")!)
        request.httpMethod = "PUT"
        
        do {
            let updatedUserData = try JSONEncoder().encode(updatedUser)
            request.httpBody = updatedUserData
        } catch {
            completion(error)
            return
        }
        
        handleRequest(request) { data, _, error in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    func deleteUser(id: Int, completion: @escaping (Error?) -> Void) {
        var request = URLRequest(url: URL(string: "http://localhost:3005/users/delete/\(id)")!)
        request.httpMethod = "DELETE"
        
        handleRequest(request) { data, _, error in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
}
