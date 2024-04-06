//
//  ContentView.swift
//  APIapp
//
//  Created by FRANCISCO AQUINO on 05/04/24.
//

import SwiftUI

struct ContentView: View {
    @State private var users: [User] = []
    let networkManager = NetworkManager.shared
    
    var body: some View {
        VStack {
            List(users, id: \.id) { user in
                Text(user.username)
            }
            
            Button("Load Users") {
                networkManager.getAllUsers { users, error in
                    if let users = users {
                        self.users = users
                    } else if let error = error {
                        print("Error fetching users: \(error)")
                    }
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
