//
//  TabBarView.swift
//  BlindTigerRedesign
//
//  Created by dante  delgado on 3/25/22.
//

import SwiftUI

struct TabBarView: View {
    @State var selectedTab = 0
    init() {
            UITabBar.appearance().backgroundColor = UIColor.systemGray6
        }
    
    var body: some View {
  
            // Fallback on earlier versions
            TabView(selection: $selectedTab) {
                    NavigationView {
                        HomeView()
                    }.accentColor(.black)
                        .tabItem({Image(systemName: "house.fill")})
                        .tag(0)
                NavigationView {
                    PeekHomeView()
                }.accentColor(.black)
                    .tabItem({Image(systemName: "binoculars")})
                    .tag(1)
                NavigationView {
                    BulletinView()
                }.accentColor(.black)
                    .tabItem({Image(systemName: "newspaper")})
                    .tag(2)
                NavigationView {
                    RatingsView()
                }.accentColor(.black)
                    .tabItem({Image(systemName: "star")})
                    .tag(3)
                    NavigationView {
                        SelfProfileView()
                    }.accentColor(.black)
                        .tabItem({Image(systemName: "person")})
                        .tag(4)
            }
     
    }
    
}

