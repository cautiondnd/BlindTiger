//
//  SelfProfileView.swift
//  BlindTigerRedesign
//
//  Created by dante  delgado on 3/25/22.
//

import SwiftUI
import Firebase

struct SelfProfileView: View {
    @ObservedObject var profileData = ProfileModel()
    @State var postType = 0
    @State var showUnblockUsersAlert = false
    @State var showDeleteAccountAlert = false

    var body: some View {
           // NavigationStack{
                VStack(spacing:0){
                    
                    profileCard
                    
                    if postType == 0 {
                        postFeed.onAppear(){profileData.fetchPostData()}}
                    else if postType == 1 {
                        commentFeed.onAppear(){profileData.fetchCommentData()}}
                    else if postType == 2 {
                        reviewFeed.onAppear(){profileData.fetchReviewData()}}
                    else {
                        promoFeed.onAppear(){profileData.fetchPromoData()}
                    }
                    
                    
                }
                .onAppear(){profileData.fetchDateCreated(); profileData.fetchTigerScore()}
                .navigationTitle(Text("Profile"))
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarColor(UIColor(Color.customOrange))
                    .toolbar{ToolbarItem(placement: .navigationBarTrailing) {profileSettings}}
                    
            //}.accentColor(.black)
       
    }
    
//    var firstOpenNavBar: some View {
//        ZStack{
//            HStack{
//                Spacer()
//                Text("Profile")
//                    .font(.headline)
//                    .foregroundColor(.black)
//                    .fontWeight(.semibold)
//                Spacer()
//            }
//            HStack{
//                Spacer()
//                profileSettings.font(.title2).padding(.horizontal)
//            }
//        }.padding(.bottom, 5).background(Color.customOrange)
//    }
    
    var postFeed: some View {
        VStack{
            if profileData.initialPostLoading {fullScreenProgessView()}
            else {
                if profileData.recentPosts.isEmpty {emptyFeed(title: "No Posts Yet", subTitle: "BlindTiger is more fun when you post! Go to the home tab to upload your first post.")}
                else {
                    TabView(selection: $profileData.filterTab) {
                        ScrollView {
                            Spacer(minLength: 5)
                            VStack(spacing: 15){
                                ForEach(profileData.recentPosts) {post in
                                    cardView(postData: post, votes: post.votes, upvote: UserDefaults.standard.bool(forKey: "\(post.id)upvoted"), downvote: UserDefaults.standard.bool(forKey: "\(post.id)downvoted"), reported: UserDefaults.standard.bool(forKey: "\(post.id)reported"), canVote: false)
                                }
                            }
                            if !profileData.noMoreRecentPosts{loadMoreRecentPosts}
                        }.tag(0)
                        ScrollView {
                            Spacer(minLength: 5)
                            VStack(spacing: 15){
                                ForEach(profileData.likedPosts) {post in
                                    cardView(postData: post, votes: post.votes, upvote: UserDefaults.standard.bool(forKey: "\(post.id)upvoted"), downvote: UserDefaults.standard.bool(forKey: "\(post.id)downvoted"), reported: UserDefaults.standard.bool(forKey: "\(post.id)reported"), canVote: false)
                                }
                            }
                            if !profileData.noMoreLikedPosts{loadMoreLikedPosts}
                        }.tag(1)
                    }.tabViewStyle(.page(indexDisplayMode: .never))
                }
            }
        }.background(Color.customGray)
    }
    
    var loadMoreRecentPosts: some View {
        Button(action: {
            profileData.loadingMoreRecentPosts = true; profileData.moreRecentPosts()
            
        }, label: {
            if profileData.loadingMoreRecentPosts == true {ProgressView()}
            else{
                Text("Load more...").foregroundColor(.orange)
            }
        }).padding()
    }
    
    var loadMoreLikedPosts: some View {
        Button(action: {profileData.loadingMoreLikedPosts = true; profileData.moreLikedPosts()}, label: {
            if profileData.loadingMoreLikedPosts == true {ProgressView()}
            else{
                Text("Load more...").foregroundColor(.orange)
            }
        }).padding()
    }
    
