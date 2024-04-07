//
//  ContentView.swift
//  APIapp
//
//  Created by FRANCISCO AQUINO on 05/04/24.
//

import SwiftUI

// View for displaying and managing user data
struct ContentView: View {
    // State variables
    @State private var users: [User] = []
    @State private var userIDInput: String = ""
    @State private var user: User?
    
    var body: some View {
        VStack {
            // Get all users button
            Button("Get All Users") {
                GetAllUsers()
            }
            .padding()
            
            // List of users
            List(users, id: \.ID) { user in
                VStack(alignment: .leading) {
                    // Displays user information
                    Text("ID: \(user.ID)")
                    Text("Username: \(user.Username)")
                    Text("Email: \(user.Email)")
                    Text("Gender: \(user.Gender)")
                    Text("Location: \(user.Location)")
                    Text("BirthDate: \(user.BirthDate)")
                    Text("Weight: \(user.Weight)")
                    Text("Height: \(user.Height)")
                    Text("EmergencyContact: \(user.EmergencyContact)")
                }
            }
            .padding()
            
            // Text field for entering user ID
            TextField("Enter User ID", text: $userIDInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Buttons for searching and deleting user by ID
            HStack {
                Button("Search User By ID") {
                    if let userID = Int(userIDInput) {
                        searchUserByID(userID: userID)
                    } else {
                        print("Invalid User ID")
                    }
                }
                .padding()
                
                Button("Delete User By ID") {
                    if let userID = Int(userIDInput) {
                        deleteUserByID(userID: userID)
                    } else {
                        print("Invalid User ID")
                    }
                }
                .padding()
            }
            
            // Displays found user information
            if let user = user {
                Text("User Found:")
                Text("ID: \(user.ID)")
                Text("Username: \(user.Username)")
                Text("Email: \(user.Email)")
                Text("Gender: \(user.Gender)")
                Text("Location: \(user.Location)")
                Text("BirthDate: \(user.BirthDate)")
                Text("Weight: \(user.Weight)")
                Text("Height: \(user.Height)")
                Text("EmergencyContact: \(user.EmergencyContact)")
            }
        }
        .padding()
    }
    
    // Gets all users function
    func GetAllUsers() {
        NetworkManager.shared.getUsers { users in
            if let users = users {
                DispatchQueue.main.async {
                    self.users = users
                }
            }
        }
    }
    
    // Searchs user by ID function
    func searchUserByID(userID: Int) {
        NetworkManager.shared.searchUserByID(userID: userID) { user in
            if let user = user {
                DispatchQueue.main.async {
                    self.user = user
                }
            }
        }
    }
    
    // Deletes user by ID function
    func deleteUserByID(userID: Int) {
        NetworkManager.shared.deleteUserByID(userID: userID) { error in
            if let error = error {
                print("Error deleting user: \(error)")
            } else {
                print("User deleted successfully")
                // Remove the user from the local array
                DispatchQueue.main.async {
                    self.users.removeAll { $0.ID == userID }
                }
            }
        }
    }
}

// Preview provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
