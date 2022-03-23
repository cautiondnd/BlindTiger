//
//  HomeViewModel.swift
//  BlindTiger
//
//  Created by dante  delgado on 11/18/20.
//

import SwiftUI
import Firebase
import GoogleMobileAds


class homeViewModel: ObservableObject {
    
    @Published var posts = [post]()
    @Published var goPreLogin = false
    @Published var initialLoading = true
    @Published var numberOfPostsLoaded = 30
    
    
    let db = Firestore.firestore()
    
    func fetchData() {
        if Auth.auth().currentUser != nil {
            // to make it not real time just use .getdocuments instead of addsnapshotlistner
            
            db.collection("BlindTiger").document("\(cleanSchool)").collection("posts").order(by: "time", descending: true).limit(to: numberOfPostsLoaded).getDocuments() { (querySnapshot, error) in
                //make sure something is in posts
                guard let documents = querySnapshot?.documents else{
                    print("no documents")
                    return
                }
                // map data to a post struct
                
                self.posts = documents.map { (queryDocumentSnapshot) -> post in
                    let data = queryDocumentSnapshot.data()
                    
                    
                    let content = data["content"] as? String ?? ""
                    let authoruid = data["authoruid"] as? String ?? ""
                    let time = data["time"] as? Timestamp ?? Timestamp.init()
                    let anonymous = data["anonymous"] as? Bool ?? true
                    let votes = data["votes"] as? Int ?? 0
                    let id = data["id"] as? String ?? ""
                    let autherusername = data["authorusername"] as? String ?? ""
                    let reports = data["reports"] as? Int ?? 0
                    
                    
                    
                    if reports >= 5 {
                        self.db.collection("BlindTiger").document(cleanSchool).collection("posts").document(id).delete()
                    }
                    
                    
                    return post(id: id, content: content, votes: votes, time: time, authoruid: authoruid, anonymous: anonymous, authorusername: autherusername, reports: reports)
                    
                }
                self.initialLoading = false
                
            }
           
        }
        else{
            //if somehow no user is signed in the go to prelogin
            goPreLogin = true
        }
        
    }
    
    @Published var loading: Bool = false {
        
        didSet {
            if oldValue == false && loading == true {
                self.load()
            }
        }
    }
    
    func load() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            
            self.fetchData();
            
            self.loading = false
            
            
        }
    }
    
    
}



let db = Firestore.firestore()
//drop everything up to @
let email = Auth.auth().currentUser?.email?.drop(while: { (Character) -> Bool in
    return Character != "@"
})

var currentSchool = email?.dropLast(4).drop(while: { (Character) -> Bool in
    if (email?.filter({ $0 == "." }).count)! > 1 {
        //if theres multiple . then delete everything up to the first one
        return Character != "."
    }
    else{
        //if not then delete everything up to the @
        return Character != "@"
    }
}).dropFirst(1)


let cleanSchool = String(currentSchool ?? "")
//FOR TESTING
//var cleanSchool = "belmont"




struct cardView: View {
    var content: String
    @State var votes: Int
    var time: Timestamp
    var authoruid: String
    var anonymous: Bool
    var id: String
    var authorusername: String
    var reports: Int
    @State var numberOfComments = 0
    @State var upvote: Bool
    @State var downvote: Bool
    @State var reported: Bool
    @State var goComment = false
    @State var goProfile = false
    @State var showReportPopUp = false
    @State var showDeleteAlert = false
    @State var showBlockAlert = false
    @Binding var blockedUsers: [String]
    
