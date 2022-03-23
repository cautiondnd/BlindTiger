//
//  NotificationView.swift
//  BlindTiger
//
//  Created by dante  delgado on 11/15/20.
//

import SwiftUI
import Firebase

struct NotificationView: View {
    @ObservedObject var notificationData = NotificationViewModel()
    @State var showingTodayTab = true
    @State var goComment = false
    @State var selectedUserPost: post = post(id: "", content: "Post was deleted.", votes: 0, time: Timestamp.init() , authoruid: "", anonymous: false, authorusername: "", reports: 0)
    @Binding var blockedUsers: [String]
    

    var body: some View {
        let oneDayOldNewComments = notificationData.newCommentsOnPost.filter { notificationPost in
            return Date().timeIntervalSince(notificationPost.time.dateValue()) < 86400
          }
        let oneWeekOldNewComments = notificationData.newCommentsOnPost.filter { notificationPost in
            return Date().timeIntervalSince(notificationPost.time.dateValue()) > 86400  && Date().timeIntervalSince(notificationPost.time.dateValue()) < 604800
          }
        let OlderNewComments = notificationData.newCommentsOnPost.filter { notificationPost in
            return Date().timeIntervalSince(notificationPost.time.dateValue()) > 604800
          }


        NavigationView{
            if notificationData.newCommentsOnPost.isEmpty{
               
                
                VStack{
                    if notificationData.initialLoading == true {
                        VStack{
                            Spacer()
                        ActivityIndicator(shouldAnimate: $notificationData.initialLoading)
                            Spacer()
                        }
                    }
                    else{
                        VStack{
                    Image(systemName: "tray")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(.customOrange)

                   Text("No Activity").font(.body).fontWeight(.medium).padding(.top)
                    Text("Comments left on your post will show up here. Make a post to get started.").multilineTextAlignment(.center
                    ).padding(.horizontal)
                    }
                        }
                }
                
                .navigationBarTitle(Text("Activity"), displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .toolbar{
                    ToolbarItem(placement: .principal) {
                        Text("Activity")
                            .font(.headline)
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                   }
                }.navigationBarColor(UIColor(Color.customOrange))

                .background(Color.customGray.ignoresSafeArea(.all))

                
            }
            else{
                RefreshableScrollView(height: 70, refreshing: self.$notificationData.loading) {
                    ScrollView{

                        NotificationListView(oneDayOldNewComments: oneDayOldNewComments, oneWeekOldNewComments: oneWeekOldNewComments, OlderNewComments: OlderNewComments, userPosts: notificationData.userPosts, blockedUsers: $blockedUsers)



                }

                }







                .navigationBarTitle(Text("Activity"), displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .toolbar{
                    ToolbarItem(placement: .principal) {
                        Text("Activity")
                            .font(.headline)
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                    }
                }.navigationBarColor(UIColor(Color.customOrange))

                .background( Color.customGray.ignoresSafeArea(.all) )

            

        }
        }.navigationBarHidden(true)
        .onAppear() {notificationData.fetchNotificationData()}
        .navigationBarColor(UIColor(Color.customOrange))

    }


}

