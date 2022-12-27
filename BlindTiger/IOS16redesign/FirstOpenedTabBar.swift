//
//  FirstOpenedTabBar.swift
//  BlindTiger
//
//  Created by dante  delgado on 7/29/22.
//

import SwiftUI

struct FirstOpenedTabBar: View {
    @State var selectedTab: Int

    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
                HomeView().accentColor(.black)
                .tabItem({Image(systemName: "house.fill").foregroundColor(.orange)})
                .tag(0)
                PeekHomeView()
                .tabItem({Image(systemName: "binoculars")})
                .tag(1)
                BulletinView()
                .tabItem({Image(systemName: "newspaper")})
                .tag(2)
                RatingsView()
                .tabItem({Image(systemName: "star")})
                .tag(3)
                SelfProfileView()
                .tabItem({Image(systemName: "person")})
                .tag(4)
        }

     
    }
}

