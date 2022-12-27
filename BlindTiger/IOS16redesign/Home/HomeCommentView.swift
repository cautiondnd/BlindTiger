//
//  HomeCommentView.swift
//  BlindTigerRedesign
//
//  Created by dante  delgado on 3/26/22.
//

import SwiftUI

struct HomeCommentView: View {
    @ObservedObject var commentData = CommentModel()
    var postCommentedOn: post
    var selectedSchool = cleanSchool
    var peekView = false


    var body: some View {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 10) {
                        cardCommentedOn(postData: postCommentedOn)
                        
                        if commentData.initialLoading == true {
                            fullScreenProgessView()
                        }
                        else{
                            commentFeed
                        }
                    }
                }.onTapGesture {UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)}
                if peekView == false {
                    Spacer(minLength: 2)
                    newCommentBar
            }
                
            }
            .background(Color.customGray)
            .onAppear() {commentData.fetchCommentData(id: postCommentedOn.id, selectedSchool: selectedSchool)}
            .navigationTitle(Text("Comments"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarColor(UIColor(Color.customOrange))
       
    }
    
    var commentFeed: some View {
        VStack(spacing: 10) {
            let blockedUsers: [String] = UserDefaults.standard.stringArray(forKey: "blockedUsers") ?? [String]()
            ForEach(commentData.comments) { comment in
                if !blockedUsers.contains(comment.authoruid) {
                    cardView(
                        postData: comment,
                        votes: comment.votes,
                        upvote: UserDefaults.standard.bool(forKey: "\(comment.id)upvoted"),
                        downvote: UserDefaults.standard.bool(forKey: "\(comment.id)downvoted"),
                        reported: UserDefaults.standard.bool(forKey: "\(comment.id)reported"),
                        canVote: !peekView,
                        canComment: false,
                        rootPostID: postCommentedOn.id)
                }
            }
        }
    }
    
    var newCommentBar: some View{
        VStack(spacing: 0){
            let newLines = commentData.newCommentContent.components(separatedBy: "\n").count
            if (!commentData.newCommentContent.isEmpty) {
                HStack{
                    Text("\(newLines)/10")
                        .foregroundColor(newLines > 10 ? .red: .gray)
                        .font(.caption)
                    Spacer()
                    Text("\(commentData.newCommentContent.count)/280")
                        .foregroundColor(commentData.newCommentContent.count > 280 ? .red: .gray)
                        .font(.caption)
                }.padding(.horizontal)
            }
            
            HStack{
                
                
                    
                if #available(iOS 16.0, *) {
                    TextField("Write a comment", text: $commentData.newCommentContent, axis: .vertical)
                        .lineLimit(1...6)
                        .font(.callout)
                        .padding(.vertical, 8)
                        .padding(.leading, 10)
                } else {
                    // Fallback on earlier versions
                    ZStack(alignment: Alignment.leading){
                        
                        TextEditor(text: $commentData.newCommentContent)
                        .frame(height: commentData.newCommentContent.count < 40 ? 20 : 75)
                            .font(.callout)
                            .padding(.vertical, 8)
                            .padding(.leading, 10)
                        if commentData.newCommentContent.isEmpty {
                            Text("Write a comment")
                            .foregroundColor(Color(UIColor.placeholderText))
                            .padding(.vertical, 8)
                            .padding(.leading)
                            .allowsHitTesting(false)
                            
                        }
                    }
                }
                  
                Button(action: {commentData.uploadComment(id: postCommentedOn.id); commentData.fetchCommentData(id: postCommentedOn.id, selectedSchool: cleanSchool)},
                       label: {Text("Post")
                        .foregroundColor(.orange)
                        .padding(.trailing)})
                
            }
            .background(RoundedRectangle(cornerRadius: 20)
            .foregroundColor(.white))
            .padding(.horizontal, 5)
        }
    }
//        var firstOpenNavBar: some View {
//            ZStack{
//                HStack{
//                    Spacer()
//                    Text("Comments")
//                        .font(.headline)
//                        .foregroundColor(.black)
//                        .fontWeight(.semibold)
//                    Spacer()}
//            HStack{
//                NavigationLink(destination: {TabBarView(selectedTab: 0, firstOpen: true)}, label: {Image(systemName: "chevron.left").foregroundColor(.black).font(.title2).padding(.horizontal)})
//                Spacer()
//            }
//            }.padding(.bottom, 5).background(Color.customOrange)
//        }
}

