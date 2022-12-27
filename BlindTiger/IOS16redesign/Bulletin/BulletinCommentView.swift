//
//  BulletinCommentView.swift
//  BlindTiger
//
//  Created by dante  delgado on 7/5/22.
//

import SwiftUI

struct BulletinCommentView: View {
    @ObservedObject var bulletinData = BulletinCommentModel()
    var promoCommentedOn: promo
    
    var body: some View {
        VStack(spacing: 0){
            ScrollView{
                promoCommentedOnCard(promo: promoCommentedOn)
                
                
                if bulletinData.initialLoading == true {
                    fullScreenProgessView()
                }
                let blockedUsers: [String] = UserDefaults.standard.stringArray(forKey: "blockedUsers") ?? [String]()
                ForEach(bulletinData.comments) { comment in
                    if !blockedUsers.contains(comment.authoruid) {
                        cardView(
                            postData: comment,
                            votes: comment.votes,
                            upvote: UserDefaults.standard.bool(forKey: "\(comment.id)upvoted"),
                            downvote: UserDefaults.standard.bool(forKey: "\(comment.id)downvoted"),
                            reported: UserDefaults.standard.bool(forKey: "\(comment.id)reported"),
                            canComment: false, promoComment: true, rootPostID: promoCommentedOn.id)
                    }
                }
            } .onTapGesture {UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)}
            Spacer(minLength: 2)
            
            
            let newLines = bulletinData.newCommentContent.components(separatedBy: "\n").count
            if (!bulletinData.newCommentContent.isEmpty) {
                HStack{
                    Text("\(newLines)/10")
                        .foregroundColor(newLines > 10 ? .red: .gray)
                        .font(.caption)
                    Spacer()
                    Text("\(bulletinData.newCommentContent.count)/280")
                        .foregroundColor(bulletinData.newCommentContent.count > 280 ? .red: .gray)
                        .font(.caption)
                }.padding(.horizontal)
            }
            
            HStack{
            
                if #available(iOS 16.0, *) {
                    TextField("Write a comment", text: $bulletinData.newCommentContent, axis: .vertical)
                        .lineLimit(1...6)
                        .font(.callout)
                        .padding(.vertical, 8)
                        .padding(.leading, 10)
                } else {
                    // Fallback on earlier versions
                    ZStack(alignment: Alignment.leading){
                        
                        TextEditor(text: $bulletinData.newCommentContent)
                        .frame(height: bulletinData.newCommentContent.count < 40 ? 20 : 75)
                            .font(.callout)
                            .padding(.vertical, 8)
                            .padding(.leading, 10)
                        if bulletinData.newCommentContent.isEmpty {
                            Text("Write a comment")
                            .foregroundColor(Color(UIColor.placeholderText))
                            .padding(.vertical, 8)
                            .padding(.leading)
                            .allowsHitTesting(false)
                            
                        }
                    }
                }
                
                
                
                
                Button(action: {bulletinData.uploadComment(id: promoCommentedOn.id); bulletinData.fetchCommentData(id: promoCommentedOn.id)},
                       label: {
                    Text("Post")
                        .foregroundColor(.orange)
                        .padding(.trailing)
                })
                
                
                
            }
            .background(RoundedRectangle(cornerRadius: 20).foregroundColor(.white))
            .padding(.horizontal, 5)
            
        }
        
        .background(Color.customGray)
        .onAppear() {bulletinData.fetchCommentData(id: promoCommentedOn.id)}
        .navigationTitle(Text("\(promoCommentedOn.title)"))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarColor(UIColor(Color.customOrange))
        
   
    }
    
    
  
}





