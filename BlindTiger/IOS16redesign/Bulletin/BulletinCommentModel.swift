//
//  BulletinCommentModel.swift
//  BlindTiger
//
//  Created by dante  delgado on 7/5/22.
//

import Foundation
import SwiftUI
import Firebase

class BulletinCommentModel: ObservableObject {
    @Published var comments = [post]()
    @Published var newCommentContent = ""
    var db = Firestore.firestore()
    @Published var initialLoading = true
    
    
    func fetchCommentData(id: String) {
        db.collection("BlindTiger").document("\(cleanSchool)").collection("promotions").document(id).collection("comments").order(by: "time", descending: false).getDocuments() { (query, error) in

            guard let documents = query?.documents else{return}

            self.comments = documents.map { (queryDocumentSnapshot) -> post in
                let data = queryDocumentSnapshot.data()

                let content = data["content"] as? String ?? ""
                let authoruid = data["authoruid"] as? String ?? ""
                let time = data["time"] as! Timestamp
                let votes = data["votes"] as? Int ?? 0
                let commentid = data["commentid"] as? String ?? ""
                let rootpostid = data["postid"] as? String ?? ""
                let reports = data["reports"] as? Int ?? 0

                if reports >= 5 {
                    self.db.collection("BlindTiger").document(cleanSchool).collection("promotions").document(rootpostid).collection("comments").document(commentid).delete()
                }

                return post(id: commentid, rootPostID: rootpostid, content: content, votes: votes, time: time, authoruid: authoruid, reports: reports)
            }
            self.initialLoading = false
        }
    }

    func uploadComment(id: String) {
        
        let newLines = newCommentContent.components(separatedBy: "\n").count
        if (newLines > 10 || newCommentContent.count > 280 || newCommentContent.trimmingCharacters(in: .whitespacesAndNewlines) == "") {return}
        else{
            let content = newCommentContent.trimmingCharacters(in: .whitespacesAndNewlines)
            newCommentContent = ""
            let uid = Auth.auth().currentUser!.uid
            db.collection("BlindTiger").document(cleanSchool).collection("promotions").document("\(id)").updateData(["numComments" : FieldValue.increment(Int64(+1))])

            //GODMODE replace uid
          //  let fakeUID = String(uid.shuffled())
            let userPost = db.collection("BlindTiger").document(cleanSchool).collection("promotions").document("\(id)").collection("comments").addDocument(data: ["content" : content, "authoruid" : uid, "votes" : 0, "reports" : 0, "time" : Date(), "postid" : id])

            //add document id as a field
            let userPostID = userPost.documentID
            db.collection("BlindTiger").document(cleanSchool).collection("promotions").document("\(id)").collection("comments").document(userPostID).setData(["commentid" : userPostID], merge: true)
            let num = Int.random(in: 0...2)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10)) {self.db.collection("BlindTiger").document(cleanSchool).collection("promotions").document("\(id)").collection("comments").document(userPostID).updateData(["votes" : FieldValue.increment(Int64(num))])}
            

        }


    }
    
    
    
}

struct promoCommentedOnCard: View {
    var promo: promo
    var body: some View {
        
        VStack{
            HStack{Spacer(); Text(promo.title).font(.title2).bold().multilineTextAlignment(.center) ;Spacer()}
            if !promo.organizer.isEmpty{Text("Organized by: \(promo.organizer)").font(.caption2).foregroundColor(.gray).multilineTextAlignment(.center)}
            
            if promo.theme.isEmpty {
                if #available(iOS 15.0, *) {
                    Text("\(promo.description)\n\(promo.title) is on \(promo.startTime.dateValue().formatted(.dateTime.weekday(.wide).month().day())) from \(promo.startTime.dateValue().formatted(date: .omitted ,time: .shortened)) to \(promo.endTime.dateValue().formatted(date: .omitted ,time: .shortened)) at \(promo.location).")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .padding(.top, 3)
                } else {
                    // Fallback on earlier versions
                    Text("\(promo.description)\n\(promo.title) is on \(promo.startTime.dateValue(), style: .date) from \(promo.startTime.dateValue(), style: .time) to \(promo.endTime.dateValue(), style: .time) at \(promo.location).")
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                            .padding(.top, 3)
                }
            }
            else {
                if #available(iOS 15.0, *) {
                    Text("\(promo.description)\n\(promo.title) is on \(promo.startTime.dateValue().formatted(.dateTime.weekday(.wide).month().day())) from \(promo.startTime.dateValue().formatted(date: .omitted ,time: .shortened)) to \(promo.endTime.dateValue().formatted(date: .omitted ,time: .shortened)) at \(promo.location) and will be \(promo.theme) themed.")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .padding(.top, 3)
                } else {
                    // Fallback on earlier versions
                    Text("\(promo.description)\n\(promo.title) is on \(promo.startTime.dateValue(), style: .date) from \(promo.startTime.dateValue(), style: .time) to \(promo.endTime.dateValue(), style: .time) at \(promo.location) and will be \(promo.theme) themed.")
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                        .padding(.top, 3)
                }
                            }
            
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Rectangle().foregroundColor(.white).shadow(color: Color.black.opacity(0.15), radius: 6))
    }
}
