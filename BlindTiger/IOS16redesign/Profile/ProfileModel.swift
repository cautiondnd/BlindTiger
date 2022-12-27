//
//  ProfileModel.swift
//  BlindTiger
//
//  Created by dante  delgado on 7/12/22.
//

import SwiftUI
import Firebase


class ProfileModel: ObservableObject {
    @Published var recentPosts = [post]()
    @Published var likedPosts = [post]()
    @Published var recentComments = [post]()
    @Published var likedComments = [post]()
    @Published var recentPromos = [promo]()
    @Published var likedPromos = [promo]()
    @Published var recentReviews = [review]()
    @Published var likedReviews = [review]()
    
    @Published var allPostsScore = [Int]()
    
    @Published var filterTab = 0
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid ?? ""
    
    
    @Published var initialPostLoading = true
    
    @Published var tigerScore = 0
   

    func fetchTigerScore() {
        if allPostsScore.isEmpty {
            db.collection("BlindTiger").document(cleanSchool).collection("users").document(uid).getDocument { doc, err in
                self.tigerScore = doc?.data()?["tigerScore"] as? Int ?? 0
                if self.tigerScore < 500 {
                    self.db.collection("BlindTiger").document(cleanSchool).collection("posts").whereField("authoruid", isEqualTo: self.uid).getDocuments { query, error in
                        guard let documents = query?.documents else{return}
                        
                        self.allPostsScore = documents.map { (queryDocumentSnapshot) -> Int in
                            let data = queryDocumentSnapshot.data()
                            
                            let votes = data["votes"] as? Int ?? 0
                            
                            return votes
                        }
                        self.tigerScore = self.allPostsScore.reduce(0, +)
                        self.db.collection("BlindTiger").document(cleanSchool).collection("users").document(self.uid).setData(["tigerScore" : self.tigerScore], merge: true)
                    }
                }
            }
        }
    }
    
    @Published var dateCreated = Date()
    func fetchDateCreated() {
        db.collection("BlindTiger").document(cleanSchool).collection("users").document(uid).getDocument { doc, err in
            self.dateCreated = doc?.data()?["dateCreated"] as? Date ?? Date()
        }
    }
    
    
    func updateTigerScore() {
        if allPostsScore.isEmpty {
            db.collection("BlindTiger").document(cleanSchool).collection("posts").whereField("authoruid", isEqualTo: uid).getDocuments { query, error in
                guard let documents = query?.documents else{return}
                
                self.allPostsScore = documents.map { (queryDocumentSnapshot) -> Int in
                    let data = queryDocumentSnapshot.data()
                    
                    let votes = data["votes"] as? Int ?? 0
                    
                    return votes
                }
                self.tigerScore = self.allPostsScore.reduce(0, +)
                self.db.collection("BlindTiger").document(cleanSchool).collection("users").document(self.uid).setData(["tigerScore" : self.tigerScore], merge: true)
            }
        }
    }

    func fetchPostData() {
        if recentPosts.isEmpty {
            //FETCH RECENT POSTS
            db.collection("BlindTiger").document("\(cleanSchool)").collection("posts").whereField("authoruid", isEqualTo: uid).order(by: "time", descending: true).limit(to: 5).getDocuments { query, error in
                guard let documents = query?.documents else{return}
                
                self.recentPosts = documents.map { (queryDocumentSnapshot) -> post in
                    let data = queryDocumentSnapshot.data()
                    
                    let content = data["content"] as? String ?? ""
                    let authoruid = data["authoruid"] as? String ?? ""
                    let time = data["time"] as? Timestamp ?? Timestamp.init()
                    let votes = data["votes"] as? Int ?? 0
                    let id = data["id"] as? String ?? ""
                    let reports = data["reports"] as? Int ?? 0
                    
                    return post(id: id, content: content, votes: votes, time: time, authoruid: authoruid, reports: reports)
                }
            }
            
            //FETCH LIKED POSTS
            db.collection("BlindTiger").document("\(cleanSchool)").collection("posts").whereField("authoruid", isEqualTo: uid).order(by: "votes", descending: true).limit(to: 5).getDocuments { query, error in
                guard let documents = query?.documents else{return}
                
                self.likedPosts = documents.map { (queryDocumentSnapshot) -> post in
                    let data = queryDocumentSnapshot.data()
                    
                    let content = data["content"] as? String ?? ""
                    let authoruid = data["authoruid"] as? String ?? ""
                    let time = data["time"] as? Timestamp ?? Timestamp.init()
                    let votes = data["votes"] as? Int ?? 0
                    let id = data["id"] as? String ?? ""
                    let reports = data["reports"] as? Int ?? 0
                    
                    return post(id: id, content: content, votes: votes, time: time, authoruid: authoruid, reports: reports)
                }
                self.initialPostLoading = false
            }
        }
    }
    
