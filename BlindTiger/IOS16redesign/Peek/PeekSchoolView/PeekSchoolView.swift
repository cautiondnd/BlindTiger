//
//  PeekSchoolView.swift
//  BlindTiger
//
//  Created by dante  delgado on 6/21/22.
//

import SwiftUI

struct PeekSchoolView: View {
    @ObservedObject var peekSchoolData = PeekSchoolModel()
    var selectedSchool: String
    var body: some View {
            VStack{
                if peekSchoolData.initialRecentLoading == true {
                    fullScreenProgessView()
                }
                else{
                    TabView(selection: $peekSchoolData.filterTab) {
                        recentFeed.tag(0)
                        likedFeed.tag(1).onAppear(){peekSchoolData.fetchLikedData(selectedSchool: selectedSchool)}
                    }.tabViewStyle(.page(indexDisplayMode: .never))
                }
            }
                .onAppear() {peekSchoolData.fetchRecentData(selectedSchool: selectedSchool)}
                .background(Color.customGray)
                //custom navigation bar is all within this toolbar
                .toolbar{
                    ToolbarItem(placement: .principal) {homeNavBar}
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarColor(UIColor(Color.customOrange))
                



            
                
      
   
    }
    var recentFeed: some View{
        ScrollView {
            let blockedUsers: [String] = UserDefaults.standard.stringArray(forKey: "blockedUsers") ?? [String]()
            Spacer(minLength: 5)
            VStack(spacing: 10){
                ForEach(Array(peekSchoolData.recentPosts.enumerated()), id: \.element) {index, post in
                    if !blockedUsers.contains(post.authoruid) {
                        cardView(postData: post, votes: post.votes, upvote: false, downvote: false, reported: true, canVote: false, selectedSchool: selectedSchool)
                    }
//                    if index.isMultiple(of: 7) && index != 0 {
//                        midPostAd()
//                    }
                }
                if peekSchoolData.noMoreRecents == false {loadMoreRecentsButton}
            }
        }
    }
    
    var likedFeed: some View{
        VStack{
            if peekSchoolData.initialLikedLoading {fullScreenProgessView()}
            else{
                ScrollView {
                    let blockedUsers: [String] = UserDefaults.standard.stringArray(forKey: "blockedUsers") ?? [String]()
                    Spacer(minLength: 5)
                    VStack(spacing: 10){
                        ForEach(Array(peekSchoolData.likedPosts.enumerated()), id: \.element) {index, post in
                            if !blockedUsers.contains(post.authoruid) {
                                cardView(postData: post, votes: post.votes, upvote: false, downvote: false, reported: true, canVote: false, selectedSchool: selectedSchool)
                            }
//                            if index.isMultiple(of: 7) && index != 0 {
//                                midPostAd()
//                            }
                        }
                    }
                    if peekSchoolData.noMoreLiked == false {loadMoreLikedButton}
                }
            }
        }
    }

    
    var loadMoreRecentsButton: some View {
        Button(action: {peekSchoolData.loadingMoreRecents = true; peekSchoolData.fetchMoreRecentPosts(selectedSchool: selectedSchool)}, label: {
            if peekSchoolData.loadingMoreRecents == true {ProgressView()}
            else{
                Text("Load more...").foregroundColor(.orange)
            }
        }).padding()
    }
    
    var loadMoreLikedButton: some View {
        Button(action: {peekSchoolData.loadingMoreLiked = true; peekSchoolData.fetchMoreLikedPosts(selectedSchool: selectedSchool)}, label: {
            if peekSchoolData.loadingMoreLiked == true {ProgressView()}
            else{
                Text("Load more...").foregroundColor(.orange)
            }
        }).padding()
    }
    

    var homeNavBar: some View {
            HStack{
                Button(action:
                        {withAnimation{peekSchoolData.filterTab = 0} },
                       label:
                        {if peekSchoolData.filterTab == 0 {Text("New").bold().underline()}
                    else {Text("New")}}).foregroundColor(Color.black)
                VStack(spacing: 0){
                    Text(selectedSchool.capitalized).font(.callout)
                    Image("tiger")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .aspectRatio(contentMode: .fill)
                        .padding([.leading, .trailing])
                }
                    
                Button(action:
                        {withAnimation{peekSchoolData.filterTab = 1}},
                       label:
                        {if peekSchoolData.filterTab == 1 {Text("Liked").bold().underline()}
                    else {Text("Liked")}}).foregroundColor(Color.black)
            }
    }
    
}
