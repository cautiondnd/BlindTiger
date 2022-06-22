////
////  CommentViewModel.swift
////  BlindTiger
////
////  Created by dante  delgado on 11/22/20.
////
//
//import SwiftUI
//import Firebase
//
//// Adding new comment breaks it
//// adds hella duplicates everytime it runs
//class commentViewModel: ObservableObject {
//    @Published var comments = [comment]()
//    @Published var newCommentContent = ""
//    @Published var isAnonymous = true
//    @Published var initialLoading = true
//    @Published var uploadingComment = false
//    
//    
//    //var id: String
//    // for some reason this gets called twice when done from navigation but only once from tabbar. thats why it doesnt work (idk a fix)
//    let db = Firestore.firestore()
//    func fetchData(id: String, selectedSchool: String) {
//        db.collection("BlindTiger").document("\(selectedSchool)").collection("posts").document(id).collection("comments").addSnapshotListener() { (querySnapshot, error) in
//            //make sure something is in posts
//            guard let documents = querySnapshot?.documents else{
//                print("no documents")
//                return
//            }
//            //author uid might be unneseceray
//            // map data to a post struct
//            self.comments = documents.map { (queryDocumentSnapshot) -> comment in
//                let data = queryDocumentSnapshot.data()
//                
//                let content = data["content"] as? String ?? ""
//                let authoruid = data["authoruid"] as? String ?? ""
//                let time = data["time"] as! Timestamp
//                let anonymous = data["anonymous"] as? Bool ?? true
//                let votes = data["votes"] as? Int ?? 0
//                let commentid = data["commentid"] as? String ?? ""
//                let postid = data["postid"] as? String ?? ""
//                let autherusername = data["authorusername"] as? String ?? ""
//                let reports = data["reports"] as? Int ?? 0
//                
//                if reports >= 5 {
//                    self.db.collection("BlindTiger").document(selectedSchool).collection("posts").document(postid).collection("comments").document(commentid).delete()
//                }
//                
//                return comment(id: commentid, postid: postid, content: content, votes: votes, time: time, authoruid: authoruid, anonymous: anonymous, authorusername: autherusername, reports: reports)
//                
//            }
//            self.initialLoading = false
//        }
//        
//      
//        
//    }
//    
//    
//    func newComment(id: String) {
//       //TODO: make it so that you can only press the button once every 2 seconds
//        //make sure something is written and its less than 240 charecters
//        if newCommentContent.trimmingCharacters(in: .whitespacesAndNewlines) == "" || newCommentContent.count > 240 {
//            //no text or too much text
//        }
//        else {
//            uploadingComment = true
//            let uid = Auth.auth().currentUser!.uid
//            
//            
//            db.collection("BlindTiger").document(cleanSchool).collection("users").document(uid).getDocument { [self] (document, error) in
//                //if user exists and has a username go onto making the post
//                if let document = document, document.exists {
//                    
//                    let authorusername = document.get("username") as! String
//                    
//                    
//                    
//                    //create new post and pass in data
//                    // make anonymous button
//                    let userPost = db.collection("BlindTiger").document(cleanSchool).collection("posts").document(id).collection("comments").addDocument(data: ["content" : newCommentContent.trimmingCharacters(in: .whitespacesAndNewlines), "authoruid" : uid, "votes" : 0, "anonymous" : isAnonymous, "reports" : 0, "time" : Date(), "authorusername" : authorusername, "postid" : id]) { (err) in
//                        if err != nil {
//                            //showerror or something
//                            //self.dbErr = true
//                            print(LocalizedError.self)
//                        }
//                        else{
//                            newCommentContent = ""
//                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                            
//                        }
//                        
//                    }
//                    //add document id as a field
//                    let userPostID = userPost.documentID
//                    db.collection("BlindTiger").document(cleanSchool).collection("posts").document(id).collection("comments").document(userPostID).setData(["commentid" : userPostID], merge: true)
//                    
//                    
//                    
//                    
//                }
//               
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){
//                self.uploadingComment = false}
//        }
//    
//    }
//    
//    
//}
//
//
//
//
//
//struct commentCardView: View {
//    let content: String
//    @State var votes: Int
//    let time: Timestamp
//    let authoruid: String
//    let anonymous: Bool
//    let postid: String
//    let commentid: String
//    let authorusername: String
//    @State var upvote: Bool
//    @State var downvote: Bool
//    @State var goProfile = false
//    var reports: Int
//    @State var reported: Bool
//    @State var showReportPopUp = false
//    @State var showDeleteAlert = false
//    @State var showBlockAlert = false
//    @Binding var blockedUsers: [String]
//    
//    var body: some View {
//        
//        let date = time.dateValue()
//        
//        
//        
//        
//        ZStack{
//            VStack{
//                HStack{
//                    if anonymous == true {
//                        Text("Anonymous").foregroundColor(.gray).lineLimit(1)}
//                    else{
//                        Button(action: {
//                            goProfile = true
//                        },
//                        label: {Text("\(authorusername.trimmingCharacters(in: .whitespacesAndNewlines)) ").lineLimit(1)})
//                        NavigationLink(destination: NotSelfProfileView(userID: authoruid, cameFromSecondaryView: true, blockedUsers: $blockedUsers), isActive: $goProfile) {
//                            EmptyView()}
//                        
//                    }
//                    Text("◦ \(date.timeAgoDisplay())").foregroundColor(.gray).layoutPriority(0.9)
//                    Spacer()
//                    Button(action: {showReportPopUp = true}, label: {
//                            Image(systemName: "ellipsis").offset(y: -10).foregroundColor(.gray).padding(7)})
//                    
//                    
//                }.padding(.bottom, 5.0)
//                HStack{
//                    Text(content).fixedSize(horizontal: false, vertical: true).layoutPriority(1).font(.title3).padding(.trailing, 1)
//                    Spacer()
//                    VStack{
//                        Button(action: {
//                            //change so that there is only votes and not upvotes and downvotes
//                            upvote.toggle();
//                            UserDefaults.standard.set(self.upvote, forKey: "\(commentid)upvoted");
//                            UserDefaults.standard.set(false, forKey: "\(commentid)downvoted")
//                            if upvote == true {
//                                if downvote == true {
//                                    downvote = false
//                                    db.collection("BlindTiger").document(cleanSchool).collection("posts").document(postid).collection("comments").document(commentid).updateData(["votes" : FieldValue.increment(Int64(2))])
//                                    votes += 2
//                                }
//                                else {
//                                    db.collection("BlindTiger").document(cleanSchool).collection("posts").document(postid).collection("comments").document(commentid).updateData(["votes" : FieldValue.increment(Int64(1))])
//                                    votes += 1
//                                }
//                            }
//                            else {
////FOR TESTING: com out
//                                db.collection("BlindTiger").document(cleanSchool).collection("posts").document(postid).collection("comments").document(commentid).updateData(["votes" : FieldValue.increment(Int64(-1))])
//                                votes -= 1
//                            }
//                        }, label: {
//                            Image(systemName: "chevron.up")
//                                .foregroundColor(upvote == true ? .orange : .gray)
//                                .font(.title).padding([.top, .bottom, .trailing], 5.0)
//                        })
//                        
//                        Text("\(votes)").font(.title).padding(.trailing, 5.0).lineLimit(1).allowsTightening(true)
//                        Button(action: {
//                            
//                            
//                            downvote.toggle();
//                            UserDefaults.standard.set(self.downvote, forKey: "\(commentid)downvoted");
//                            UserDefaults.standard.set(false, forKey: "\(commentid)upvoted")
//                            if downvote == true {
//                                if upvote == true {
//                                    upvote = false
//                                    db.collection("BlindTiger").document(cleanSchool).collection("posts").document(postid).collection("comments").document(commentid).updateData(["votes" : FieldValue.increment(Int64(-2))])
//                                    votes -= 2
//                                }
//                                else {
//                                    db.collection("BlindTiger").document(cleanSchool).collection("posts").document(postid).collection("comments").document(commentid).updateData(["votes" : FieldValue.increment(Int64(-1))])
//                                    votes -= 1
//                                }
//                            }
//                            else {
////FOR TESTING: com out
//                                db.collection("BlindTiger").document(cleanSchool).collection("posts").document(postid).collection("comments").document(commentid).updateData(["votes" : FieldValue.increment(Int64(1))])
//                                votes += 1
//                            }
//                        }, label: {
//                            Image(systemName: "chevron.down")
//                                .foregroundColor(downvote == true ? .orange : .gray)
//                                .font(.title).padding([.top, .bottom, .trailing], 5.0)
//                        })
//                        
//                        
//                        
//                    }
//                }
//                
//            }
//            .padding()
//            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white).shadow(color: Color.black.opacity(0.15), radius: 6)).padding(.horizontal).padding(.vertical, 5)
//            
//            if showReportPopUp == true {
//                
//                if authoruid == Auth.auth().currentUser?.uid {
//                    ZStack {
//                        Color.white
//                        VStack(spacing: 0) {
//                            
//                            Button(action: {
//                                showDeleteAlert = true
//                                
//                            }, label: {
//                                
//                                Text("Delete").foregroundColor(.red).fontWeight(.semibold)
//                                    .frame(width: 300.0, height: 75)
//                                    .padding(.horizontal)
//                            })
//                            
//                            
//                            
//                            
//                            
//                            
//                            
//                            ZStack{
//                                Button(action: {
//                                    showReportPopUp = false
//                                }, label: {
//                                    Text("Close").foregroundColor(.blue).frame(width: 300.0, height: 50.0)
//                                })
//                                Rectangle().foregroundColor(.gray).frame(height: 1).offset(y: -25).opacity(0.5)
//                            }
//                            
//                            
//                        }
//                    }.alert(isPresented: $showDeleteAlert, content: {
//                                Alert(title: Text("Delete Post?"), message: Text("There is no way to recover a post once deleted."), primaryButton: .default(Text("Cancel")) {showReportPopUp = false}, secondaryButton: .destructive(Text("Delete")) {db.collection("BlindTiger").document(cleanSchool).collection("posts").document(postid).collection("comments").document(commentid).delete()} )})
//                    .frame(width: 300, height: 125)
//                    .cornerRadius(20).shadow(radius: 20)
//                }
//                //not my own post (no delete)
//                else{
//                    ZStack {
//                        Color.white
//                        VStack(spacing: 0) {
//                            
//                            
//                            Button(action: {reported.toggle();
//                                UserDefaults.standard.set(reported, forKey: "\(commentid)reported");
//                                if reported == true {db.collection("BlindTiger").document(cleanSchool).collection("posts").document(postid).collection("comments").document(commentid).updateData(["reports" : FieldValue.increment(Int64(1))])}
//                                else {
//                                    db.collection("BlindTiger").document(cleanSchool).collection("posts").document(postid).collection("comments").document(commentid).updateData(["reports" : FieldValue.increment(Int64(-1))])
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
//                                .frame(width: 300.0, height: 50)
//                            })
//                            
//                            
//                            Button(action: {
////
//                                showBlockAlert = true
//                               
//                            }, label: {
//                                HStack{
//
//                                        Text("Block User").foregroundColor(.black).padding(.horizontal)//}
//                    
//                                    Spacer()
//                                }
//                            }).frame(width: 300.0, height: 50)
//                            
//                            ZStack{
//                                Button(action: {
//                                    showReportPopUp = false
//                                }, label: {
//                                    
//                                    Text("Close").foregroundColor(.blue).frame(width: 300.0, height: 50)
//                                    
//                                })
//                                Rectangle().foregroundColor(.gray).frame(height: 1).offset(y: -25).opacity(0.5)
//                            }
//                            
//                            
//                        }
//                    }.alert(isPresented: $showBlockAlert, content: {
//                                Alert(title: Text("Block User?"), message: Text("Are you sure you want to block this user?"), primaryButton: .default(Text("Cancel")) {showReportPopUp = false}, secondaryButton: .destructive(Text("Block")) {blockedUsers.append(authoruid)
//                                        UserDefaults.standard.set(blockedUsers, forKey: "blockedUsers")
//                                        showReportPopUp = false })})
//                    .frame(width: 300, height: 150)
//                    .cornerRadius(20).shadow(radius: 20)
//                }
//            }
//        }
//        
//        
//        .onDisappear(){
//            upvote = UserDefaults.standard.bool(forKey: "\(commentid)upvoted");
//            downvote = UserDefaults.standard.bool(forKey: "\(commentid)downvoted");
//            reported = UserDefaults.standard.bool(forKey: "\(commentid)reported");
//            
//        }
//    }
//}
//
////struct comment: Identifiable, Hashable {
////    var id: String
////    var postid: String
////    var content: String
////    var votes: Int
////    var time: Timestamp
////    var authoruid: String
////    var anonymous: Bool
////    var authorusername : String
////    var reports : Int
////}
//
//
//
//struct cardCommentedOn: View {
//    var content: String
//    var votes: Int
//    var time: Timestamp
//    var authoruid: String
//    var anonymous: Bool
//    var id: String
//    var authorusername: String
//    @State var goHome = false
//    @State var selectedTab = 0
//    @State var goProfile = false
//    @Binding var blockedUsers: [String]
//    
//    //    var reports: Double
//    //    @State var reported: Bool
//    //    @State var showReportPopUp = false
//    //    @State var showDeleteAlert = false
//    
//    var body: some View {
//        let date = time.dateValue()
//        
//        ZStack{
//            VStack{
//                HStack{
//                    if anonymous == true {
//                        Text("Anonymous").foregroundColor(.gray).lineLimit(1)}
//                    else{
//                        Button(action: {
//                            goProfile = true
//                        },
//                        label: {Text("\(authorusername.trimmingCharacters(in: .whitespacesAndNewlines)) ").lineLimit(1).foregroundColor(.orange)})
//                        NavigationLink(destination: NotSelfProfileView(userID: authoruid, cameFromSecondaryView: true, blockedUsers: $blockedUsers), isActive: $goProfile) {
//                            EmptyView()}
//                    }
//                    
//                    
//                    Text("◦ \(date.timeAgoDisplay())").foregroundColor(.gray).layoutPriority(0.9)
//                    Spacer()
//                    //                    Button(action: {showReportPopUp.toggle()}, label: {
//                    //                        Image(systemName: "ellipsis").padding([.leading]).foregroundColor(.gray)//.offset(y: -10)
//                    //
//                    //                    })
//                    
//                }.padding(.bottom, 5.0)
//                HStack{
//                    Text(content).fixedSize(horizontal: false, vertical: true).layoutPriority(1).font(.title3).padding(.vertical).padding(.trailing, 1)
//                    Spacer()
//                    
//                }
//            }
//            .padding()
//            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white)).padding(.horizontal).padding(.vertical, 5)
//            
//            // to add reports to card commented on
//            //            if showReportPopUp == true {
//            //
//            //                if authoruid == Auth.auth().currentUser?.uid {
//            //                ZStack {
//            //                    Color.white
//            //                    VStack(spacing: 0) {
//            //                        ZStack{
//            //                        Button(action: {
//            //                            showDeleteAlert = true
//            //
//            //                        }, label: {
//            //
//            //                                Text("Delete").foregroundColor(.red).fontWeight(.semibold)
//            //                              .frame(width: 300.0, height: 75)
//            //                        })
//            //
//            //
//            //                        }
//            //
//            //
//            //
//            //
//            //                        ZStack{
//            //                        Button(action: {
//            //                            showReportPopUp = false
//            //                        }, label: {
//            //                            Text("Close").frame(width: 300.0, height: 50)
//            //                        })
//            //                            Rectangle().foregroundColor(.gray).frame(height: 1).offset(y: -25).opacity(0.5)
//            //                        }
//            //
//            //
//            //                    }
//            //                }
//            //                .frame(width: 300, height: 125)
//            //                .cornerRadius(20).shadow(radius: 20)
//            //            }
//            //                //not my own post (no delete)
//            //                else{
//            //                    ZStack {
//            //                        Color.white
//            //                        VStack(spacing: 0) {
//            //
//            //
//            //                            Button(action: {reported.toggle();
//            //                                UserDefaults.standard.set(self.reported, forKey: "\(id)reported");
//            //                                if reported == true {db.collection("BlindTiger").document(cleanSchool).collection("posts").document(id).updateData(["reports" : reports + 1])}
//            //                                else {
//            //                                    db.collection("BlindTiger").document(cleanSchool).collection("posts").document(id).updateData(["reports" : reports - 1])
//            //                                }
//            //
//            //                            }, label: {
//            //                                HStack{
//            //                                    Text("Report").foregroundColor(.red).fontWeight(.semibold)
//            //                                    Spacer()
//            //                                    if reported == true {
//            //                                        Image(systemName: "checkmark.square").foregroundColor(.red).font(.title2)
//            //                                    }
//            //                                    else{
//            //                                        Image(systemName: "square").foregroundColor(.red).font(.title2)
//            //                                    }
//            //
//            //                                }.padding(.horizontal)
//            //                                .frame(width: 300.0, height: 75)
//            //                            })
//            //
//            //                            ZStack{
//            //                            Button(action: {
//            //                                showReportPopUp = false
//            //                            }, label: {
//            //
//            //                                    Text("Close").frame(width: 300.0, height: 50)
//            //
//            //                            })
//            //                                Rectangle().foregroundColor(.gray).frame(height: 1).offset(y: -25).opacity(0.5)
//            //                            }
//            //
//            //
//            //                        }
//            //                    }
//            //                    .frame(width: 300, height: 125)
//            //                    .cornerRadius(20).shadow(radius: 20)
//            //                }
//            //            }
//            //        }.alert(isPresented: $showDeleteAlert, content: {
//            //                    Alert(title: Text("Delete Post?"), message: Text("There is no way to recover a post once deleted."), primaryButton: .default(Text("Cancel")) {showReportPopUp = false}, secondaryButton: .destructive(Text("Delete")) {db.collection("BlindTiger").document(cleanSchool).collection("posts").document(id).delete(); goHome = true} )})
//            //        NavigationLink(destination: TabBar(selectedTab: $selectedTab), isActive: $goHome) {
//            //            EmptyView()}
//        }
//    }
//}
