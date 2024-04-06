//
//  UserService.swift
//  APIapp
//
//  Created by FRANCISCO AQUINO on 05/04/24.
//

import Foundation

struct UserService {
    private let baseURL = URL(string: "http://localhost:3005/users")!
    
    // Función para obtener todos los usuarios
    func getAllUsers(completion: @escaping ([User]?, Error?) -> Void) {
        let url = baseURL
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "UserService", code: 1, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                return
            }
            
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                completion(users, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }

    // Función para obtener un usuario por su ID
    func getUser(id: Int, completion: @escaping (User?, Error?) -> Void) {
        let url = baseURL.appendingPathComponent(String(id))
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Procesar la respuesta similar a getAllUsers
        }.resume()
    }

    // Función para agregar un nuevo usuario
    func addUser(user: User, completion: @escaping (Error?) -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        
        guard let jsonData = try? JSONEncoder().encode(user) else {
            completion(NSError(domain: "UserService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Error encoding user data"]))
            return
        }
        
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Procesar la respuesta similar a getAllUsers
        }.resume()
    }

    // Función para actualizar un usuario existente
    func updateUser(id: Int, updatedUser: User, completion: @escaping (Error?) -> Void) {
        let url = baseURL.appendingPathComponent(String(id))
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        guard let jsonData = try? JSONEncoder().encode(updatedUser) else {
            completion(NSError(domain: "UserService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Error encoding user data"]))
            return
        }
        
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Procesar la respuesta similar a getAllUsers
        }.resume()
    }

    // Función para eliminar un usuario existente
    func deleteUser(id: Int, completion: @escaping (Error?) -> Void) {
        let url = baseURL.appendingPathComponent(String(id))
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Procesar la respuesta similar a getAllUsers
        }.resume()
    }
}
