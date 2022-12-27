//
//  PeekSchoolModel.swift
//  BlindTiger
//
//  Created by dante  delgado on 6/21/22.
//

import Foundation
import Firebase

class PeekSchoolModel: ObservableObject {
    @Published var recentPosts = [post]()
    @Published var likedPosts = [post]()
    @Published var filterTab = 0
    var db = Firestore.firestore()
    @Published var initialRecentLoading = true
    
    func fetchRecentData(selectedSchool: String) {
        if recentPosts.isEmpty {
            //FETCH FOR RECENT THREAD
            db.collection("BlindTiger").document("\(selectedSchool)").collection("posts").order(by: "time", descending: true).limit(to: 25).getDocuments { query, error in
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
                self.initialRecentLoading = false
            }
        }
    }
    
    @Published var initialLikedLoading = true
    func fetchLikedData(selectedSchool: String) {
        if likedPosts.isEmpty {
            //FETCH FOR RECENT THREAD
            db.collection("BlindTiger").document("\(selectedSchool)").collection("posts").order(by: "votes", descending: true).limit(to: 25).getDocuments { query, error in
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
                        self.db.collection("BlindTiger").document(selectedSchool).collection("posts").document(id).delete()
                    }
                                        
                  
                    
                    return post(id: id, content: content, votes: votes, time: time, authoruid: authoruid, reports: reports, numComments: numComments)
                }
                self.initialLikedLoading = false
            }
        }
    }
    
    @Published var loadingMoreRecents = false
    @Published var noMoreRecents = false
    func fetchMoreRecentPosts(selectedSchool: String) {
        let lastPost = recentPosts.last
        db.collection("BlindTiger").document("\(selectedSchool)").collection("posts").document(lastPost?.id ?? "").addSnapshotListener { (document, error) in
            guard let lastDoc = document else {return}
            
            self.db.collection("BlindTiger").document("\(selectedSchool)").collection("posts").order(by: "time", descending: true).start(afterDocument: lastDoc).limit(to: 25).getDocuments { query, error in
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
    
    @Published var loadingMoreLiked = false
    @Published var noMoreLiked = false
    func fetchMoreLikedPosts(selectedSchool: String) {
        let lastPost = likedPosts.last
        db.collection("BlindTiger").document("\(selectedSchool)").collection("posts").document(lastPost?.id ?? "").addSnapshotListener { (document, error) in
            guard let lastDoc = document else {return}
            
            self.db.collection("BlindTiger").document("\(selectedSchool)").collection("posts").order(by: "votes", descending: true).start(afterDocument: lastDoc).limit(to: 25).getDocuments { query, error in
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
                self.likedPosts.append(contentsOf: newPosts)
                if newPosts.count < 20 {self.noMoreLiked = true}
                self.loadingMoreLiked = false
            }
        }
    }
}