    @Published var initialCommentLoading = true
    func fetchCommentData() {
        if recentComments.isEmpty {
            //RECENT COMMENTS
            db.collectionGroup("comments").whereField("authoruid", isEqualTo: uid).order(by: "time", descending: true).limit(to: 5).getDocuments() { (query, error) in
                
                guard let documents = query?.documents else{return}
                
                self.recentComments = documents.map { (queryDocumentSnapshot) -> post in
                    let data = queryDocumentSnapshot.data()
                    
                    let content = data["content"] as? String ?? ""
                    let authoruid = data["authoruid"] as? String ?? ""
                    let time = data["time"] as! Timestamp
                    let votes = data["votes"] as? Int ?? 0
                    let commentid = data["commentid"] as? String ?? ""
                    let rootpostid = data["postid"] as? String ?? ""
                    let reports = data["reports"] as? Int ?? 0
                    
                    return post(id: commentid, rootPostID: rootpostid, content: content, votes: votes, time: time, authoruid: authoruid, reports: reports)
                }
            }
            
            //LIKED COMMENTS
            db.collectionGroup("comments").whereField("authoruid", isEqualTo: uid).order(by: "votes", descending: true).limit(to: 10).getDocuments() { (query, error) in
                
                guard let documents = query?.documents else{return}
                
                self.likedComments = documents.map { (queryDocumentSnapshot) -> post in
                    let data = queryDocumentSnapshot.data()
                    
                    let content = data["content"] as? String ?? ""
                    let authoruid = data["authoruid"] as? String ?? ""
                    let time = data["time"] as! Timestamp
                    let votes = data["votes"] as? Int ?? 0
                    let commentid = data["commentid"] as? String ?? ""
                    let rootpostid = data["postid"] as? String ?? ""
                    let reports = data["reports"] as? Int ?? 0
                    
                    return post(id: commentid, rootPostID: rootpostid, content: content, votes: votes, time: time, authoruid: authoruid, reports: reports)
                }
                self.initialCommentLoading = false
            }
        }
    }
    
    @Published var initialReviewLoading = true
    func fetchReviewData() {
        if recentReviews.isEmpty {
            //FETCH LIKED REVIEWS
            db.collectionGroup("ratings").whereField("authoruid", isEqualTo: uid).order(by: "votes", descending: true).order(by: "content").limit(to: 10).getDocuments() { (query, error) in
                
                guard let documents = query?.documents else{return}
                
                self.likedReviews = documents.map { (queryDocumentSnapshot) -> review in
                    let data = queryDocumentSnapshot.data()
                    
                    let content = data["content"] as? String ?? ""
                    let authoruid = data["authoruid"] as? String ?? ""
                    let time = data["time"] as! Timestamp
                    let votes = data["votes"] as? Int ?? 0
                    let rootPostID = data["rootPostID"] as? String ?? ""
                    let reports = data["reports"] as? Int ?? 0
                    let rating = data["rating"] as? Int ?? 0
                    
                    return review(id: rootPostID, rootPostID: rootPostID, content: content, votes: votes, time: time, authoruid: authoruid, reports: reports, rating: rating)
                }
            }
            
            //RECENT REVIEWS
            db.collectionGroup("ratings").whereField("authoruid", isEqualTo: uid).order(by: "time", descending: true).limit(to: 5).getDocuments() { (query, error) in
                
                guard let documents = query?.documents else{return}
                
                self.recentReviews = documents.map { (queryDocumentSnapshot) -> review in
                    let data = queryDocumentSnapshot.data()
                    
                    let content = data["content"] as? String ?? ""
                    let authoruid = data["authoruid"] as? String ?? ""
                    let time = data["time"] as! Timestamp
                    let votes = data["votes"] as? Int ?? 0
                    let rootPostID = data["rootPostID"] as? String ?? ""
                    let reports = data["reports"] as? Int ?? 0
                    let rating = data["rating"] as? Int ?? 0
                    
                    return review(id: rootPostID, rootPostID: rootPostID, content: content, votes: votes, time: time, authoruid: authoruid, reports: reports, rating: rating)
                }
                self.initialReviewLoading = false
            }
        }
    }
    
