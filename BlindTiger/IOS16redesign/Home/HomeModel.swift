//
//  HomeModel.swift
//  BlindTigerRedesign
//
//  Created by dante  delgado on 6/11/22.
//

import SwiftUI
import Firebase


class HomeModel: ObservableObject {
    @Published var recentPosts = [post]()
    @Published var likedPosts = [post]()
    @Published var filterTab = 0
    let db = Firestore.firestore()
    let oneDayAgo = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()

    @Published var initialRecentsLoading = true
    func fetchRecentData() {
        //FETCH FOR RECENT THREAD
        if self.recentPosts.isEmpty {
            
            db.collection("BlindTiger").document("\(cleanSchool)").collection("posts").order(by: "time", descending: true).limit(to: 30).getDocuments { query, error in
                guard let documents = query?.documents else{return}
                
                self.recentPosts = documents.map { (queryDocumentSnapshot) -> post in
                    let data = queryDocumentSnapshot.data()
                    
                    let content = data["content"] as? String ?? ""
                    let authoruid = data["authoruid"] as? String ?? ""
                    let time = data["time"] as? Timestamp ?? Timestamp.init()
                    let votes = data["votes"] as? Int ?? 0
                    let id = data["id"] as? String ?? ""
                    let reports = data["reports"] as? Int ?? 0
                    let numComments = data["numComments"] as? Int ?? 0
                    
                    if reports >= 5 {
                        self.db.collection("BlindTiger").document(cleanSchool).collection("posts").document(id).delete()
                    }
                    
                    return post(id: id, content: content, votes: votes, time: time, authoruid: authoruid, reports: reports, numComments: numComments)
                }
                self.initialRecentsLoading = false
            }
        }
    }

    @Published var initialLikedLoading = true
    func fetchLikedData() {
        if likedPosts.isEmpty {
            //FETCH FOR LIKED THREAD
            db.collection("BlindTiger").document("\(cleanSchool)").collection("posts").whereField("time", isGreaterThan: Timestamp(date: oneDayAgo)).getDocuments { query, error in
                guard let documents = query?.documents else{return}
                
                self.likedPosts = documents.map { (queryDocumentSnapshot) -> post in
                    let data = queryDocumentSnapshot.data()
                    
                    let content = data["content"] as? String ?? ""
                    let authoruid = data["authoruid"] as? String ?? ""
                    let time = data["time"] as? Timestamp ?? Timestamp.init()
                    let votes = data["votes"] as? Int ?? 0
                    let id = data["id"] as? String ?? ""
                    let reports = data["reports"] as? Int ?? 0
                    let numComments = data["numComments"] as? Int ?? 0

                    if reports >= 5 {
                        self.db.collection("BlindTiger").document(cleanSchool).collection("posts").document(id).delete()
                    }
                    
                    return post(id: id, content: content, votes: votes, time: time, authoruid: authoruid, reports: reports, numComments: numComments)
                }
                self.initialLikedLoading = false
            }
        }
    }
    
    @Published var loadingMoreRecents = false
    @Published var noMoreRecents = false
    func fetchMoreRecentPosts() {
        let lastPost = recentPosts.last
        db.collection("BlindTiger").document("\(cleanSchool)").collection("posts").document(lastPost?.id ?? "").addSnapshotListener { (document, error) in
            guard let lastDoc = document else {return}
            
            self.db.collection("BlindTiger").document("\(cleanSchool)").collection("posts").order(by: "time", descending: true).start(afterDocument: lastDoc).limit(to: 30).getDocuments { query, error in
                guard let documents = query?.documents else{return}
                let newPosts = documents.map { (queryDocumentSnapshot) -> post in
                    let data = queryDocumentSnapshot.data()
                    
                    let content = data["content"] as? String ?? ""
                    let authoruid = data["authoruid"] as? String ?? ""
                    let time = data["time"] as? Timestamp ?? Timestamp.init()
                    let votes = data["votes"] as? Int ?? 0
                    let id = data["id"] as? String ?? ""
                    let reports = data["reports"] as? Int ?? 0
                    let numComments = data["numComments"] as? Int ?? 0

                    if reports >= 5 {
                        self.db.collection("BlindTiger").document(cleanSchool).collection("posts").document(id).delete()
                    }
                    
                    return post(id: id, content: content, votes: votes, time: time, authoruid: authoruid, reports: reports, numComments: numComments)
                }
                self.recentPosts.append(contentsOf: newPosts)
                if newPosts.count < 20 {self.noMoreRecents = true}
                self.loadingMoreRecents = false
            }
        }
    }
    
