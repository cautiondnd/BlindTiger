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
//class ProfileViewModel: ObservableObject {
//    @Published var userPosts = [post]()
//    @Published var profinfo = profileInfo(fullname: "", username: "", imageurl: "")
//    @Published var initialLoading = true
//    @Published var numberOfPostsLoaded = 30
//    //for changing prof picture
//    @Published var showImagePicker = false
//    @Published var imgData = Data(count: 0)
//    @Published var fullNameEdit = ""
//    @Published var usernameEdit = ""
//    @Published var showValidationAlert = false
//    
//
//
//    
// //   @Published var newCommentContent = ""
// //   var id: String
//
//    let db = Firestore.firestore()
//    func fetchData(userID: String) {
//        db.collection("BlindTiger").document("\(cleanSchool)").collection("posts").whereField("authoruid", isEqualTo: userID).getDocuments { (querySnapshot, error) in
//            //make sure something is in posts
//            guard let documents = querySnapshot?.documents else{
//                print("no documents")
//                return
//            }
//            //author uid might be unneseceray
//            // map data to a post struct
//            self.userPosts = documents.map { (queryDocumentSnapshot) -> post in
//                let data = queryDocumentSnapshot.data()
//
//                let content = data["content"] as? String ?? ""
//                let authoruid = data["authoruid"] as? String ?? ""
//                let time = data["time"] as! Timestamp
//                let anonymous = data["anonymous"] as? Bool ?? true
//                let votes = data["votes"] as? Int ?? 0
//                let id = data["id"] as? String ?? ""
//                let autherusername = data["authorusername"] as? String ?? ""
//                let reports = data["reports"] as? Int ?? 0
//
//                return post(id: id, content: content, votes: votes, time: time, authoruid: authoruid, anonymous: anonymous, authorusername: autherusername, reports: reports)
//
//            }
//            self.initialLoading = false
//
//        }
//        
//    }
//    
//    func fetchProfileData(userID: String) {
//        db.collection("BlindTiger").document("\(cleanSchool)").collection("users").document(userID).getDocument(completion: { (document, Err) in
//            guard let user = document else{return}
//            
//            let username = user.data()?["username"] as! String
//            let fullname = user.data()?["fullname"] as! String
//            let imageurl = user.data()?["imageurl"] as? String ?? ""
//
//            return self.profinfo = profileInfo(fullname: fullname, username: username, imageurl: imageurl)
//                }
//        
//       )}
//    
//    func updateInfo() {
//        let uid = Auth.auth().currentUser!.uid
//        
//        if self.fullNameEdit.trimmingCharacters(in: .whitespacesAndNewlines) == "" {self.fullNameEdit = self.profinfo.fullname}
//        if self.usernameEdit.trimmingCharacters(in: .whitespacesAndNewlines) != "" && (self.usernameEdit.count < 6 || self.usernameEdit.count > 20)  {self.usernameEdit = self.profinfo.username; showValidationAlert = true}
//        if self.usernameEdit.trimmingCharacters(in: .whitespacesAndNewlines) == "" {self.usernameEdit = self.profinfo.username}
//
//        
//        db.collection("BlindTiger").document(cleanSchool).collection("users").document(uid).updateData([
//            
//            "fullname": fullNameEdit,
//            "username": usernameEdit
//        ]) { (err) in
//            if err != nil{return}
//            
//            // Updating View..
//         self.fetchProfileData(userID: uid)
//            }
//        fullNameEdit = ""
//        usernameEdit = ""
//    }
//    
//    func updateImage(){
//     
//           UploadImage(imageData: imgData) { (url) in
//            let uid = Auth.auth().currentUser!.uid
//               
//           
//            
//            self.db.collection("BlindTiger").document(cleanSchool).collection("users").document(uid).updateData([
//               
//                   "imageurl": url,
//               ]) { (err) in
//                   if err != nil{return}
//                   
//                   // Updating View..
//                self.fetchProfileData(userID: uid)
//                   }
//               }
//           }
//       
//    
//        
//}
//
//struct profileCardView: View {
//    var content: String
//    var votes: Int
//    var time: Timestamp
//    var authoruid: String
//    var anonymous: Bool
//    var id: String
//    var authorusername: String
//    var reports: Int
//    @State var numberOfComments = 0
//   // @State var upvote: Bool
//   // @State var downvote: Bool
//    @State var reported: Bool
//    @State var goComment = false
//    @State var goProfile = false
//    @State var showReportPopUp = false
//    @State var showDeleteAlert = false
//    @State var cameFromSecondaryView: Bool
//    @Binding var blockedUsers: [String]
//    
//    var body: some View {
//        
//        let date = time.dateValue()
//        
//        ZStack{
//            VStack{
//                HStack{
//                    if anonymous == true {
//                        Text("Anonymous").foregroundColor(.gray).lineLimit(1)}
//                    else{
//                        //  if authoruid == Auth.auth().currentUser?.uid
//                        // {Text("\(authorusername) ◦").foregroundColor(.gray)}
//                        //  else{
//                        Text("\(authorusername.trimmingCharacters(in: .whitespacesAndNewlines))").lineLimit(1).foregroundColor(.gray)
//                        
//                    }
//                    Text("◦ \(date.timeAgoDisplay())").foregroundColor(.gray).layoutPriority(0.9)
//                    Spacer()
//                    Button(action: {showReportPopUp.toggle()}, label: {
//                        Image(systemName: "ellipsis").offset(y: -10).foregroundColor(.gray).padding(7)//.padding([.top, .horizontal])
//                    })
//                   
//                }.padding(.bottom, 5.0)
//                HStack{
//                    Text(content).fixedSize(horizontal: false, vertical: true).layoutPriority(1).font(.title3).padding(.vertical).padding(.trailing, 1)
//                    Spacer()
//                    VStack{
//                       
//                        
//                        Text("\(votes)").font(.title).padding(.trailing, 5.0).lineLimit(1).allowsTightening(true)
//                        
//                        
//                        
//                    }
//                }
//                HStack{
//                    Text("\(numberOfComments)")
//
//                                        
//                    Button(action: {
//                        
//                        goComment = true
//                        
//                    },
//                    label: {Image(systemName: "bubble.right").foregroundColor(.gray)})
//
//                    NavigationLink(destination: CommentView(cameFromSecondaryView: cameFromSecondaryView, content: content, votes: votes, time: time, authoruid: authoruid, anonymous: anonymous, id: id, authorusername: authorusername, blockedUsers: $blockedUsers), isActive: $goComment) {
//                        EmptyView()}
//                    
//                    Spacer()
//                }.padding(.top, 5)
//            }
//            .padding()
//            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white).shadow(color: Color.black.opacity(0.15), radius: 6)).padding(.horizontal).padding(.vertical, 5)
//            
//            if showReportPopUp == true {
//                
//                if authoruid == Auth.auth().currentUser?.uid {
//                ZStack {
//                    Color.white
//                    VStack(spacing: 0) {
//                        
//                        Button(action: {
//                            showDeleteAlert = true
//                            
//                        }, label: {
//                           
//                                Text("Delete").foregroundColor(.red).fontWeight(.semibold)
//                             .frame(width: 300.0, height: 75)
//                            .padding(.horizontal)
//                        })
//                        
//                            
//                        
//                        
//                        
//                        
//                        
//                        ZStack{
//                        Button(action: {
//                            showReportPopUp = false
//                        }, label: {
//                            Text("Close").foregroundColor(.blue).frame(width: 300.0, height: 50.0)
//                        })
//                            Rectangle().foregroundColor(.gray).frame(height: 1).offset(y: -25).opacity(0.5)
//                        }
//                        
//                        
//                    }
//                }
//                .frame(width: 300, height: 125)
//                .cornerRadius(20).shadow(radius: 20)
//            }
//                //not my own post (no delete)
//                else{
//                    ZStack {
//                        Color.white
//                        VStack(spacing: 0) {
//                                                        
//                            
//                            Button(action: {reported.toggle();
//                                UserDefaults.standard.set(reported, forKey: "\(id)reported");
//                                if reported == true {db.collection("BlindTiger").document(cleanSchool).collection("posts").document(id).updateData(["reports" : FieldValue.increment(Int64(1))])}
//                                else {
//                                    db.collection("BlindTiger").document(cleanSchool).collection("posts").document(id).updateData(["reports" : FieldValue.increment(Int64(-1))])
//                                }
//                                
//                            }, label: {
//                                HStack{
//                                    Text("Report").foregroundColor(.red).fontWeight(.semibold)
//                                    Spacer()
//                                    if reported == true {
//                                        Image(systemName: "checkmark.square").foregroundColor(.red).font(.title2)
//                                    }
//                                    else{
//                                        Image(systemName: "square").foregroundColor(.red).font(.title2)
//                                    }
//                                    
//                                }.padding(.horizontal)
//                                .frame(width: 300.0, height: 75)
//                            })
//                            
//                            ZStack{
//                            Button(action: {
//                                showReportPopUp = false
//                            }, label: {
//                             
//                                    Text("Close").foregroundColor(.blue).frame(width: 300.0, height: 50)
//                                    
//                            })
//                                Rectangle().foregroundColor(.gray).frame(height: 1).offset(y: -25).opacity(0.5)
//                            }
//                            
//                            
//                        }
//                    }
//                    .frame(width: 300, height: 125)
//                    .cornerRadius(20).shadow(radius: 20)
//                }
//            }
//        }.alert(isPresented: $showDeleteAlert, content: {
//                    Alert(title: Text("Delete Post?"), message: Text("There is no way to recover a post once deleted."), primaryButton: .default(Text("Cancel")) {showReportPopUp = false}, secondaryButton: .destructive(Text("Delete")) {db.collection("BlindTiger").document(cleanSchool).collection("posts").document(id).delete()} )})
//        .onAppear() {
//            db.collection("BlindTiger").document(cleanSchool).collection("posts").document(id).collection("comments").getDocuments
//        {(querySnapshot, err) in
//
//             if let err = err {print("Error getting documents: \(err)");}
//             else{
//                return self.numberOfComments = querySnapshot!.count
//             }
//         }}
//        
//    }
//}
//
//
//struct profileInfo {
//    var fullname: String
//    var username: String
//    var imageurl: String
//}
//
