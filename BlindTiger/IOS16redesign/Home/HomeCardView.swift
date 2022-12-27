//
//  HomeCardView.swift
//  BlindTiger
//
//  Created by dante  delgado on 6/14/22.
//

import SwiftUI
import Firebase

struct cardView: View {
    var postData: post
    @State var votes: Int
    @State var upvote: Bool
    @State var downvote: Bool
    @State var reported: Bool
    var canVote = true
    var canComment = true
    var promoComment = false
    var selectedSchool = cleanSchool
    var rootPostID = ""
    
    // @Binding var blockedUsers: [String]
    
    
    var body: some View {
        
        VStack(alignment: HorizontalAlignment.leading){
            
            timeAndSettings
            votesAndContent
            commentButton
            
        }
        
        .padding(.vertical)
        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white).shadow(color: Color.black.opacity(0.15), radius: 6))
        .padding(.horizontal)
        
    }
    
    var timeAndSettings: some View {
        HStack {
            Text(postData.time.dateValue().timeAgoDisplay())
                .foregroundColor(.gray)
                .font(.callout)
            Spacer()
            postSettings(post: postData, canComment: canComment, promoComment: promoComment, reported: UserDefaults.standard.bool(forKey: "\(postData.id)reported"))
                .offset(y: -4)
        }.padding(.horizontal)
    }
    
    var votesAndContent: some View {
        HStack{
            Text(postData.content)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            VStack{
                if canVote == true {
                    Button(
                        action: {upvotePost()},
                        label: {Image(systemName: "chevron.up")
                                .foregroundColor(upvote == true ? .orange : .gray)
                            .font(.title)})}
                Text("\(votes)")
                    .font(.title)
                    .lineLimit(1)
                    .allowsTightening(true)
                    .padding(.vertical, 10)
                if canVote == true {
                    Button(
                        action: {downvotePost()},
                        label: {Image(systemName: "chevron.down")
                                .foregroundColor(downvote == true ? .orange : .gray)
                            .font(.title)})}
                
                
            }
        }.padding(.horizontal)
    }
    
    var commentButton: some View {
        VStack{
            if canComment == true {
                NavigationLink(
                    destination:
                        HomeCommentView(postCommentedOn: postData, selectedSchool: selectedSchool, peekView: !canVote) ) {
                            HStack(spacing: 0){
                                Text("\(postData.numComments)")
                                    .foregroundColor(.black)
                                Image(systemName: "bubble.right")
                                    .foregroundColor(.gray)
                            }.padding(.horizontal).padding(.top, 1)
                        }}
        }
    }

    
    
    func downvotePost() {
        var postRef = db.collection("BlindTiger").document(cleanSchool).collection("posts").document(postData.id)
        if canComment == false {postRef = db.collection("BlindTiger").document(cleanSchool).collection("posts").document(rootPostID).collection("comments").document(postData.id)}
        if promoComment == true {postRef = db.collection("BlindTiger").document(cleanSchool).collection("promotions").document(rootPostID).collection("comments").document(postData.id)}
            downvote.toggle();
        UserDefaults.standard.set(self.downvote, forKey: "\(postData.id)downvoted");
        UserDefaults.standard.set(false, forKey: "\(postData.id)upvoted");
            if downvote == true {
                if upvote == true {
                    upvote = false
                    postRef.updateData(["votes" : FieldValue.increment(Int64(-4))])
                    votes -= 2
                }
                else {
                    postRef.updateData(["votes" : FieldValue.increment(Int64(-2))])
                    votes -= 1
                }
            }
            else {
                //GODMODE uncomment
                postRef.updateData(["votes" : FieldValue.increment(Int64(2))])
                votes += 1
            }
    }
    
    func upvotePost() {
        var postRef = db.collection("BlindTiger").document(cleanSchool).collection("posts").document(postData.id)
        if canComment == false {postRef = db.collection("BlindTiger").document(cleanSchool).collection("posts").document(rootPostID).collection("comments").document(postData.id)}
        if promoComment == true {postRef = db.collection("BlindTiger").document(cleanSchool).collection("promotions").document(rootPostID).collection("comments").document(postData.id)}
        upvote.toggle();
        UserDefaults.standard.set(self.upvote, forKey: "\(postData.id)upvoted");
        UserDefaults.standard.set(false, forKey: "\(postData.id)downvoted")
        if upvote == true {
            if downvote == true {
                downvote = false
                postRef.updateData(["votes" : FieldValue.increment(Int64(4))])
                votes += 2

            }
            else {
                // TEST change for how much one upvote upvotes
                postRef.updateData(["votes" : FieldValue.increment(Int64(2))])
                votes += 1
            }
        }
        else {
            //GODMODE uncomment
            postRef.updateData(["votes" : FieldValue.increment(Int64(-2))])
            votes -= 1
        }
    
    }

}

