//
//  RatingCommentView.swift
//  BlindTiger
//
//  Created by dante  delgado on 7/11/22.
//

import SwiftUI
import Firebase


struct RatingCommentView: View {
    @ObservedObject var commentData = ReviewCommentModel()
    var rootOrg: org
    
    @State var showErros = false
    
    var body: some View {
        VStack{
            ScrollView{
                orgCommentedOn(org: rootOrg, userRating: UserDefaults.standard.integer(forKey: "\(rootOrg.id)rating")
                )
                
                if commentData.initialLoading {
                    fullScreenProgessView()
                }
                else {
                    commentFeed
                }
                
                
                
            } .onTapGesture {UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)}
            Spacer(minLength: 2)
            
            VStack(spacing: 0) {
                if (!commentData.newReviewContent.isEmpty) {
                    commentWordCount.padding(.vertical, 2)
                }
                commentBar
            }
        }
        .background(Color.customGray)
        .onAppear(){commentData.fetchData(rootID: rootOrg.id)}
        .navigationTitle(Text(rootOrg.title))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarColor(UIColor(Color.customOrange))
    }
    
    var commentFeed: some View {
        VStack {
            let blockedUsers: [String] = UserDefaults.standard.stringArray(forKey: "blockedUsers") ?? [String]()
            
            ForEach(commentData.reviews) {review in
                if !blockedUsers.contains(review.authoruid) {
                    reviewCommentCard(reviewData: review, votes: review.votes, upvote: UserDefaults.standard.bool(forKey: "\(review.rootPostID)upvoted"), downvote: UserDefaults.standard.bool(forKey: "\(review.rootPostID)downvoted"), reported: UserDefaults.standard.bool(forKey: "\(review.rootPostID)reported"))
                }
            }
        }
    }
    
    var commentBar: some View {
        HStack{
            
            if #available(iOS 16.0, *) {
                TextField("Write a comment", text: $commentData.newReviewContent, axis: .vertical)
                    .lineLimit(1...6)
                    .font(.callout)
                    .padding(.vertical, 8)
                    .padding(.leading, 10)
            } else {
                // Fallback on earlier versions
                ZStack(alignment: Alignment.leading){
                    
                    TextEditor(text: $commentData.newReviewContent)
                    .frame(height: commentData.newReviewContent.count < 40 ? 20 : 75)
                        .font(.callout)
                        .padding(.vertical, 8)
                        .padding(.leading, 10)
                    if commentData.newReviewContent.isEmpty {
                        Text("Write a comment")
                        .foregroundColor(Color(UIColor.placeholderText))
                        .padding(.vertical, 8)
                        .padding(.leading)
                        .allowsHitTesting(false)
                        
                    }
                }
            }
            
            
            Button(action: {
                commentData.uploadReview(rootID: rootOrg.id); commentData.fetchData(rootID: rootOrg.id)},
                   label: {
                Text("Post")
                    .foregroundColor(.orange)
                    .padding(.trailing)
            })
            
            
            
        }
        .background(RoundedRectangle(cornerRadius: 20).foregroundColor(.white))
        .padding(.horizontal, 5)
    }
    
    var commentWordCount: some View {
        HStack(spacing: 0){
            let newLines = commentData.newReviewContent.components(separatedBy: "\n").count
            let uid = Auth.auth().currentUser?.uid ?? ""
            Text("\(newLines)/10")
                .foregroundColor(newLines > 10 ? .red: .gray)
                .font(.caption)
            Spacer()
            if UserDefaults.standard.integer(forKey: "\(rootOrg.id)rating") == 0 {
                Text("Must rate this organization before you can leave a review")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.red)
                    .font(.caption2)
            }
            if !commentData.reviews.filter {$0.authoruid == uid}.isEmpty {
                Text("Note: you can only leave one review")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .font(.caption2)
            }
            Spacer()
            Text("\(commentData.newReviewContent.count)/280")
                .foregroundColor(commentData.newReviewContent.count > 280 ? .red: .gray)
                .font(.caption)
        }.padding(.horizontal)
    }
}
