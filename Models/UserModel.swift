//
//  UserModel.swift
//  APIapp
//
//  Created by FRANCISCO AQUINO on 05/04/24.
//

import Foundation

struct User: Decodable, Encodable {
    var id: Int?
    var username: String?
    var email: String?
    var gender: String?
    var location: String?
    var birthDate: Date?
    var weight: Double?
    var height: Double?
    var emergencyContact: String?
}