    @Published var initialPromoLoading = true
    func fetchPromoData() {
        if recentPromos.isEmpty {
            //FETCH RECENT PROMOS
            db.collection("BlindTiger").document("\(cleanSchool)").collection("promotions").whereField("authoruid", isEqualTo: uid).order(by: "endTime", descending: true).limit(to: 5).getDocuments { query, error in
                guard let documents = query?.documents else{return}
                
                self.recentPromos = documents.map { (queryDocumentSnapshot) -> promo in
                    let data = queryDocumentSnapshot.data()
                    
                    let title = data["title"] as? String ?? ""
                    let startTime = data["startTime"] as? Timestamp ?? Timestamp.init()
                    let endTime = data["endTime"] as? Timestamp ?? Timestamp.init()
                    let authoruid = data["authoruid"] as? String ?? ""
                    let votes = data["votes"] as? Int ?? 0
                    let id = data["id"] as? String ?? ""
                    let reports = data["reports"] as? Int ?? 0
                    let description = data["description"] as? String ?? ""
                    let organizer = data["organizer"] as? String ?? ""
                    let location = data["location"] as? String ?? ""
                    let theme = data["theme"] as? String ?? ""
                    
                    if reports >= 5 {
                        self.db.collection("BlindTiger").document(cleanSchool).collection("promotions").document(id).delete()
                    }
                    
                    return promo(title: title, startTime: startTime, endTime: endTime, votes: votes, id: id, authoruid: authoruid, reports: reports, description: description, organizer: organizer, location: location, theme: theme)
                }
            }
            
            //FETCH LIKED PROMOS
            db.collection("BlindTiger").document("\(cleanSchool)").collection("promotions").whereField("authoruid", isEqualTo: uid).order(by: "votes", descending: true).limit(to: 10).getDocuments { query, error in
                guard let documents = query?.documents else{return}
                
                self.likedPromos = documents.map { (queryDocumentSnapshot) -> promo in
                    let data = queryDocumentSnapshot.data()
                    
                    let title = data["title"] as? String ?? ""
                    let startTime = data["startTime"] as? Timestamp ?? Timestamp.init()
                    let endTime = data["endTime"] as? Timestamp ?? Timestamp.init()
                    let authoruid = data["authoruid"] as? String ?? ""
                    let votes = data["votes"] as? Int ?? 0
                    let id = data["id"] as? String ?? ""
                    let reports = data["reports"] as? Int ?? 0
                    let description = data["description"] as? String ?? ""
                    let organizer = data["organizer"] as? String ?? ""
                    let location = data["location"] as? String ?? ""
                    let theme = data["theme"] as? String ?? ""
                    
                    return promo(title: title, startTime: startTime, endTime: endTime, votes: votes, id: id, authoruid: authoruid, reports: reports, description: description, organizer: organizer, location: location, theme: theme)
                }
                self.initialPromoLoading = false
            }
        }
    }
    