    var commentFeed: some View {
        VStack{
            if profileData.initialCommentLoading {fullScreenProgessView()}
            else {
                if profileData.recentComments.isEmpty {emptyFeed(title: "No Comments Yet", subTitle: "Respond to posts and events by leaving a comment.")}
                else {
                    TabView(selection: $profileData.filterTab) {
                        ScrollView {
                            Spacer(minLength: 5)
                            
                            VStack(spacing: 15){
                                ForEach(profileData.recentComments) { comment in
                                    cardView(postData: comment, votes: comment.votes, upvote: UserDefaults.standard.bool(forKey: "\(comment.id)upvoted"), downvote: UserDefaults.standard.bool(forKey: "\(comment.id)downvoted"), reported: UserDefaults.standard.bool(forKey: "\(comment.id)reported"), canVote: false, canComment: false, rootPostID: comment.rootPostID)}
                            }
                            if !profileData.noMoreRecentComments{loadMoreRecentComments}
                            
                        }.tag(0)
                        ScrollView {
                            Spacer(minLength: 5)
                            
                            VStack(spacing: 15){
                                ForEach(profileData.likedComments) { comment in
                                    cardView(postData: comment, votes: comment.votes, upvote: UserDefaults.standard.bool(forKey: "\(comment.id)upvoted"), downvote: UserDefaults.standard.bool(forKey: "\(comment.id)downvoted"), reported: UserDefaults.standard.bool(forKey: "\(comment.id)reported"), canVote: false, canComment: false, rootPostID: comment.rootPostID)}
                            }                            
                        }.tag(1)
                    }.tabViewStyle(.page(indexDisplayMode: .never))
                }
            }
        }.background(Color.customGray)
    }
    
    var loadMoreRecentComments: some View {
        Button(action: {profileData.loadingMoreRecentComments = true; profileData.moreRecentComments()}, label: {
            if profileData.loadingMoreRecentComments == true {ProgressView()}
            else{
                Text("Load more...").foregroundColor(.orange)
            }
        }).padding()
    }
//
//    var loadMoreLikedComments: some View {
//        Button(action: {profileData.loadingMoreLikedComments = true; profileData.moreLikedComments()}, label: {
//            if profileData.loadingMoreLikedComments == true {ProgressView()}
//            else{
//                Text("Load more...").foregroundColor(.orange)
//            }
//        }).padding()
//    }
//
    
    var promoFeed: some View {
        VStack{
            if profileData.initialPromoLoading {fullScreenProgessView()}
            else {
                if profileData.recentPromos.isEmpty {emptyFeed(title: "No Promoted Events", subTitle: "Organizing an on campus event? Use BlindTiger to promote it!")}
                else {
                    TabView(selection: $profileData.filterTab) {
                        ScrollView {
                            Spacer(minLength: 5)
                            
                            VStack(spacing: 15){
                                ForEach(profileData.recentPromos) {promo in
                                    promoCardView(promo: promo, votes: promo.votes, upvote: UserDefaults.standard.bool(forKey: "\(promo.id)upvoted"), reported: UserDefaults.standard.bool(forKey: "\(promo.id)reported"), canVote: false)
                                }
                            }
                            if !profileData.noMoreRecentPromos{loadMoreRecentPromos}
                        }.tag(0)
                        ScrollView {
                            Spacer(minLength: 5)
                            
                            VStack(spacing: 15){
                                ForEach(profileData.likedPromos) {promo in
                                    promoCardView(promo: promo, votes: promo.votes, upvote: UserDefaults.standard.bool(forKey: "\(promo.id)upvoted"), reported: UserDefaults.standard.bool(forKey: "\(promo.id)reported"), canVote: false)
                                }
                            }
                        }.tag(1)
                    }.tabViewStyle(.page(indexDisplayMode: .never))
                }
            }
        }.background(Color.customGray)
    }
    
