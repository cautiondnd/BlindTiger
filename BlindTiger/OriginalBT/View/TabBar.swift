////
////  TabBar.swift
////  BlindTiger
////
////  Created by dante  delgado on 11/15/20.
////
//
//import SwiftUI
//import Firebase
//
//struct TabBar: View {
//    @State var selectedTab: Int
//   // @ObservedObject var homeData = homeViewModel()
//    // every view has a binding to this comunal blocked users array
//    @State var blockedUsers: [String] = UserDefaults.standard.stringArray(forKey: "blockedUsers") ?? []
//    @State var peekBlockedUsers: [String] = UserDefaults.standard.stringArray(forKey: "peekBlockedUsers") ?? []
//
//
//    
//    var body: some View {
//
//        TabView(selection: $selectedTab) {
//            HomeTab(blockedUsers: $blockedUsers)
//               
//                .tabItem({if selectedTab == 0 {Image(systemName: "house.fill")}
//                         else{Image(systemName: "house")}})
//                .tag(0)
//                
//           // SearchView()
//            SearchTab(peekBlockedUsers: $peekBlockedUsers)
//                                .tabItem({if selectedTab == 1 {Image(systemName: "binoculars.fill").foregroundColor(.orange)}
//                                               else{Image(systemName: "binoculars")}})
//                                       .tag(1)
//
//
//            NewPost(selectedTab: $selectedTab)
//                //popover is what i need to use not sheet if i want to make it a pop up 
//                .tabItem({Image(systemName: "plus.circle")})
//                .tag(2)
//           
//            NotificationTab(blockedUsers: $blockedUsers)
//                .tabItem({if selectedTab == 3 {Image(systemName: "bell.fill").foregroundColor(.orange)}
//                         else{Image(systemName: "bell")}})
//                .tag(3)
//            ProfileTab(blockedUsers: $blockedUsers)
//                .tabItem({if selectedTab == 4 {Image(systemName: "person.fill").foregroundColor(.orange)}
//                         else{Image(systemName: "person")}})
//                .tag(4)
//        }.accentColor(.orange)
//        
//    }
//}
//        
//struct HomeTab: View {
//    @Binding var blockedUsers: [String]
//    var body: some View {
//        NavigationView{
//            Home(blockedUsers: $blockedUsers)
//        }.navigationBarHidden(true)
//    }}
//
//struct SearchTab: View {
//    @Binding var peekBlockedUsers: [String]
//    var body: some View {
//        SearchView(peekBlockedUsers: $peekBlockedUsers)}}
//
//
//
//struct ProfileTab: View {
//    @Binding var blockedUsers: [String]
//    var body: some View {
//        ProfileView(userID: Auth.auth().currentUser!.uid, blockedUsers: $blockedUsers)}}
//
//struct NotificationTab: View {
//    @Binding var blockedUsers: [String]
//    var body: some View {
//        NotificationView(blockedUsers: $blockedUsers)}}
//
//        /*
//        HStack{
//            TabButton(title: "house", selectedTab: $selectedTab)
//            TabButton(title: "binoculars", selectedTab: $selectedTab)
//            TabButton(title: "plus.circle", selectedTab: $selectedTab)
//            TabButton(title: "bell", selectedTab: $selectedTab)
//            TabButton(title: "person", selectedTab: $selectedTab)
//        }
//        
//        TabView(selection: $selectedTab) {
//            Home(info: AppDelegate()).tag(0)
//            SearchView().tag(1)
//            NotificationView().tag(3)
//            ProfileView().tag(4)
//        }
//        
//
//        HStack{
//            Button(
//                action: {
//                    index = 0
//                },
//                label: {
//                    if index == 0 {
//                        Image(systemName: "house.fill")
//                            .foregroundColor(.orange)
//                    }
//                    else{
//                   Image(systemName: "house")
//                    }
//                })
//            Spacer()
//            Button(
//                action: {
//                    index = 1
//                },
//                label: {
//                    if index == 1 {
//                        Image(systemName: "binoculars.fill")
//                            .foregroundColor(.orange)
//                    }
//                    else{
//                   Image(systemName: "binoculars")
//                    }
//                })
//            Spacer()
//            Button(
//                action: {
//                    index = 2
//                },
//                label: {
//                   Image(systemName: "plus.circle")
//                })
//            Spacer()
//            Button(
//                action: {
//                    index = 3
//
//                },
//                label: {
//                    if index == 3 {
//                        Image(systemName: "bell.fill")
//                            .foregroundColor(.orange)
//                    }
//                    else{
//                   Image(systemName: "bell")
//                    }
//                })
//            Spacer()
//            Button(
//                action: {
//                    index = 4
//
//                },
//                label: {
//                    if index == 4 {
//                        Image(systemName: "person.fill")
//                            .foregroundColor(.orange)
//                    }
//                    else{
//                   Image(systemName: "person")
//                    }
//                })
//            
//        }.padding()
//
//    }
//}
//
//
//struct TabButton : View {
//    
//    var title : String
//    @Binding var selectedTab : String
//    
//    var body: some View{
//        
//        Button(action: {selectedTab = title}) {
//            if selectedTab == title {
//                Image("\(title).fill")
//            }
//            else{
//        Image(title)
//            }
//        }
//    }
//}
//
//
//
//
//
// */
//
//
//
//
///*
//
//
//
//struct TabBar_Previews: PreviewProvider {
//    static var previews: some View {
//        TabBar()
//    }
//}
//*/