    @Published var loadingMoreRecentPosts = false
    @Published var noMoreRecentPosts = false
    func moreRecentPosts() {
        let lastPost = recentPosts.last
        
        self.db.collection("BlindTiger").document("\(cleanSchool)").collection("posts").whereField("authoruid", isEqualTo: self.uid).order(by: "time", descending: true).start(after: [lastPost!.time]).limit(to: 15).getDocuments { query, error in
            guard let documents = query?.documents else{return}
            
            let newPosts = documents.map { (queryDocumentSnapshot) -> post in
                let data = queryDocumentSnapshot.data()
                
                let content = data["content"] as? String ?? ""
                let authoruid = data["authoruid"] as? String ?? ""
                let time = data["time"] as? Timestamp ?? Timestamp.init()
                let votes = data["votes"] as? Int ?? 0
                let id = data["id"] as? String ?? ""
                let reports = data["reports"] as? Int ?? 0
            
                
                return post(id: id, content: content, votes: votes, time: time, authoruid: authoruid, reports: reports)
            }
            self.recentPosts.append(contentsOf: newPosts)
            if newPosts.count < 10 {self.noMoreRecentPosts = true}
            self.loadingMoreRecentPosts = false
        }
        
//        //get last doc
//        db.collection("BlindTiger").document("\(cleanSchool)").collection("posts").document(lastPost?.id ?? "").addSnapshotListener { (document, error) in
//            guard let lastDoc = document else {return}
//            // start after last doc
//            self.db.collection("BlindTiger").document("\(cleanSchool)").collection("posts").whereField("authoruid", isEqualTo: self.uid).order(by: "time", descending: true).start(afterDocument: lastDoc).limit(to: 1).getDocuments { query, error in
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
//
//
//                    return post(id: id, content: content, votes: votes, time: time, authoruid: authoruid, reports: reports)
//                }
//                self.recentPosts.append(contentsOf: newPosts)
//                if newPosts.count < 10 {self.noMoreRecentPosts = true}
//                self.loadingMoreRecentPosts = false
//            }
//
//        }
    }
//
    @Published var loadingMoreLikedPosts = false
    @Published var noMoreLikedPosts = false
    func moreLikedPosts() {
        let lastPost = likedPosts.last
        //get last doc
        db.collection("BlindTiger").document("\(cleanSchool)").collection("posts").document(lastPost?.id ?? "").addSnapshotListener { (document, error) in
            guard let lastDoc = document else {return}
            // start after last doc
            self.db.collection("BlindTiger").document("\(cleanSchool)").collection("posts").whereField("authoruid", isEqualTo: self.uid).order(by: "votes", descending: true).start(afterDocument: lastDoc).limit(to: 15).getDocuments { query, error in
                guard let documents = query?.documents else{return}

                let newPosts = documents.map { (queryDocumentSnapshot) -> post in
                    let data = queryDocumentSnapshot.data()

                    let content = data["content"] as? String ?? ""
                    let authoruid = data["authoruid"] as? String ?? ""
                    let time = data["time"] as? Timestamp ?? Timestamp.init()
                    let votes = data["votes"] as? Int ?? 0
                    let id = data["id"] as? String ?? ""
                    let reports = data["reports"] as? Int ?? 0


                    return post(id: id, content: content, votes: votes, time: time, authoruid: authoruid, reports: reports)
                }
                self.likedPosts.append(contentsOf: newPosts)
                if newPosts.count < 10 {self.noMoreLikedPosts = true}
                self.loadingMoreLikedPosts = false
            }

        }
    }
    