    var loadMoreRecentPromos: some View {
        Button(action: {profileData.loadingMoreRecentPromos = true; profileData.moreRecentPromos()}, label: {
            if profileData.loadingMoreRecentPromos == true {ProgressView()}
            else{
                Text("Load more...").foregroundColor(.orange)
            }
        }).padding()
    }
    
//    var loadMoreLikedPromos: some View {
//        Button(action: {profileData.loadingMoreLikedComments = true; profileData.moreLikedComments()}, label: {
//            if profileData.loadingMoreLikedComments == true {ProgressView()}
//            else{
//                Text("Load more...").foregroundColor(.orange)
//            }
//        }).padding()
//    }
    
    var reviewFeed: some View {
        VStack{
            if profileData.initialReviewLoading {fullScreenProgessView()}
            else {
                if profileData.recentReviews.isEmpty {emptyFeed(title: "No Reviews Yet", subTitle: "Help out your community by leaving ratings and reviews for organizations you've interacted with.")}
                else {
                    TabView(selection: $profileData.filterTab) {
                        ScrollView {
                            Spacer(minLength: 5)
                            
                            VStack(spacing: 15){
                                ForEach(profileData.recentReviews) {review in
                                    reviewCommentCard(reviewData: review, votes: review.votes, upvote: UserDefaults.standard.bool(forKey: "\(review.id)upvoted"), downvote: UserDefaults.standard.bool(forKey: "\(review.id)downvoted"), reported: UserDefaults.standard.bool(forKey: "\(review.id)reported"), canVote: false)
                                }
                            }
                            if !profileData.noMoreRecentReviews{loadMoreRecentReviews}
                        }.tag(0)
                        ScrollView {
                            Spacer(minLength: 5)
                            
                            VStack(spacing: 15){
                                ForEach(profileData.likedReviews) {review in
                                    reviewCommentCard(reviewData: review, votes: review.votes, upvote: UserDefaults.standard.bool(forKey: "\(review.id)upvoted"), downvote: UserDefaults.standard.bool(forKey: "\(review.id)downvoted"), reported: UserDefaults.standard.bool(forKey: "\(review.id)reported"), canVote: false)
                                }
                            }
                        }.tag(1)
                    }.tabViewStyle(.page(indexDisplayMode: .never))
                }
            }
        }.background(Color.customGray)
    }
    
    var loadMoreRecentReviews: some View {
        Button(action: {profileData.loadingMoreRecentReviews = true; profileData.moreRecentReviews(); print(profileData.recentReviews)}, label: {
            if profileData.loadingMoreRecentReviews == true {ProgressView()}
            else{
                Text("Load more...").foregroundColor(.orange)
            }
        }).padding()
    }
    
//    var loadMoreLikedReviews: some View {
//        Button(action: {profileData.loadingMoreLikedReviews = true; profileData.moreLikedReviews()}, label: {
//            if profileData.loadingMoreLikedReviews == true {ProgressView()}
//            else{
//                Text("Load all...").foregroundColor(.orange)
//            }
//        }).padding()
//    }
    
    var profileSettings: some View {
        Menu {
            if profileData.tigerScore >= 500 {
                Button(action: {profileData.updateTigerScore()}, label: {Text("Update Tiger Score")})
            }
            
                Button(action: {showUnblockUsersAlert = true }, label: {Text("Unblock All Users")})
                            
                Button(action: {showDeleteAccountAlert = true}, label: {Text("Delete Account")})
            
            Button(action: {UserDefaults.standard.set(false, forKey: "hasSignedIn")}, label: {Text("Log Out")})
                                
        } label: {
            Image(systemName: "gear").foregroundColor(.black)
        }
    }
    
  
    var profileCard: some View{
            VStack{
                profileCardHeader
                categorySelect
                recentLikedFilter
            }.padding(.top)
        }
    
