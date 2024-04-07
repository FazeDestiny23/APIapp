//
//  AddUserView.swift
//  APIapp
//
//  Created by FRANCISCO AQUINO on 06/04/24.
//

import SwiftUI

// Text input field with a title and binding text value
struct UserInputField: View {
    let title: String
    @Binding var text: String
    
    var body: some View {
        TextField(title, text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
    }
}

// View for adding a new user with input fields for user information
struct AddUserView: View {
    // State variables for user input fields
    @State private var id = ""
    @State private var username = ""
    @State private var email = ""
    @State private var gender = ""
    @State private var location = ""
    @State private var birthDate = ""
    @State private var weight = ""
    @State private var height = ""
    @State private var emergencyContact = ""
    @State private var errorMessage = ""
    
    var body: some View {
        VStack {
            // TextFields for user input
            UserInputField(title: "ID", text: $id)
            UserInputField(title: "Username", text: $username)
            UserInputField(title: "Email", text: $email)
            UserInputField(title: "Gender", text: $gender)
            UserInputField(title: "Location", text: $location)
            UserInputField(title: "Birth Date", text: $birthDate)
            UserInputField(title: "Weight", text: $weight)
            UserInputField(title: "Height", text: $height)
            UserInputField(title: "Emergency Contact", text: $emergencyContact)
            
            // Save button
            Button("Save") {
                addUser()
            }
            .padding()
            
            // Error message display
            Text(errorMessage)
                .foregroundColor(.red)
                .padding()
            
            Spacer()
        }
        .padding()
    }
    
    // Function to add a new user
    private func addUser() {
        // Validate input fields
        guard !id.isEmpty ,!username.isEmpty, !email.isEmpty, !gender.isEmpty, !location.isEmpty, !birthDate.isEmpty, !weight.isEmpty, !height.isEmpty, !emergencyContact.isEmpty else {
            errorMessage = "All fields are required"
            return
        }
        
        // Convert weight and height to integers
        guard let weightInt = Int(weight), let heightInt = Int(height) else {
            errorMessage = "Invalid weight or height"
            return
        }
        
        // Create a dictionary with user data
        let userData: [String: Any] = [
            "id": id,
            "username": username,
            "email": email,
            "gender": gender,
            "location": location,
            "birthDate": birthDate,
            "weight": weightInt,
            "height": heightInt,
            "emergencyContact": emergencyContact
        ]
        
        // Convert the dictionary to JSON data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: userData) else {
            errorMessage = "Failed to serialize user data"
            return
        }
        
        // Make API request to add the user
        guard let url = URL(string: "http://localhost:3005/users/add") else {
            errorMessage = "Invalid URL"
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                errorMessage = "Error adding user: \(error.localizedDescription)"
            } else {
                // Handle successful response if needed
                errorMessage = "User added successfully"
                // Clear input fields after successful addition
                DispatchQueue.main.async {
                    clearInputFields()
                }
            }
        }.resume()
    }
    
    // Function to clear input fields
    private func clearInputFields() {
        id = ""
        username = ""
        email = ""
        gender = ""
        location = ""
        birthDate = ""
        weight = ""
        height = ""
        emergencyContact = ""
    }
}

// Preview provider
struct AddUserView_Previews: PreviewProvider {
    static var previews: some View {
        AddUserView()
    }
}