    @Published var loadingMoreRecentComments = false
    @Published var noMoreRecentComments = false
    func moreRecentComments() {
        let lastPost = recentComments.last
        //get last doc
        self.db.collectionGroup("comments").whereField("authoruid", isEqualTo: self.uid).order(by: "time", descending: true).start(after: [lastPost!.time]).limit(to: 15).getDocuments { query, error in
            guard let documents = query?.documents else{return}

            let newComments = documents.map { (queryDocumentSnapshot) -> post in
                let data = queryDocumentSnapshot.data()

                let content = data["content"] as? String ?? ""
                let authoruid = data["authoruid"] as? String ?? ""
                let time = data["time"] as! Timestamp
                let votes = data["votes"] as? Int ?? 0
                let commentid = data["commentid"] as? String ?? ""
                let rootpostid = data["postid"] as? String ?? ""
                let reports = data["reports"] as? Int ?? 0

                return post(id: commentid, rootPostID: rootpostid, content: content, votes: votes, time: time, authoruid: authoruid, reports: reports)
            }
            self.recentComments.append(contentsOf: newComments)
            if newComments.count < 10 {self.noMoreRecentComments = true}
            self.loadingMoreRecentComments = false
        }
        
//        db.collection("BlindTiger").document("\(cleanSchool)").collection("posts").document(lastPost?.rootPostID ?? "").collection("comments").document(lastPost?.id ?? "").addSnapshotListener { (document, error) in
//            guard let lastDoc = document else {return}
//            // start after last doc
//            self.db.collectionGroup("comments").whereField("authoruid", isEqualTo: self.uid).order(by: "time", descending: true).start(afterDocument: lastDoc).limit(to: 1).getDocuments { query, error in
//                guard let documents = query?.documents else{return}
//
//                let newComments = documents.map { (queryDocumentSnapshot) -> post in
//                    let data = queryDocumentSnapshot.data()
//
//                    let content = data["content"] as? String ?? ""
//                    let authoruid = data["authoruid"] as? String ?? ""
//                    let time = data["time"] as! Timestamp
//                    let votes = data["votes"] as? Int ?? 0
//                    let commentid = data["commentid"] as? String ?? ""
//                    let rootpostid = data["postid"] as? String ?? ""
//                    let reports = data["reports"] as? Int ?? 0
//
//                    return post(id: commentid, rootPostID: rootpostid, content: content, votes: votes, time: time, authoruid: authoruid, reports: reports)
//                }
//                self.recentComments.append(contentsOf: newComments)
//                if newComments.count < 20 {self.noMoreRecentComments = true}
//                self.loadingMoreRecentComments = false
//            }
//
//        }
    }
//
//    @Published var loadingMoreLikedComments = false
//    @Published var noMoreLikedComments = false
//    func moreLikedComments() {
//        let lastPost = likedComments.last
//        //get last doc
//        db.collection("BlindTiger").document("\(cleanSchool)").collection("posts").document(lastPost?.rootPostID ?? "").collection("comments").document(lastPost?.id ?? "").addSnapshotListener { (document, error) in
//            guard let lastDoc = document else {return}
//            // start after last doc
//            self.db.collectionGroup("comments").whereField("authoruid", isEqualTo: self.uid).order(by: "votes", descending: true).start(afterDocument: lastDoc).limit(to: 1).getDocuments { query, error in
//                guard let documents = query?.documents else{return}
//
//                let newComments = documents.map { (queryDocumentSnapshot) -> post in
//                    let data = queryDocumentSnapshot.data()
//
//                    let content = data["content"] as? String ?? ""
//                    let authoruid = data["authoruid"] as? String ?? ""
//                    let time = data["time"] as! Timestamp
//                    let votes = data["votes"] as? Int ?? 0
//                    let commentid = data["commentid"] as? String ?? ""
//                    let rootpostid = data["postid"] as? String ?? ""
//                    let reports = data["reports"] as? Int ?? 0
//
//                    return post(id: commentid, rootPostID: rootpostid, content: content, votes: votes, time: time, authoruid: authoruid, reports: reports)
//                }
//                self.recentComments.append(contentsOf: newComments)
//                if newComments.count < 20 {self.noMoreLikedComments = true}
//                self.loadingMoreLikedComments = false
//            }
//
//        }
//    }
    
