//
//  RatingCommentModel.swift
//  BlindTiger
//
//  Created by dante  delgado on 7/11/22.
//

import Foundation
import SwiftUI
import Firebase

class ReviewCommentModel: ObservableObject {
    @Published var reviews = [review]()
    @Published var newReviewContent = ""
    @Published var initialLoading = true
    var db = Firestore.firestore()

    
    func fetchData(rootID: String) {
            db.collection("BlindTiger").document("\(cleanSchool)").collection("reviews").document(rootID).collection("ratings").order(by: "time", descending: false).getDocuments() { (query, error) in
                
                guard let documents = query?.documents else{return}
                
                self.reviews = documents.map { (queryDocumentSnapshot) -> review in
                    let data = queryDocumentSnapshot.data()
                    
                    let content = data["content"] as? String ?? ""
                    let authoruid = data["authoruid"] as? String ?? ""
                    let time = data["time"] as! Timestamp
                    let votes = data["votes"] as? Int ?? 0
                    let rootPostID = data["rootPostID"] as? String ?? ""
                    let reports = data["reports"] as? Int ?? 0
                    let rating = data["rating"] as? Int ?? 0
                    
                    if reports >= 5 {
                        self.db.collection("BlindTiger").document(cleanSchool).collection("reviews").document(rootPostID).collection("ratings").document(authoruid).delete()
                    }
                    
                    
                    
                    return review(id: authoruid, rootPostID: rootPostID, content: content, votes: votes, time: time, authoruid: authoruid, reports: reports, rating: rating)
                }
                self.initialLoading = false
            }
    }
    
    
    func uploadReview(rootID: String) {
        
        let newLines = newReviewContent.components(separatedBy: "\n").count
        if (newLines > 10 || newReviewContent.count > 280 || newReviewContent.trimmingCharacters(in: .whitespacesAndNewlines) == "" || UserDefaults.standard.integer(forKey: "\(rootID)rating") < 1) {return}
        else{
            let content = newReviewContent.trimmingCharacters(in: .whitespacesAndNewlines)
            newReviewContent = ""
            let uid = Auth.auth().currentUser!.uid
            var votes = 0
            if UserDefaults.standard.bool(forKey: "\(rootID)upvoted") == true {votes = 3}
            if UserDefaults.standard.bool(forKey: "\(rootID)downvotes") == true {votes = -3}
            
    //        GODMODE
//            let fakeUID = String(uid.shuffled())
//            let fakeVotes = Int.random(in: -1...7)
//            db.collection("BlindTiger").document(cleanSchool).collection("reviews").document("\(rootID)").collection("ratings").document(fakeUID).setData(["content" : content, "authoruid" : fakeUID, "votes" : fakeVotes, "reports" : 0, "time" : Date(), "rootPostID" : rootID, "id": fakeUID, "rating": UserDefaults.standard.integer(forKey: "\(rootID)rating")])

            db.collection("BlindTiger").document(cleanSchool).collection("reviews").document("\(rootID)").collection("ratings").document(uid).setData(["content" : content, "authoruid" : uid, "votes" : votes, "reports" : 0, "time" : Date(), "rootPostID" : rootID, "id": uid, "rating": UserDefaults.standard.integer(forKey: "\(rootID)rating")])


            let num = Int.random(in: 0...2)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10)) {self.db.collection("BlindTiger").document(cleanSchool).collection("reviews").document("\(rootID)").collection("ratings").document(uid).updateData(["votes" : FieldValue.increment(Int64(num))])}

        }
    }
    
}
