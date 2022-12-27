////
////  PeekSchoolComments.swift
////  BlindTiger
////
////  Created by dante  delgado on 6/22/22.
////
//
//import SwiftUI
//
//struct PeekSchoolComments: View {
//    @ObservedObject var commentData = CommentModel()
//    var postCommentedOn: post
//    var selectedSchool : String
//    var body: some View {
//
//            ScrollView {
//                VStack(spacing: 15) {
//                    cardCommentedOn(postData: postCommentedOn)
//                    ForEach(commentData.comments) { comment in
//                        cardView(
//                            postData: comment,
//                            votes: comment.votes,
//                            upvote: UserDefaults.standard.bool(forKey: "\(comment.id)upvoted"),
//                            downvote: UserDefaults.standard.bool(forKey: "\(comment.id)downvoted"),
//                            reported: UserDefaults.standard.bool(forKey: "\(comment.id)reported"),
//                            canVote: false,
//                            canComment: false,
//                            selectedSchool: selectedSchool,
//                            rootPostID: postCommentedOn.id)
//                    }
//                }
//            }
//            .background(Color.customGray)
//            .onAppear() {commentData.fetchCommentData(id: postCommentedOn.id, selectedSchool: cleanSchool)}
//            .navigationTitle(Text("Comments"))
//            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarColor(UIColor(Color.customOrange))
//
//    }
//}
