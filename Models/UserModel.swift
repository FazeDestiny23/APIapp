//
//  UserModel.swift
//  APIapp
//
//  Created by FRANCISCO AQUINO on 05/04/24.
//

import Foundation

struct UserResponse: Decodable {
    let users: UserData
}

struct UserData: Decodable {
    let data: UsersData
    let err: String? 
}

struct UsersData: Decodable {
    let rows: [User]
}

struct User: Decodable, Encodable {
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