    //doesnt work: filtering by time and then by votes only if two posts have the same time
//    func moreLikedPosts() {
//        let lastPost = likedPosts.last
//        db.collection("BlindTiger").document("\(cleanSchool)").collection("posts").document(lastPost?.id ?? "1").addSnapshotListener { (document, error) in
//            guard let lastDoc = document else {return}
//
//            self.db.collection("BlindTiger").document("\(cleanSchool)").collection("posts").whereField("time", isGreaterThan: Timestamp(date: self.oneDayAgo)).order(by: "time").order(by: "votes", descending: true).start(afterDocument: lastDoc).limit(to: 25).getDocuments { query, error in
//                guard let documents = query?.documents else{return}
//
//                let newPosts = documents.map { (queryDocumentSnapshot) -> post in
//                    let data = queryDocumentSnapshot.data()
//
//                    let content = data["content"] as? String ?? ""
//                    let authoruid = data["authoruid"] as? String ?? ""
//                    let time = data["time"] as? Timestamp ?? Timestamp.init()
//                    let votes = data["votes"] as? Int ?? 0
//                    let id = data["id"] as? String ?? ""
//                    let reports = data["reports"] as? Int ?? 0
//                    let numComments = data["numComments"] as? Int ?? 0
//
//                    if reports >= 5 {
//                        self.db.collection("BlindTiger").document(cleanSchool).collection("posts").document(id).delete()
//                    }
//
//                    return post(id: id, content: content, votes: votes, time: time, authoruid: authoruid, reports: reports, numComments: numComments)
//                }
//                self.likedPosts.append(contentsOf: newPosts)
//            }
//
//        }
//    }

    @Published var newPostContent = ""

    func uploadPost() {
        let newLines = newPostContent.components(separatedBy: "\n").count
        if (newLines > 10 || newPostContent.count > 280 || newPostContent.trimmingCharacters(in: .whitespacesAndNewlines) == "") {return}
        else{
            newPostContent = newPostContent.trimmingCharacters(in: .whitespacesAndNewlines)
            let uid = Auth.auth().currentUser?.uid
            //GODMODE replaace fakeuid
           // let fakeUID = String(uid!.shuffled())
            let userPost = db.collection("BlindTiger").document(cleanSchool).collection("posts").addDocument(data: ["content" : newPostContent, "authoruid" : uid ?? "", "votes" : 0, "reports" : 0, "time" : Date(), "numComments": 0])

                   //add document id as a field
                   let userPostID = userPost.documentID
                   db.collection("BlindTiger").document(cleanSchool).collection("posts").document(userPostID).setData(["id" : userPostID], merge: true)
            let num = Int.random(in: 0...1)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10)) {
                self.db.collection("BlindTiger").document(cleanSchool).collection("posts").document(userPostID).updateData(["votes" : FieldValue.increment(Int64(num))])}
            
            newPostContent = ""
            filterTab = 0
            
        }
        
    }
    
    @Published var isValid = true
    
    func validateFields() {
        let newLines = newPostContent.components(separatedBy: "\n").count
        if (newLines > 10 || newPostContent.count > 280 || newPostContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {isValid = false}
        else {isValid = true}
    }
    

        @Published var refreshing: Bool = false {
    
            didSet {
                if oldValue == false && refreshing == true {
                    self.load()
                }
            }
        }
    
        func load() {
                self.refreshRecentData();
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {self.refreshing = false}
        }
    
    func refreshRecentData() {
        //FETCH FOR RECENT THREAD
            
            db.collection("BlindTiger").document("\(cleanSchool)").collection("posts").order(by: "time", descending: true).limit(to: 30).getDocuments { query, error in
                guard let documents = query?.documents else{return}
                
                self.recentPosts = documents.map { (queryDocumentSnapshot) -> post in
                    let data = queryDocumentSnapshot.data()
                    
                    let content = data["content"] as? String ?? ""
                    let authoruid = data["authoruid"] as? String ?? ""
                    let time = data["time"] as? Timestamp ?? Timestamp.init()
                    let votes = data["votes"] as? Int ?? 0
                    let id = data["id"] as? String ?? ""
                    let reports = data["reports"] as? Int ?? 0
                    let numComments = data["numComments"] as? Int ?? 0

                    if reports >= 5 {
                        self.db.collection("BlindTiger").document(cleanSchool).collection("posts").document(id).delete()
                    }
                    
                    return post(id: id, content: content, votes: votes, time: time, authoruid: authoruid, reports: reports, numComments: numComments)
                }
            }
        }
}