    @Published var loadingMoreRecentReviews = false
    @Published var noMoreRecentReviews = false
    func moreRecentReviews() {
        let lastPost = recentReviews.last
        
        self.db.collectionGroup("ratings").whereField("authoruid", isEqualTo: self.uid).order(by: "time", descending: true).start(after: [lastPost!.time]).limit(to: 15).getDocuments { query, error in
            guard let documents = query?.documents else{return}
            
            let newReviews = documents.map { (queryDocumentSnapshot) -> review in
                let data = queryDocumentSnapshot.data()
                
                let content = data["content"] as? String ?? ""
                let authoruid = data["authoruid"] as? String ?? ""
                let time = data["time"] as! Timestamp
                let votes = data["votes"] as? Int ?? 0
                let rootPostID = data["rootPostID"] as? String ?? ""
                let reports = data["reports"] as? Int ?? 0
                let rating = data["rating"] as? Int ?? 0
                
                return review(id: rootPostID, rootPostID: rootPostID, content: content, votes: votes, time: time, authoruid: authoruid, reports: reports, rating: rating)
            }
            self.recentReviews.append(contentsOf: newReviews)
            if newReviews.count < 20 {self.noMoreRecentReviews = true}
            self.loadingMoreRecentReviews = false
        }
        
        
//        //get last doc
//        db.collection("BlindTiger").document("\(cleanSchool)").collection("reviews").document(lastPost?.rootPostID ?? "").collection("ratings").document(lastPost?.id ?? "").addSnapshotListener { (document, error) in
//            guard let lastDoc = document else {return}
//            // start after last doc
//            self.db.collectionGroup("ratings").whereField("authoruid", isEqualTo: self.uid).order(by: "time", descending: true).start(afterDocument: lastDoc).limit(to: 1).getDocuments { query, error in
//                guard let documents = query?.documents else{return}
//
//                let newReviews = documents.map { (queryDocumentSnapshot) -> review in
//                    let data = queryDocumentSnapshot.data()
//
//                    let content = data["content"] as? String ?? ""
//                    let authoruid = data["authoruid"] as? String ?? ""
//                    let time = data["time"] as! Timestamp
//                    let votes = data["votes"] as? Int ?? 0
//                    let rootPostID = data["rootPostID"] as? String ?? ""
//                    let reports = data["reports"] as? Int ?? 0
//                    let rating = data["rating"] as? Int ?? 0
//
//                    return review(id: authoruid, rootPostID: rootPostID, content: content, votes: votes, time: time, authoruid: authoruid, reports: reports, rating: rating)
//                }
//                self.recentReviews.append(contentsOf: newReviews)
//                if newReviews.count < 20 {self.noMoreRecentReviews = true}
//                self.loadingMoreRecentReviews = false
//            }
//
//        }
    }
//
//    @Published var loadingMoreLikedReviews = false
//    @Published var noMoreLikedReviews = false
//    func moreLikedReviews() {
//        let lastPost = likedReviews.last
//        //get last doc
//        db.collection("BlindTiger").document("\(cleanSchool)").collection("reviews").document(lastPost?.rootPostID ?? "").collection("ratings").document(lastPost?.id ?? "").addSnapshotListener { (document, error) in
//            guard let lastDoc = document else {return}
//            // start after last doc
//            self.db.collectionGroup("ratings").whereField("authoruid", isEqualTo: self.uid).order(by: "votes", descending: true).limit(to: 1).start(afterDocument: lastDoc).getDocuments { query, error in
//                guard let documents = query?.documents else{return}
//
//                let newReviews = documents.map { (queryDocumentSnapshot) -> review in
//                    let data = queryDocumentSnapshot.data()
//
//                    let content = data["content"] as? String ?? ""
//                    let authoruid = data["authoruid"] as? String ?? ""
//                    let time = data["time"] as! Timestamp
//                    let votes = data["votes"] as? Int ?? 0
//                    let rootPostID = data["rootPostID"] as? String ?? ""
//                    let reports = data["reports"] as? Int ?? 0
//                    let rating = data["rating"] as? Int ?? 0
//
//                    return review(id: authoruid, rootPostID: rootPostID, content: content, votes: votes, time: time, authoruid: authoruid, reports: reports, rating: rating)
//                }
//                self.recentReviews.append(contentsOf: newReviews)
//                if newReviews.count < 20 {self.noMoreLikedReviews = true}
//                self.loadingMoreLikedReviews = false
//            }
//
//        }
//    }
    
