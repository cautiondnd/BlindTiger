//
//  SignUp.swift
//  BlindTigerRedesign
//
//  Created by dante  delgado on 3/24/22.
//

import SwiftUI

struct SignUp: View {
    @State var goTabView = false
    var body: some View {
            
//            Button {
//                goTabView = true
//            } label: {
//                Text("Register")
//            }

        NavigationLink(destination: TabBar(selectedTab: 0).navigationBarBackButtonHidden(true)) {
                    Text("Go")
                    }
            
//
        
        .navigationTitle(Text("Sign Up"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