    var body: some View {
        
        let date = time.dateValue()
        
        ZStack{
            //this V stack is the card view (other stuff is the report pop up)
            VStack{
                //username, time, and reports
                HStack{
                    if anonymous == true {
                        Text("Anonymous").foregroundColor(.gray).lineLimit(1)}
                    else{
                        Button(action: {
                            goProfile = true
                        },
                        label: {Text("\(authorusername.trimmingCharacters(in: .whitespacesAndNewlines)) ").lineLimit(1)})
                        NavigationLink(destination: NotSelfProfileView(userID: authoruid, blockedUsers: $blockedUsers), isActive: $goProfile) {
                            EmptyView()}
                      
                    }
                    Text("◦ \(date.timeAgoDisplay())").foregroundColor(.gray).lineLimit(1).layoutPriority(0.9)
                    Spacer()
                    Button(action: {showReportPopUp.toggle()}, label: {
                        Image(systemName: "ellipsis").foregroundColor(.gray).padding(7)
                    }).offset(y: -10)
                    
                }.padding(.bottom, 5.0)
                // content and votes
                HStack{
                    Text(content).fixedSize(horizontal: false, vertical: true).layoutPriority(1).font(.title3).padding(.trailing, 1)
                    Spacer()
                    VStack {
                        Button(action: {
                            upvote.toggle();
                            UserDefaults.standard.set(self.upvote, forKey: "\(id)upvoted");
                            UserDefaults.standard.set(false, forKey: "\(id)downvoted")
                            if upvote == true {
                                if downvote == true {
                                    downvote = false
                                    db.collection("BlindTiger").document(cleanSchool).collection("posts").document(id).updateData(["votes" : FieldValue.increment(Int64(2))])
                                    votes += 2
                                    
                                }
                                else {
                                    // TEST change for how much one upvote upvotes
                                    db.collection("BlindTiger").document(cleanSchool).collection("posts").document(id).updateData(["votes" : FieldValue.increment(Int64(1))])
                                    votes += 1
                                }
                            }
                            else {
//FOR TESTING (comment out)
                                db.collection("BlindTiger").document(cleanSchool).collection("posts").document(id).updateData(["votes" : FieldValue.increment(Int64(-1))])
                                votes -= 1
                            }
                        }, label: {
                            Image(systemName: "chevron.up")
                                .foregroundColor(upvote == true ? .orange : .gray)
                                .font(.title).padding([.top, .bottom, .trailing], 5.0)
                        })
                        
                        Text("\(votes)").font(.title).padding(.trailing, 5.0).lineLimit(1).allowsTightening(true)
                        Button(action: {
                            
                            
                            downvote.toggle();
                            UserDefaults.standard.set(self.downvote, forKey: "\(id)downvoted");
                            UserDefaults.standard.set(false, forKey: "\(id)upvoted")
                            if downvote == true {
                                if upvote == true {
                                    upvote = false
                                    db.collection("BlindTiger").document(cleanSchool).collection("posts").document(id).updateData(["votes" : FieldValue.increment(Int64(-2))])
                                    votes -= 2
                                }
                                else {
                                    db.collection("BlindTiger").document(cleanSchool).collection("posts").document(id).updateData(["votes" : FieldValue.increment(Int64(-1))])
                                    votes -= 1
                                }
                            }
                            else {
//FOR TESTING (comment out for testing)
                                db.collection("BlindTiger").document(cleanSchool).collection("posts").document(id).updateData(["votes" : FieldValue.increment(Int64(1))])
                                votes += 1
                            }
                        }, label: {
                            Image(systemName: "chevron.down")
                                .foregroundColor(downvote == true ? .orange : .gray)
                                .font(.title).padding([.top, .bottom, .trailing], 5.0)
                        })
                        
                        
                        
                    }
                }
                HStack{
                    
                    NavigationLink(
                        destination: CommentView(content: content, votes: votes, time: time, authoruid: authoruid, anonymous: anonymous, id: id, authorusername: authorusername, blockedUsers: $blockedUsers),
                        label: {
                            HStack(spacing: 3){
                                Text("\(numberOfComments)").foregroundColor(.black)
                                Image(systemName: "bubble.right").foregroundColor(.gray)

                            }
                           })
                    
                    Spacer()
                }.padding(.top, 5)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white).shadow(color: Color.black.opacity(0.15), radius: 6)).padding(.horizontal).padding(.vertical, 5)
            
            if showReportPopUp == true {
                //my own post (delete)
                if authoruid == Auth.auth().currentUser?.uid {
                    ZStack {
                        Color.white
                        VStack(spacing: 0) {
                            
                            Button(action: {
                                showDeleteAlert = true
                            }, label: {
                                Text("Delete").foregroundColor(.red).fontWeight(.semibold)
                                    .frame(width: 300.0, height: 75)
                                    .padding(.horizontal)
                            })
                
                            ZStack{
                                Button(action: {
                                    showReportPopUp = false
                                }, label: {
                                    Text("Close").foregroundColor(.blue).frame(width: 300.0, height: 50.0)
                                })
                                Rectangle().foregroundColor(.gray).frame(height: 1).offset(y: -25).opacity(0.5)
                            }
                            
                            
                        }
                    }.alert(isPresented: $showDeleteAlert, content: {
                                Alert(title: Text("Delete Post?"), message: Text("There is no way to recover a post once deleted."), primaryButton: .default(Text("Cancel")) {showReportPopUp = false}, secondaryButton: .destructive(Text("Delete")) {db.collection("BlindTiger").document(cleanSchool).collection("posts").document(id).delete(); showReportPopUp = false })})
                    .frame(width: 300, height: 125)
                    .cornerRadius(20).shadow(radius: 20)
                }
                //not my own post (report)
                else{
                    ZStack {
                        Color.white
                        VStack(spacing: 0) {
                            
                            Button(action: {reported.toggle();
                                UserDefaults.standard.set(reported, forKey: "\(id)reported");
                                if reported == true {db.collection("BlindTiger").document(cleanSchool).collection("posts").document(id).updateData(["reports" : FieldValue.increment(Int64(1))])}
                                else {
                                    db.collection("BlindTiger").document(cleanSchool).collection("posts").document(id).updateData(["reports" : FieldValue.increment(Int64(-1))])
                                }
                               
                            }, label: {
                                HStack{
                                    Text("Report").foregroundColor(.red).fontWeight(.semibold)
                                    Spacer()
                                    if reported == true {
                                        Image(systemName: "checkmark.square").foregroundColor(.red).font(.title2)
                                    }
                                    else{
                                        Image(systemName: "square").foregroundColor(.red).font(.title2)
                                    }
                                    
                                }.padding(.horizontal)
                                .frame(width: 300.0, height: 50)
                            })
                            
                            Button(action: {
//                               if blockedUsers.contains(authoruid) {blockedUsers.removeAll(where: {$0 == authoruid})
//                                    //UserDefaults.standard.set(blockedUsers, forKey: "blockedUsers")
//                                }
                                showBlockAlert = true
//                                blockedUsers.append(authoruid)
//                                UserDefaults.standard.set(blockedUsers, forKey: "blockedUsers")
//                                showReportPopUp = false
                               
                            }, label: {
                                HStack{

                                        Text("Block User").foregroundColor(.black).padding(.horizontal)//}
                    
                                    Spacer()
                                }
                            }).frame(width: 300.0, height: 50)
                            
                            ZStack{
                                Button(action: {
                                    print(blockedUsers)
                                    showReportPopUp = false
                                }, label: {
                                    
                                    Text("Close").foregroundColor(.blue).frame(width: 300.0, height: 50)
                                    
                                })
                                Rectangle().foregroundColor(.gray).frame(height: 1).offset(y: -25).opacity(0.5)
                            }
                            
                            
                        }
                    }.alert(isPresented: $showBlockAlert, content: {
                                Alert(title: Text("Block User?"), message: Text("Are you sure you want to block this user?"), primaryButton: .default(Text("Cancel")) {showReportPopUp = false}, secondaryButton: .destructive(Text("Block")) {blockedUsers.append(authoruid)
                                        UserDefaults.standard.set(blockedUsers, forKey: "blockedUsers")
                                        showReportPopUp = false })})
                    .frame(width: 300, height: 150)
                    .cornerRadius(20).shadow(radius: 20)
                }
            }
        }
        
        
        // get the number of comments
        .onAppear() {
            db.collection("BlindTiger").document(cleanSchool).collection("posts").document(id).collection("comments").getDocuments
            {(querySnapshot, err) in
                
                if let err = err {print("Error getting documents: \(err)")}
                else{
                    return self.numberOfComments = querySnapshot!.count
                }
            }
            
        }
        //extra assurance that user defaults saved everything
        .onDisappear(){
            upvote = UserDefaults.standard.bool(forKey: "\(id)upvoted");
            downvote = UserDefaults.standard.bool(forKey: "\(id)downvoted");
            reported = UserDefaults.standard.bool(forKey: "\(id)reported");
            
        }
        
    }
}



//Post struct

struct post: Identifiable {
    var id: String
    var content: String
    var votes: Int
    var time: Timestamp
    var authoruid: String
    var anonymous: Bool
    var authorusername : String
    var reports: Int
}