struct postSettings: View {
    let post: post
    let canComment: Bool
    let promoComment: Bool
    @State var reported: Bool
    @State var showAlert = false
    var bulletin = false
    var body: some View {
        
        Menu {
            if Auth.auth().currentUser?.uid == post.authoruid {
                Button(action: {showAlert = true}, label: {Label("Delete", systemImage: "trash")})
            
            }
            else {
                Button(action: {reportPost(postID: post.id, rootPostID: post.rootPostID)}, label: {
                    reported ?
                    Label("Reported", systemImage: "flag.fill") : Label("Report", systemImage: "flag")})

                Button(action: {showAlert = true}, label: {Label("Block", systemImage: "hand.raised")})

            }
            
        } label: {
            Image(systemName: "ellipsis")
                .foregroundColor(.gray)
                .padding([.leading, .bottom])
                
        }
        .alert(isPresented: $showAlert, content: {
            //GODMODE make ==
            Auth.auth().currentUser?.uid == post.authoruid ?
                Alert(
                    title: Text("Delete Post?"),
                    message: Text("There is no way to recover a post once deleted."),
                    primaryButton: .cancel(Text("Cancel")) {},
                    secondaryButton: .destructive(Text("Delete")) {deletePost(postID: post.id, rootPostID: post.rootPostID)}):
                Alert(
                    title: Text("Block User?"),
                    message: Text("Are you sure you want to block this user?"),
                    primaryButton: .cancel(Text("Cancel")) {},
                    secondaryButton: .destructive(Text("Block")) {
                        var blockedUsers: [String] = UserDefaults.standard.stringArray(forKey: "blockedUsers") ?? []
                        blockedUsers.append(post.authoruid)
                        UserDefaults.standard.set(blockedUsers, forKey: "blockedUsers")
                    })
        })

    }
    
    func deletePost(postID: String, rootPostID: String) {
        var postRef = db.collection("BlindTiger").document(cleanSchool).collection("posts").document(postID)
        if !canComment {postRef = db.collection("BlindTiger").document(cleanSchool).collection("posts").document(rootPostID).collection("comments").document(postID)
            db.collection("BlindTiger").document(cleanSchool).collection("posts").document(rootPostID).updateData(["numComments" : FieldValue.increment(Int64(-1))])
        }
        if promoComment == true {
            postRef = db.collection("BlindTiger").document(cleanSchool).collection("promotions").document(rootPostID).collection("comments").document(postID)
            db.collection("BlindTiger").document(cleanSchool).collection("promotions").document(rootPostID).updateData(["numComments" : FieldValue.increment(Int64(-1))])
        }
        
        postRef.delete()
        
    }
    
    func reportPost(postID: String, rootPostID: String) {
        var postRef = db.collection("BlindTiger").document(cleanSchool).collection("posts").document(postID)
        if canComment == false {postRef = db.collection("BlindTiger").document(cleanSchool).collection("posts").document(rootPostID).collection("comments").document(postID)}
        if promoComment == true {postRef = db.collection("BlindTiger").document(cleanSchool).collection("promotions").document(rootPostID).collection("comments").document(postID)}
        
        reported.toggle()
        if reported == true {
            postRef.updateData(["reports" : FieldValue.increment(Int64(1))])}
        else{
            postRef.updateData(["reports" : FieldValue.increment(Int64(-1))])}
        UserDefaults.standard.set(self.reported, forKey: "\(post.id)reported")
        
    }
}

struct post: Identifiable, Hashable {
    var id: String
    var rootPostID = ""
    var content: String
    var votes: Int
    var time: Timestamp
    var authoruid: String
    var reports : Int
    var numComments = 0
}
