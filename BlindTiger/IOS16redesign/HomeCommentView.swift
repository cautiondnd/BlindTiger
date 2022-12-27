//
//  HomeCommentView.swift
//  BlindTigerRedesign
//
//  Created by dante  delgado on 3/26/22.
//

import SwiftUI

struct HomeCommentView: View {
    var body: some View {
        
        Text("Comments")
        NavigationLink(destination: SelfProfileView()) {
            Text("profile")
        }
                
        .navigationTitle(Text("Comments"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

