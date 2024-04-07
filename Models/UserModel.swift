//
//  UserModel.swift
//  APIapp
//
//  Created by FRANCISCO AQUINO on 05/04/24.
//

import Foundation

// Structure to represent the server response
struct UserResponse: Decodable {
    let users: UserData
}

// Structure to represent user data
struct UserData: Decodable {
    let data: UsersData
    // Error message
    let err: String?
}

// Structure to represent users data
struct UsersData: Decodable {
    // Array of users
    let rows: [User]
}

// Structure to represent a user
struct User: Decodable, Encodable {
    // Variables for user fields matching DataBase
    var ID: Int
    var Username: String
    var Email: String
    var Gender: String
    var Location: String
    var BirthDate: String
    var Weight: Int
    var Height: Int
    var EmergencyContact: String
}