    var profileCardHeader: some View {
        HStack{
            VStack{
                Text("Tiger").font(.footnote)
                Text("\(profileData.tigerScore)").font(.headline)
                Text("Score").font(.footnote)
            }.frame(width: 80, height: 80).background(RoundedRectangle(cornerRadius: 10).foregroundColor(.customOrange)).overlay(RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 2.5))
            
            
                VStack(alignment: HorizontalAlignment.leading) {
                    Text("Member Since").font(.caption2)
                    if #available(iOS 15.0, *) {
                    Text("\(profileData.dateCreated.formatted(.dateTime.month(.wide).year()))").font(.title).lineLimit(1)
                    } else {
                        // Fallback on earlier versions
                        Text("\(profileData.dateCreated, style: .date)").font(.title).lineLimit(1)
                    }
                }
            
            
            Spacer()
        }.padding(.horizontal)
    }
    
    var categorySelect: some View{
        ScrollView(.horizontal, showsIndicators: false) {
            HStack{
                filterButton(categoryName: "Posts", filterNum: 0, postType: $postType)
                    .alert(isPresented: $showUnblockUsersAlert, content: {Alert(
                        title: Text("Unblock all users?"),
                        message: Text("There is no way to undo this action."),
                        primaryButton: .cancel(Text("Cancel")) {},
                        secondaryButton: .default(Text("Unblock")) {
                            UserDefaults.standard.set([String](), forKey: "blockedUsers")})})
                filterButton(categoryName: "Comments", filterNum: 1, postType: $postType)
                    .alert(isPresented: $showDeleteAccountAlert, content: {Alert(
                        title: Text("Delete account?"),
                        message: Text("There is no way to recover your account. Are you sure you want to delete your account?"),
                        primaryButton: .cancel(Text("Cancel")) {},
                        secondaryButton: .destructive(Text("Delete")) {
                            db.collection("BlindTiger").document(cleanSchool).collection("users").document(Auth.auth().currentUser!.uid).delete()
                            UserDefaults.standard.set(false, forKey: "hasSignedIn")
                        })})
                filterButton(categoryName: "Reviews", filterNum: 2, postType: $postType)
                filterButton(categoryName: "Events", filterNum: 3, postType: $postType)
                }.padding(2)
        }
    }
    
    var recentLikedFilter: some View {
        VStack{
            HStack{
                Spacer()
               
                    // Fallback on earlier versions
                    Button { profileData.filterTab = 0 } label: {Image(systemName: "clock"); Text("Recent")}
                        .padding(.top)
                        .foregroundColor(profileData.filterTab == 0 ? .black : .gray)
                Spacer()
                Spacer()
               
                    // Fallback on earlier versions
                    Button { profileData.filterTab = 1 } label: {Image(systemName: "heart"); Text("Liked")}
                        .padding(.top)
                        .foregroundColor(profileData.filterTab == 1 ? .black : .gray)
                Spacer()
            }
            HStack(spacing: 0) {
                Rectangle().frame(maxWidth: .infinity, maxHeight: 1).foregroundColor(profileData.filterTab == 0 ? .black: .clear)
                Rectangle().frame(maxWidth: .infinity, maxHeight: 1).foregroundColor(profileData.filterTab == 0 ? .clear: .black)
            }
//            if profileData.filterTab == 0 {Rectangle().frame(width: 200, height: 1).offset(x:-100)}
//            else {Rectangle().frame(width: 200, height: 1).offset(x:100)}
        }
    }
        
}



struct filterButton: View {
    var categoryName: String
    var filterNum: Int
    @Binding var postType: Int
    var body: some View{
        Button(
            action: {postType = filterNum},
            label: {
                // Fallback on earlier versions
                Text(categoryName)
                    .font(.callout)
                    .padding(.vertical, 4)
                    .padding(.horizontal)
                    .background(postType == filterNum ? Color.orange: Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(.orange, lineWidth: 1.5))
            }).buttonStyle(PlainButtonStyle())
    }
}



