////
////  FirstOpenTabBar.swift
////  BlindTiger
////
////  Created by dante  delgado on 7/29/22.
////
//
//
//  TabBarView.swift
//  BlindTigerRedesign
//
//  Created by dante  delgado on 3/25/22.
//

import SwiftUI

struct FirstOpenTabBar: View {
    @State var selectedTab = 0
    @ObservedObject var info : AppDelegate

    

    
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
            }.fullScreenCover(isPresented: $info.showSheet) {SignInView(info: info)}
    }
    
}

