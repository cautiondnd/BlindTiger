////
////  NotificationViewModel.swift
////  BlindTiger
////
////  Created by dante  delgado on 12/7/20.
////
//
////
////  ProfileViewModel.swift
////  BlindTiger
////
////  Created by dante  delgado on 11/29/20.
////
//
//import SwiftUI
//import Firebase
//
//class NotificationViewModel: ObservableObject {
//    @Published var newCommentsOnPost: Set = Set<notificationCard>()
//    @Published var userPosts = [post]()
//    @Published var initialLoading = true
//    
//
//
//    
//    
//    func fetchNotificationData() {
//        let userID = Auth.auth().currentUser?.uid
//        db.collection("BlindTiger").document("\(cleanSchool)").collection("posts").whereField("authoruid", isEqualTo: userID!).getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                //create an array with all of users posts
//                guard let documents = querySnapshot?.documents else{
//                    print("no documents")
//                    return}
//                self.userPosts = documents.map { (queryDocumentSnapshot) -> post in
//                    let data = queryDocumentSnapshot.data()
//                    let content = data["content"] as? String ?? ""
//                    let authoruid = data["authoruid"] as? String ?? ""
//                    let time = data["time"] as! Timestamp
//                    let anonymous = data["anonymous"] as? Bool ?? true
//                    let votes = data["votes"] as? Int ?? 0
//                    let id = data["id"] as? String ?? ""
//                    let autherusername = data["authorusername"] as? String ?? ""
//                    let reports = data["reports"] as? Int ?? 0
//                    
//                    return post(id: id, content: content, votes: votes, time: time, authoruid: authoruid, anonymous: anonymous, authorusername: autherusername, reports: reports)
//                    
//                }
//                
//                
//                
//                //create a set with only the ids of all the user posts
//                var ids = [String]()
//                for document in querySnapshot!.documents {
//                    ids.append(document.documentID)
//                }
//                //add all new comments to the new comments set
//                for postsid in ids {
//                    db.collection("BlindTiger").document("\(cleanSchool)").collection("posts").document(postsid).collection("comments").getDocuments() { (querySnapshot, error) in
//                        //make sure something is in posts
//                        guard let documents = querySnapshot?.documents else{
//                            print("no documents")
//                            return
//                        }
//                        // map data to a post struct (combine these comments with empty set)
//                        self.newCommentsOnPost.formUnion(
//                            documents.map { (queryDocumentSnapshot) -> notificationCard in
//                            let data = queryDocumentSnapshot.data()
//                            
//                                // dont need reports or votes
//                            let content = data["content"] as? String ?? ""
//                            let authoruid = data["authoruid"] as? String ?? ""
//                            let time = data["time"] as! Timestamp
//                            let anonymous = data["anonymous"] as? Bool ?? true
//                            let commentid = data["commentid"] as? String ?? ""
//                            let postid = data["postid"] as? String ?? ""
//                            let authorusername = data["authorusername"] as? String ?? ""
//                       
//                                return notificationCard(id: commentid, postid: postid, content: content, authorusername: authorusername, time: time, authoruid: authoruid, anonymous: anonymous)
//                                
//                            })
//                    }
//
//                }
//            }
//            self.initialLoading = false
//    }
//}
//    
//    @Published var loading: Bool = false {
//            
//            didSet {
//                if oldValue == false && loading == true {
//                    self.load()
//                }
//            }
//        }
//    
//    func load() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
//                   
//            self.fetchNotificationData();
//                   
//                   self.loading = false
//                   
//                  
//               }
//    }
//    
//    
//}
//
//struct notificationCard: Hashable, Identifiable {
//    var id: String
//    var postid: String
//    var content: String
//    var authorusername: String
//    var time: Timestamp
//    var authoruid: String
//    var anonymous: Bool
//    
//}
//
//struct NotificationCard: View {
//    var authorusername: String
//    var anonymous: Bool
//    var time: Timestamp
//    
//    var content: String
//   // var votes: Int
//    var authoruid: String
//    var postid: String
//    @State var goComment = false
//    //var bgColor: Color
//    var body: some View {
//        
//       
//            VStack{
//                Spacer()
//                HStack(spacing: 0){
//                    
//                        if anonymous == false {
//                        Text("\(authorusername.trimmingCharacters(in: .whitespacesAndNewlines))").font(.callout).fontWeight(.medium).lineLimit(1)
//                            .padding(.leading)
//                            .foregroundColor(.black)
//                        }
//                        else {
//                            Text("Anonymous").font(.callout).fontWeight(.medium).italic()
//                                .padding(.leading)
//                                .foregroundColor(.black)
//                                .lineLimit(1)
//
//                        }
//                    Text("commented on your post").font(.callout).fontWeight(.medium)
//                        .padding(.leading)
//                        .foregroundColor(.black)
//                        .lineLimit(1)
//                        .layoutPriority(1)
//                        .offset(x: -12)
//                    
//
//                
//                    
//                    Spacer()
//                }
//                Spacer()
//            }.frame(maxWidth: .infinity, idealHeight: 60)
//            .background(Rectangle().foregroundColor(.white))
//        
//        
//    }
//}
//
//struct NotificationListView: View {
//    var oneDayOldNewComments: Set<notificationCard>
//    var oneWeekOldNewComments: Set<notificationCard>
//    var OlderNewComments: Set<notificationCard>
//    var userPosts: [post]
//    @State var goComment = false
//    @State var selectedUserPost: post = post(id: "", content: "Post was deleted.", votes: 0, time: Timestamp.init() , authoruid: "", anonymous: false, authorusername: "", reports: 0)
//    @Binding var blockedUsers: [String]
//    var body: some View {
//        
//        if !oneDayOldNewComments.isEmpty {
//    VStack(alignment: HorizontalAlignment.leading,spacing: 0){
//        
//        
//        ZStack(alignment: Alignment.leading) {
//            Rectangle().foregroundColor(.customOrange)
//            Text("Today")
//                .font(.headline)
//                .fontWeight(.semibold).foregroundColor(Color.orange).padding()
//                .padding(.leading)
//                .background(RoundedRectangle(cornerRadius: 20).foregroundColor(.white).padding(.leading)).offset(y: 16)
//        }
//                                
//        ForEach(oneDayOldNewComments.sorted(by: { $0.time.seconds > $1.time.seconds })) {notificationPost in
//                Button(action: {
//                    goComment = true
//                    selectedUserPost = userPosts.first(where: { $0.id == notificationPost.postid}) ?? post(id: "", content: "Post was deleted.", votes: 0, time: Timestamp.init() , authoruid: "", anonymous: false, authorusername: "", reports: 0)
//
//                    }
//                    
//                ,
//                       label: {
//                        NotificationCard(authorusername: notificationPost.authorusername, anonymous: notificationPost.anonymous, time: notificationPost.time, content: notificationPost.content, authoruid: notificationPost.authoruid, postid: notificationPost.postid)
//                       })
//               
//                
//                
//            
//        }
//       
//        
//    }.background(Rectangle().foregroundColor(.customGray).shadow(color: Color.black.opacity(0.10), radius: 4, y: 9).padding(.top))
//        }
//        else {EmptyView()}
//        
//        if !oneWeekOldNewComments.isEmpty{
//            VStack(alignment: HorizontalAlignment.leading,spacing: 0){
//                
//                
//                ZStack(alignment: Alignment.leading) {
//                    if oneDayOldNewComments.isEmpty{ Rectangle().foregroundColor(.customOrange)}
//                    Text("This Week")
//                        .font(.headline)
//                        .fontWeight(.semibold).foregroundColor(Color.orange).padding()
//                        .padding(.leading)
//                        .background(RoundedRectangle(cornerRadius: 20).foregroundColor(.white).padding(.leading)).offset(y: 16)
//                }
//                                        
//                ForEach(oneWeekOldNewComments.sorted(by: { $0.time.seconds > $1.time.seconds })) {notificationPost in
//                        Button(action: {
//                            goComment = true
//                            selectedUserPost = userPosts.first(where: { $0.id == notificationPost.postid}) ?? post(id: "", content: "Post was deleted.", votes: 0, time: Timestamp.init() , authoruid: "", anonymous: false, authorusername: "", reports: 0)
//
//                            }
//                            
//                        ,
//                               label: {
//                                NotificationCard(authorusername: notificationPost.authorusername, anonymous: notificationPost.anonymous, time: notificationPost.time, content: notificationPost.content, authoruid: notificationPost.authoruid, postid: notificationPost.postid)
//                               })
//                       
//                        
//                        
//                    
//                }
//               
//                
//            }.background(Rectangle().foregroundColor(.customGray).shadow(color: Color.black.opacity(0.10), radius: 4, y: 9).padding(.top))
//        }
//        else {EmptyView()}
//        if !OlderNewComments.isEmpty{
//            VStack(alignment: HorizontalAlignment.leading,spacing: 0){
//                
//                
//                ZStack(alignment: Alignment.leading) {
//                    if oneWeekOldNewComments.isEmpty && oneDayOldNewComments.isEmpty{ Rectangle().foregroundColor(.customOrange)}
//                    Text("Older")
//                        .font(.headline)
//                        .fontWeight(.semibold).foregroundColor(Color.orange).padding()
//                        .padding(.leading)
//                        .background(RoundedRectangle(cornerRadius: 20).foregroundColor(.white).padding(.leading)).offset(y: 16)
//                }
//                                        
//                ForEach(OlderNewComments.sorted(by: { $0.time.seconds > $1.time.seconds })) {notificationPost in
//                        Button(action: {
//                            goComment = true
//                            selectedUserPost = userPosts.first(where: { $0.id == notificationPost.postid}) ?? post(id: "", content: "Post was deleted.", votes: 0, time: Timestamp.init() , authoruid: "", anonymous: false, authorusername: "", reports: 0)
//
//                            }
//                            
//                        ,
//                               label: {
//                                NotificationCard(authorusername: notificationPost.authorusername, anonymous: notificationPost.anonymous, time: notificationPost.time, content: notificationPost.content, authoruid: notificationPost.authoruid, postid: notificationPost.postid)
//                               })
//                       
//                        
//                        
//                    
//                }
//               
//                
//            }.background(Rectangle().foregroundColor(.customGray).shadow(color: Color.black.opacity(0.10), radius: 4, y: 9).padding(.top))
//        }
//        else{EmptyView()}
//        Spacer()
//        Spacer()
//    
//        
//
//    if selectedUserPost.id == "" {
//        //alert 'post was deleted'
//    }
//    else {
//        NavigationLink(destination: CommentView(content: selectedUserPost.content, votes: selectedUserPost.votes, time: selectedUserPost.time, authoruid: selectedUserPost.authoruid, anonymous: selectedUserPost.anonymous, id: selectedUserPost.id, authorusername: selectedUserPost.authorusername, blockedUsers: $blockedUsers), isActive: $goComment) {
//        EmptyView()}
//        
//        
//   
//    }
//}
//   
//
//
//
//
//
//}
////struct postIDs {
////    var id: String
////}
