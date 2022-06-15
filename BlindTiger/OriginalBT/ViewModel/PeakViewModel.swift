////
////  PeakViewModel.swift
////  BlindTiger
////
////  Created by dante  delgado on 11/28/20.
////
//
//import SwiftUI
//import Firebase
//
//class peekViewModel: ObservableObject {
//    @Published var peekPosts = [post]()
//    @Published var numberOfPostsLoaded = 30
//    @Published var initialLoading = true
//    
//    let db = Firestore.firestore()
//    
//    
//    func fetchData(selectedSchool: String) {
//        db.collection("BlindTiger").document("\(selectedSchool)").collection("posts").order(by: "time", descending: true).limit(to: numberOfPostsLoaded).getDocuments { (querySnapshot, error) in
//            //make sure something is in posts
//            guard let documents = querySnapshot?.documents else{
//                print("no documents")
//                return
//            }
//            //author uid might be unneseceray
//            // map data to a post struct
//            self.peekPosts = documents.map { (queryDocumentSnapshot) -> post in
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
//                if reports >= 5 {
//                    self.db.collection("BlindTiger").document(selectedSchool).collection("posts").document(id).delete()
//                }
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
//    
//    
//    
//    
//    
//}
//
//
//struct peekCardView: View {
//    var content: String
//    var votes: Int
//    var time: Timestamp
//    var authoruid: String
//    var anonymous: Bool
//    var id: String
//    var authorusername: String
//    var selectedSchool: String
//    
//    var reports: Int
//    @State var numberOfComments = 0
//    @State var reported: Bool
//    @State var showReportPopUp = false
//    @State var showDeleteAlert = false
//    @State var showBlockAlert = false
//    
//    @Binding var peekBlockedUsers: [String]
//
//    
//    var body: some View {
//        let date = time.dateValue()
//        
//        ZStack{
//            VStack{
//                HStack{
//                    if anonymous == true {
//                        Text("Anonymous").foregroundColor(.gray).lineLimit(1)}
//                    else{Text("\(authorusername.trimmingCharacters(in: .whitespacesAndNewlines))").lineLimit(1).foregroundColor(.gray)}
//                    Text("◦ \(date.timeAgoDisplay())").foregroundColor(.gray).layoutPriority(0.9)
//                    Spacer()
//                    Button(action: {showReportPopUp = true}, label: { Image(systemName: "ellipsis").offset(y: -10).foregroundColor(.gray).padding(7)})
//                    
//                    
//                }.padding(.bottom, 5.0)
//                HStack{
//                    Text(content).fixedSize(horizontal: false, vertical: true).layoutPriority(1).font(.title3).padding(.trailing, 1)
//                    Spacer()
//                    
//                    
//                    Text("\(votes)").font(.title).padding(.trailing, 5.0).layoutPriority(1).lineLimit(1).allowsTightening(true)
//                    
//                    
//                } .padding(.vertical)
//                
//                HStack{
//                    
//                    NavigationLink(
//                        destination: PeekCommentView(content: content, votes: votes, time: time, authoruid: authoruid, anonymous: anonymous, id: id, authorusername: authorusername, selectedSchool: selectedSchool, peekBlockedUsers: $peekBlockedUsers),
//                        label: {
//                            HStack(spacing: 3){
//                                Text("\(numberOfComments)").foregroundColor(.black)
//                                Image(systemName: "bubble.right").foregroundColor(.gray)
//
//                            }
//                           })
//                    
//                    Spacer()
//                }.padding(.top, 5)
//                
//            }
//            .padding()
//            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white).shadow(color: Color.black.opacity(0.15), radius: 6)).padding(.horizontal).padding(.vertical, 5)//.shadow(radius: 10)
//            
//            
//            if showReportPopUp == true {
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
//                                Alert(title: Text("Delete Post?"), message: Text("There is no way to recover a post once deleted."), primaryButton: .default(Text("Cancel")) {showReportPopUp = false}, secondaryButton: .destructive(Text("Delete")) {db.collection("BlindTiger").document(selectedSchool).collection("posts").document(id).delete()} )})
//                    .frame(width: 300, height: 125)
//                    .cornerRadius(20).shadow(radius: 20)
//                }
//                // not my own post (no delete)
//                else{
//                    ZStack {
//                        Color.white
//                        VStack(spacing: 0) {
//                            
//                            
//                            Button(action: {reported.toggle();
//                                UserDefaults.standard.set(reported, forKey: "\(id)reported");
//                                if reported == true {db.collection("BlindTiger").document(selectedSchool).collection("posts").document(id).updateData(["reports" : FieldValue.increment(Int64(1))])}
//                                else {
//                                    db.collection("BlindTiger").document(selectedSchool).collection("posts").document(id).updateData(["reports" : FieldValue.increment(Int64(-1))])
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
//                            Button(action: {
////                             
//                               showBlockAlert = true
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
//                                Alert(title: Text("Block User?"), message: Text("Are you sure you want to block this user?"), primaryButton: .default(Text("Cancel")) {showReportPopUp = false}, secondaryButton: .destructive(Text("Block")) {peekBlockedUsers.append(authoruid)
//                                        UserDefaults.standard.set(peekBlockedUsers, forKey: "blockedUsers")
//                                        showReportPopUp = false })})
//                    .frame(width: 300, height: 150)
//                    .cornerRadius(20).shadow(radius: 20)
//                }
//            }
//        }
//        .onAppear() {
//            db.collection("BlindTiger").document(selectedSchool).collection("posts").document(id).collection("comments").getDocuments
//            {(querySnapshot, err) in
//                
//                if let err = err {print("Error getting documents: \(err)");}
//                else{
//                    return self.numberOfComments = querySnapshot!.count
//                }
//            }}
//    }
//}
//
//
//struct peekCommentCardView: View {
//    let content: String
//    @State var votes: Int
//    let time: Timestamp
//    let authoruid: String
//    let anonymous: Bool
//    let postid: String
//    let commentid: String
//    let authorusername: String
//    let selectedSchool: String
//    @State var upvote: Bool
//    @State var downvote: Bool
//    @State var goProfile = false
//    var reports: Int
//    @State var reported: Bool
//    @State var showReportPopUp = false
//    @State var showDeleteAlert = false
//    @Binding var peekBlockedUsers: [String]
//
//    
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
//                        
//                        Text("\(authorusername.trimmingCharacters(in: .whitespacesAndNewlines))").lineLimit(1).foregroundColor(.gray)
//                        
//                        
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
//                    
//                        Text("\(votes)").font(.title).padding(.trailing, 5.0).layoutPriority(1).lineLimit(1).allowsTightening(true)
//                     
//                    }
//                }.padding(.bottom, 10)
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
//                    }
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
//                                if reported == true {db.collection("BlindTiger").document(selectedSchool).collection("posts").document(postid).collection("comments").document(commentid).updateData(["reports" : FieldValue.increment(Int64(1))])}
//                                else {
//                                    db.collection("BlindTiger").document(selectedSchool).collection("posts").document(postid).collection("comments").document(commentid).updateData(["reports" : FieldValue.increment(Int64(-1))])
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
//                            Button(action: {
////                               if blockedUsers.contains(authoruid) {blockedUsers.removeAll(where: {$0 == authoruid})
////                                    //UserDefaults.standard.set(blockedUsers, forKey: "blockedUsers")
////                                }
//                                peekBlockedUsers.append(authoruid)
//                                UserDefaults.standard.set(peekBlockedUsers, forKey: "peekBlockedUsers")
//                                showReportPopUp = false
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
//                    }
//                    .frame(width: 300, height: 150)
//                    .cornerRadius(20).shadow(radius: 20)
//                }
//            }
//        }.alert(isPresented: $showDeleteAlert, content: {
//                    Alert(title: Text("Delete Post?"), message: Text("There is no way to recover a post once deleted."), primaryButton: .default(Text("Cancel")) {showReportPopUp = false}, secondaryButton: .destructive(Text("Delete")) {db.collection("BlindTiger").document(selectedSchool).collection("posts").document(postid).collection("comments").document(commentid).delete()} )})
//        .onDisappear(){
//            upvote = UserDefaults.standard.bool(forKey: "\(commentid)upvoted");
//            downvote = UserDefaults.standard.bool(forKey: "\(commentid)downvoted");
//            reported = UserDefaults.standard.bool(forKey: "\(commentid)reported");
//            
//        }
//    }
//}
//
//
//struct peekCardCommentedOn: View {
//    var content: String
//    var votes: Int
//    var time: Timestamp
//    var authoruid: String
//    var anonymous: Bool
//    var id: String
//    var authorusername: String
//    @State var goHome = false
//    @State var selectedTab = 0
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
//                        
//                        Text("\(authorusername.trimmingCharacters(in: .whitespacesAndNewlines))").lineLimit(1).foregroundColor(.gray)
//                        
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
//            //reports on card commented on
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