    @Published var loadingMoreRecentPromos = false
    @Published var noMoreRecentPromos = false
    func moreRecentPromos() {
        let lastPost = recentPromos.last
        //get last doc
        self.db.collection("BlindTiger").document("\(cleanSchool)").collection("promotions").whereField("authoruid", isEqualTo: self.uid).order(by: "endTime", descending: true).start(after: [lastPost!.endTime]).limit(to: 15).getDocuments { query, error in
            guard let documents = query?.documents else{return}
            
            let newPromos = documents.map { (queryDocumentSnapshot) -> promo in
                let data = queryDocumentSnapshot.data()
                
                let title = data["title"] as? String ?? ""
                let startTime = data["startTime"] as? Timestamp ?? Timestamp.init()
                let endTime = data["endTime"] as? Timestamp ?? Timestamp.init()
                let authoruid = data["authoruid"] as? String ?? ""
                let votes = data["votes"] as? Int ?? 0
                let id = data["id"] as? String ?? ""
                let reports = data["reports"] as? Int ?? 0
                let description = data["description"] as? String ?? ""
                let organizer = data["organizer"] as? String ?? ""
                let location = data["location"] as? String ?? ""
                let theme = data["theme"] as? String ?? ""
                
                return promo(title: title, startTime: startTime, endTime: endTime, votes: votes, id: id, authoruid: authoruid, reports: reports, description: description, organizer: organizer, location: location, theme: theme)
            }
            self.recentPromos.append(contentsOf: newPromos)
            if newPromos.count < 20 {self.noMoreRecentPromos = true}
            self.loadingMoreRecentPromos = false
        }
        
        
        
//        db.collection("BlindTiger").document("\(cleanSchool)").collection("promotions").document(lastPost?.id ?? "").addSnapshotListener { (document, error) in
//            guard let lastDoc = document else {return}
//            // start after last doc
//            self.db.collection("BlindTiger").document("\(cleanSchool)").collection("promotions").whereField("authoruid", isEqualTo: self.uid).order(by: "endTime", descending: true).start(afterDocument: lastDoc).limit(to: 1).getDocuments { query, error in
//                guard let documents = query?.documents else{return}
//
//                let newPromos = documents.map { (queryDocumentSnapshot) -> promo in
//                    let data = queryDocumentSnapshot.data()
//
//                    let title = data["title"] as? String ?? ""
//                    let startTime = data["startTime"] as? Timestamp ?? Timestamp.init()
//                    let endTime = data["endTime"] as? Timestamp ?? Timestamp.init()
//                    let authoruid = data["authoruid"] as? String ?? ""
//                    let votes = data["votes"] as? Int ?? 0
//                    let id = data["id"] as? String ?? ""
//                    let reports = data["reports"] as? Int ?? 0
//                    let description = data["description"] as? String ?? ""
//                    let organizer = data["organizer"] as? String ?? ""
//                    let location = data["location"] as? String ?? ""
//                    let theme = data["theme"] as? String ?? ""
//
//                    return promo(title: title, startTime: startTime, endTime: endTime, votes: votes, id: id, authoruid: authoruid, reports: reports, description: description, organizer: organizer, location: location, theme: theme)
//                }
//                self.recentPromos.append(contentsOf: newPromos)
//                if newPromos.count < 20 {self.noMoreRecentPromos = true}
//                self.loadingMoreRecentPromos = false
//            }
//
//        }
    }
    
//    @Published var loadingMoreLikedPromos = false
//    @Published var noMoreLikedPromos = false
//    func moreLikedPromos() {
//        let lastPost = recentPromos.last
//        //get last doc
//        db.collection("BlindTiger").document("\(cleanSchool)").collection("promotions").document(lastPost?.id ?? "").addSnapshotListener { (document, error) in
//            guard let lastDoc = document else {return}
//            // start after last doc
//            self.db.collection("BlindTiger").document("\(cleanSchool)").collection("promotions").whereField("authoruid", isEqualTo: self.uid).order(by: "votes", descending: true).start(afterDocument: lastDoc).limit(to: 1).getDocuments { query, error in
//                guard let documents = query?.documents else{return}
//
//                let newPromos = documents.map { (queryDocumentSnapshot) -> promo in
//                    let data = queryDocumentSnapshot.data()
//
//                    let title = data["title"] as? String ?? ""
//                    let startTime = data["startTime"] as? Timestamp ?? Timestamp.init()
//                    let endTime = data["endTime"] as? Timestamp ?? Timestamp.init()
//                    let authoruid = data["authoruid"] as? String ?? ""
//                    let votes = data["votes"] as? Int ?? 0
//                    let id = data["id"] as? String ?? ""
//                    let reports = data["reports"] as? Int ?? 0
//                    let description = data["description"] as? String ?? ""
//                    let organizer = data["organizer"] as? String ?? ""
//                    let location = data["location"] as? String ?? ""
//                    let theme = data["theme"] as? String ?? ""
//
//                    return promo(title: title, startTime: startTime, endTime: endTime, votes: votes, id: id, authoruid: authoruid, reports: reports, description: description, organizer: organizer, location: location, theme: theme)
//                }
//                self.recentPromos.append(contentsOf: newPromos)
//                if newPromos.count < 20 {self.noMoreLikedPromos = true}
//                self.loadingMoreLikedPromos = false
//            }
//
//        }
//    }
    
}
