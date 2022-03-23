//
//  NewPostViewModel.swift
//  BlindTiger
//
//  Created by dante  delgado on 11/18/20.
//

import SwiftUI
import Firebase

class NewPostViewModel: ObservableObject{
    @Published var newPostContent = ""
    @Published var isAnonymous = true
    @Published var selectedTab = 2
    @Published var dbErr = false
    @Published var validationError = false
    
    //TEST
//    @Published var reusedPost: post = post(id: "8quL3ClusBMpVfSSriPq", content: "Literally fuck corona virus", votes: 7, time: Timestamp(seconds: Int64(UserDefaults.standard.integer(forKey: "reusedPostTime")), nanoseconds: Int32(UserDefaults.standard.integer(forKey: "reusedPostNanoSecondsTime"))), authoruid: "aDZm0jZ1F2ZfSSGyoYnjYA6OwIo1", anonymous: true, authorusername: "cautiondnd", reports: 0)

  //  @Published var showAnonAlert = false



    
    
    let db = Firestore.firestore()
    func newPost() {
        //make sure something is written and its less than 240 charecters
        if newPostContent.trimmingCharacters(in: .whitespacesAndNewlines) == "" || newPostContent.count > 240 {
            //no text or too much text
            validationError = true
        }
        else {
            self.selectedTab = 0

            let uid = Auth.auth().currentUser!.uid
            
            db.collection("BlindTiger").document(cleanSchool).collection("users").document(uid).getDocument { [self] (document, error) in
                //if user exists and has a username go onto making the post
                if let document = document, document.exists {
                    let authorusername = document.get("username") as! String

                    
                    
                       //create new post and pass in data
                    let userPost = db.collection("BlindTiger").document(cleanSchool).collection("posts").addDocument(data: ["content" : newPostContent.trimmingCharacters(in: .whitespacesAndNewlines), "authoruid" : uid, "votes" : 0, "anonymous" : isAnonymous, "reports" : 0, "time" : Date(), "authorusername" : authorusername]) { (err) in
                               if err != nil {
                                   //showerror or something
                                   self.dbErr = true
                               }
                               else {
                                           }
                           }

                           //add document id as a field
                           let userPostID = userPost.documentID
                           db.collection("BlindTiger").document(cleanSchool).collection("posts").document(userPostID).setData(["id" : userPostID], merge: true)
                       


                    
                    }

            }
       
    }

}
//    TEST
//    func getAutoPost() {
//        db.collection("BlindTiger").document("bates").collection("posts").order(by: "time", descending: false).limit(to: 1)
//            .start(after: [Timestamp(seconds: Int64(UserDefaults.standard.integer(forKey: "reusedPostTime")), nanoseconds: Int32(UserDefaults.standard.integer(forKey: "reusedPostNanoSecondsTime")))])
//            .getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    let data = document.data()
//
//                    let content = data["content"] as? String ?? ""
//                    let authoruid = data["authoruid"] as? String ?? ""
//                    let time = data["time"] as? Timestamp ?? Timestamp.init()
//                    let anonymous = data["anonymous"] as? Bool ?? true
//                    let votes = data["votes"] as? Int ?? 0
//                    let id = data["id"] as? String ?? ""
//                    let autherusername = data["authorusername"] as? String ?? ""
//                    let reports = data["reports"] as? Int ?? 0
//
//                    return self.reusedPost = post(id: id, content: content, votes: votes, time: time, authoruid: authoruid, anonymous: anonymous, authorusername: autherusername, reports: reports)
//
//
//            }
//    }
//    }
//
//        UserDefaults.standard.set(self.reusedPost.time.seconds, forKey: "reusedPostTime")
//        UserDefaults.standard.set(self.reusedPost.time.nanoseconds, forKey: "reusedPostNanoSecondsTime")
//
//
//
//}
//
//    func postAutoPost(autoSchool: String) {
//        //make sure something is written and its less than 240 charecters
//        if newPostContent.trimmingCharacters(in: .whitespacesAndNewlines) == "" || newPostContent.count > 240 {
//            //no text or too much text
//            validationError = true
//        }
//        else {
//            self.selectedTab = 0
//
//            let uid = Auth.auth().currentUser!.uid
//
//            db.collection("BlindTiger").document(autoSchool).collection("users").document(uid).getDocument { [self] (document, error) in
//                //if user exists and has a username go onto making the post
//                if let document = document, document.exists {
//                    let authorusername = document.get("username") as! String
//
//
//
//                       //create new post and pass in data
//                    let userPost = db.collection("BlindTiger").document(autoSchool).collection("posts").addDocument(data: ["content" : newPostContent.trimmingCharacters(in: .whitespacesAndNewlines), "authoruid" : uid, "votes" : Int.random(in: -5...50), "anonymous" : isAnonymous, "reports" : 0, "time" : Date(), "authorusername" : authorusername]) { (err) in
//                               if err != nil {
//                                   //showerror or something
//                                   self.dbErr = true
//                               }
//                               else {}
//                           }
//
//                           //add document id as a field
//                           let userPostID = userPost.documentID
//                           db.collection("BlindTiger").document(autoSchool).collection("posts").document(userPostID).setData(["id" : userPostID], merge: true)
//
//
//
//
//                    }
//
//            }
//
//    }
//
//
//}
//

    
    
}
