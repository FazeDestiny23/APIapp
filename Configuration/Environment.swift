//
//  Config.swift
//  APIapp
//
//  Created by FRANCISCO AQUINO on 05/04/24.
//

import Foundation

// Environment configuration for the backend server
struct Environment {
    // Port number for the server
    static let port: Int = 3005
    // Database user
    static let dbUser: String = "api_user"
    // Database host
    static let dbHost: String = "localhost"
    // Database name
    static let db: String = "Backend"
    // Database password
    static let dbPassword: String = "1234"
}
