//
//  CommentView.swift
//  BlindTiger
//
//  Created by dante  delgado on 11/22/20.
//

import SwiftUI
import Firebase

struct CommentView: View {
    
    @State var textHeight: CGFloat = 0
    @State var cameFromSecondaryView = false
    
    var textFieldHeight: CGFloat {
        let minHeight: CGFloat = 30
        let maxHeight: CGFloat = 70
        
        if textHeight < minHeight {
            return minHeight
        }
        
        if textHeight > maxHeight {
            return maxHeight
        }
        
        return textHeight
    }
    
    var content: String
    var votes: Int
    var time: Timestamp
    var authoruid: String
    var anonymous: Bool
    var id: String
    var authorusername: String
    @Binding var blockedUsers: [String]
    
    @State var commentContent = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var commentData = commentViewModel()
    
    var body: some View {
        NavigationView{
            
            
            VStack(spacing: 0){
                cardCommentedOn(content: content, votes: votes, time: time, authoruid: authoruid, anonymous: anonymous, id: id, authorusername: authorusername, blockedUsers: $blockedUsers).background(Rectangle().foregroundColor(.white).shadow(color: Color.black.opacity(0.15), radius: 6)).padding(.vertical, 2)
                
                if commentData.initialLoading == true{
                    VStack{
                        Spacer()
                        ActivityIndicator(shouldAnimate: $commentData.initialLoading)
                        Spacer()
                    }
                }
                else {
                VStack{
                    
                    ScrollView{
                        
                        ForEach(commentData.comments.sorted(by: { $0.time.seconds < $1.time.seconds })) {comment in
                            if blockedUsers.contains(comment.authoruid) {}
                            else{
                            commentCardView(content: comment.content, votes: comment.votes, time: comment.time, authoruid: comment.authoruid, anonymous: comment.anonymous, postid: comment.postid, commentid: comment.id, authorusername: comment.authorusername, upvote:  UserDefaults.standard.bool(forKey: "\(comment.id)upvoted"), downvote:  UserDefaults.standard.bool(forKey: "\(comment.id)downvoted"), reports: comment.reports, reported: UserDefaults.standard.bool(forKey: "\(comment.id)reported"), blockedUsers: $blockedUsers)
                                }
                            }
                        
                    }
                    .padding(.bottom, 2)
                    
                    
                }
                }
                //   ZStack{
                VStack{
                    if commentData.newCommentContent != ""{
                        HStack{
                            Toggle(isOn: $commentData.isAnonymous, label: {
                                Text("Post Anonymously?")
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray)
                                
                                
                            })
                            .toggleStyle(CheckboxToggleStyle())
                            
                            Spacer()
                            Text("\(commentData.newCommentContent.count)/240").font(.caption).foregroundColor(commentData.newCommentContent.count > 240 ? .red : .gray)
                        }.padding(.horizontal)
                        .offset(y: 3)
                        
                    }
                    HStack{
                        ZStack(alignment: .topLeading) {
                            Color.white
                            
                            if commentData.newCommentContent.isEmpty {
                                Text("Write a comment")
                                    .foregroundColor(Color(UIColor.placeholderText))
                                    .padding(4)
                            }
                            
                            DynamicHeightTextField(text: $commentData.newCommentContent, height: $textHeight)//.padding()//.background(Capsule().foregroundColor(.white))
                            
                        }
                        .frame(height: textFieldHeight)
                        
                        
                        Button(action: {
                            if commentData.uploadingComment == false{
                                commentData.newComment(id: id)}
                            else{}
                            
                        }, label: {
                            Text("post").padding(.vertical, 10)
                        })
                        
                    }.padding(.horizontal)
                    //.padding(.leading, 5)//controls indent
                    .background(Capsule().foregroundColor(.white))
                    .padding(.horizontal, 5)
                }
                
                //                TextEditor(text: $commentData.newCommentContent)
                //                .padding()
                //                .background(Capsule().foregroundColor(.white)).frame(maxWidth: .infinity,maxHeight: 55, alignment: .center)//.padding(.horizontal)
                //                //gotta figure out how to make it so that when u click the text u cna start typing
                //                HStack{
                //                    if commentData.newCommentContent == "" {
                //                        Text("Write a comment").foregroundColor(.gray).opacity(0.8)}
                //
                //                    Spacer()
                //
                //                    Button(action: {
                //                            commentData.newComment(id: id)
                //
                //                    }, label: {
                //                        Text("post")
                //                    })
                //
                //
                //                }.padding()
                //                .clipShape(Capsule())
                
                //      }
                
                
            }
            
            //.navigationBarHidden(!cameFromHome)
            .background(Rectangle().foregroundColor(.customGray).ignoresSafeArea(edges: .all))
            //presmode dismiss makes the nav stack reset on tab changes
            .onAppear() {commentData.fetchData(id: id, selectedSchool: cleanSchool); self.presentationMode.wrappedValue.dismiss()}
            .onTapGesture {UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)}
            
            
            .navigationBarHidden(true)
            
        }
        
        .navigationBarHidden(cameFromSecondaryView)
        .navigationBarTitle(Text(""), displayMode: .inline)//.border(Color.black)
        //        .navigationBarBackButtonHidden(true)
        //        .navigationBarItems(leading: Button(action: {
        //            self.presentationMode.wrappedValue.dismiss()
        //                }, label: {
        //                Image(systemName: "chevron.left").foregroundColor(.black)
        //                }))
        .toolbar{
            ToolbarItem(placement: .principal) {
                Image("tiger")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .aspectRatio(contentMode: .fill)
                    .offset(y: 0)
            }
            
            
        }
        .navigationBarColor(UIColor(Color.customOrange))
        
    }
    
}


//struct CommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentView()
//    }
//}


//
//struct commentTab: View {
//    var content: String
//    var votes: Int
//    var time: Timestamp
//    var authoruid: String
//    var anonymous: Bool
//    var id: String
//    var authorusername: String
//    var body: some View {
//        CommentView(content: content, votes: votes, time: time, authoruid: authoruid, anonymous: anonymous, id: id, authorusername: authorusername)}}
struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            configuration.label
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .resizable()
                .foregroundColor(.gray)
                .frame(width: 15, height: 15)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}
