//
//  HomeView.swift
//  BlindTigerRedesign
//
//  Created by dante  delgado on 3/25/22.
//

import SwiftUI
import Firebase
import GoogleMobileAds

struct HomeView: View {
    @ObservedObject var homeData = HomeModel()
    @State var showPostSheet = false
    
    let nativeAdView = nativeAdViewDisplay()
   


        var body: some View {
            VStack(spacing: 0){
         
                    
                    if homeData.initialRecentsLoading == true {
                       fullScreenProgessView()
                    }
                    else {
                        if homeData.recentPosts.isEmpty {
                            emptyFeed(title: "No Posts Yet", subTitle: "It seems no one has posted to your school's BlindTiger yet. Be the first!")
                        }
                        else{
                            TabView(selection: $homeData.filterTab) {
                                recentFeed.tag(0)
                                likedFeed.tag(1).onAppear(){homeData.fetchLikedData()}
                            }.tabViewStyle(.page(indexDisplayMode: .never))
                            
                        }
                    }
                }
            .onAppear() {homeData.fetchRecentData()}
                .background(Color.customGray)
                .sheet(isPresented: $showPostSheet) {NewHomePost(homeData: homeData, showing: $showPostSheet).onDisappear() {homeData.refreshRecentData()}}
                //custom navigation bar is all within this toolbar
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {newPostButton.padding([.vertical, .leading])}
                    ToolbarItem(placement: .principal) {homeNavBar}
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarColor(UIColor(Color.customOrange))
                



            
        
        
        
        
       
    }

    //shows recent posts and an ad every 7th post
    var recentFeed: some View {
        RefreshableScrollView(height: 70, refreshing: $homeData.refreshing){
            let blockedUsers: [String] = UserDefaults.standard.stringArray(forKey: "blockedUsers") ?? [String]()
            
            Spacer(minLength: 5)
            
            VStack(spacing: 10){
                ForEach(Array(homeData.recentPosts.enumerated()), id: \.element) {index, post in
                    
                    if !blockedUsers.contains(post.authoruid) {
                        
                        cardView(postData: post, votes: post.votes, upvote: UserDefaults.standard.bool(forKey: "\(post.id)upvoted"), downvote: UserDefaults.standard.bool(forKey: "\(post.id)downvoted"), reported: UserDefaults.standard.bool(forKey: "\(post.id)reported"))
                        
                        if index.isMultiple(of: 7) && index != 0 {
                            
                            nativeAdView
                            
                        }
                        
                    }
                    
                   

                   
                }
            }
            if homeData.noMoreRecents == false {loadMoreRecentsButton}
        }
    }
    
    //shows liked posts and an ad every 7th post h
    var likedFeed: some View {
        VStack{
            let blockedUsers: [String] = UserDefaults.standard.stringArray(forKey: "blockedUsers") ?? [String]()
            if homeData.initialLikedLoading {fullScreenProgessView()}
            else{
                if homeData.likedPosts.isEmpty {
                    emptyFeed(title: "No Recent Posts", subTitle: "The most liked posts from the last 24 hours will appear in this feed.")
                }
                else {
                    ScrollView{
                        Spacer(minLength: 5)
                        
                        VStack(spacing: 10){
                            
                            ForEach(Array(homeData.likedPosts.sorted(by: { $0.votes > $1.votes }).enumerated()), id: \.element) {index, post in
                                
                                if !blockedUsers.contains(post.authoruid) {
                                    cardView(postData: post, votes: post.votes, upvote: UserDefaults.standard.bool(forKey: "\(post.id)upvoted"), downvote: UserDefaults.standard.bool(forKey: "\(post.id)downvoted"), reported: UserDefaults.standard.bool(forKey: "\(post.id)reported"))
                                    
                                    if index.isMultiple(of: 7) && index != 0 {
                                       
                                       
                                        nativeAdView
                                        
                                    }
                                   
                                }
                                
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    var loadMoreRecentsButton: some View {
        Button(action: {homeData.loadingMoreRecents = true; homeData.fetchMoreRecentPosts()}, label: {
            if homeData.loadingMoreRecents == true {ProgressView()}
            else{
                Text("Load more...").foregroundColor(.orange)
            }
        }).padding()
    }
    
    var newPostButton: some View {
        Button(action:
                {showPostSheet = true},
               label:
                {Image(systemName: "plus.app").foregroundColor(.black)})

    }
    var homeNavBar: some View {
            HStack{
                Button(action:
                        {withAnimation{homeData.filterTab = 0} },
                       label:
                        {if homeData.filterTab == 0 {Text("New").bold().underline()}
                    else {Text("New")}}).foregroundColor(Color.black)
                   
                Image("tiger")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .aspectRatio(contentMode: .fill)
                    .padding([.leading, .trailing])
                    
                Button(action:
                        {withAnimation{homeData.filterTab = 1} },
                       label:
                        {if homeData.filterTab == 1 {Text("Liked").bold().underline()}
                    else {Text("Liked")}}).foregroundColor(Color.black)
            }
    }
    
}

struct fullScreenProgessView: View {
    var body: some View{
        VStack{
            Spacer()
            HStack{
                Spacer()
                ProgressView()
                Spacer()
            }
            Spacer()
        }
    }
}

struct emptyFeed: View {
    var title: String
    var subTitle: String
    var body: some View{
        VStack{
            Spacer()
            HStack{
                Spacer()
                Image(systemName: "tray")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(.customOrange)
                Spacer()
            }
            Text(title).font(.body).fontWeight(.medium).padding(.top)
            Text(subTitle).multilineTextAlignment(.center).padding(.horizontal)
            Spacer()

        }
    }
}

