////
////  PeekCommentView.swift
////  BlindTiger
////
////  Created by dante  delgado on 11/22/20.
////
//
//import SwiftUI
//import Firebase
//
//struct PeekCommentView: View {
//    
//    
//    var content: String
//    var votes: Int
//    var time: Timestamp
//    var authoruid: String
//    var anonymous: Bool
//    var id: String
//    var authorusername: String
//    var selectedSchool: String
//    
//    @State var commentContent = ""
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//
//    @ObservedObject var commentData = commentViewModel()
//    
//    @Binding var peekBlockedUsers: [String]
//
//    var body: some View {
//        
//        
//        VStack(spacing: 0){
//            peekCardCommentedOn(content: content, votes: votes, time: time, authoruid: authoruid, anonymous: anonymous, id: id, authorusername: authorusername).background(Rectangle().foregroundColor(.white).shadow(color: Color.black.opacity(0.15), radius: 6)).padding(.vertical, 2)
//
//            if commentData.initialLoading == true{
//                VStack{
//                    Spacer()
//                    ActivityIndicator(shouldAnimate: $commentData.initialLoading)
//                    Spacer()
//                }
//            }
//            else {
//        VStack{
//            
//            ScrollView{
//                ForEach(commentData.comments.sorted(by: { $0.time.seconds < $1.time.seconds })) {comment in
//                    peekCommentCardView(content: comment.content, votes: comment.votes, time: comment.time, authoruid: comment.authoruid, anonymous: comment.anonymous, postid: comment.postid, commentid: comment.id, authorusername: comment.authorusername, selectedSchool: selectedSchool, upvote:  UserDefaults.standard.bool(forKey: "\(comment.id)upvoted"), downvote:  UserDefaults.standard.bool(forKey: "\(comment.id)downvoted"), reports: comment.reports, reported: UserDefaults.standard.bool(forKey: "\(comment.id)reported"), peekBlockedUsers: $peekBlockedUsers) }
//                
//            }
//        
//            
//        }
//            }
//        
//        }
//        .background(Rectangle().foregroundColor(.customGray).ignoresSafeArea(edges: .all))
//        .onAppear() {commentData.fetchData(id: id, selectedSchool: selectedSchool)
//            print(commentData.comments)
//        }
//        
//        .onTapGesture {
//            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//        }
//        
//            
//            
//            
//            
//        .navigationBarTitle(Text(""), displayMode: .inline)//.border(Color.black)
////            .navigationBarBackButtonHidden(true)
////            .navigationBarItems(leading: Button(action: {
////                    self.presentationMode.wrappedValue.dismiss()
////                    }, label: {
////                    Image(systemName: "chevron.left").foregroundColor(.black)
////                    }))
//            .toolbar{
//                ToolbarItem(placement: .principal) {
//                    Image("tiger")
//                        .resizable()
//                        .frame(width: 30, height: 30)
//                        .aspectRatio(contentMode: .fill)
//                }
//                
//                
//            }
//            .navigationBarColor(UIColor(Color.customOrange))
//        // .navigationBarItems(trailing: Image("tiger").resizable()
//                                    //.frame(width: 20.0, height: 10)
//        //.aspectRatio(contentMode: .fill)).padding(.trailing, 100)
//        
//
//    }
//
//}
//
//
//
////struct CommentView_Previews: PreviewProvider {
////    static var previews: some View {
////        CommentView()
////    }
////}
//
