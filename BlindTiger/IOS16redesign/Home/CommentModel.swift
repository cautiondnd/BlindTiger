//
//  CommentModel.swift
//  BlindTiger
//
//  Created by dante  delgado on 6/21/22.
//

import Foundation
import SwiftUI
import Firebase

class CommentModel: ObservableObject {
    @Published var comments = [post]()
    @Published var newCommentContent = ""
    var db = Firestore.firestore()
    @Published var initialLoading = true


    func fetchCommentData(id: String, selectedSchool: String) {
        
        db.collection("BlindTiger").document("\(selectedSchool)").collection("posts").document(id).collection("comments").order(by: "time", descending: false).getDocuments() { (query, error) in

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
                    self.db.collection("BlindTiger").document(selectedSchool).collection("posts").document(rootpostid).collection("comments").document(commentid).delete()
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
            
            db.collection("BlindTiger").document(cleanSchool).collection("posts").document("\(id)").updateData(["numComments" : FieldValue.increment(Int64(+1))])

            //GODMODE replace fakeuid
          //  let fakeUID = String(uid.shuffled())
            let userPost = db.collection("BlindTiger").document(cleanSchool).collection("posts").document("\(id)").collection("comments").addDocument(data: ["content" : content, "authoruid" : uid, "votes" : 0, "reports" : 0, "time" : Date(), "postid" : id])

            //add document id as a field
            let userPostID = userPost.documentID
            db.collection("BlindTiger").document(cleanSchool).collection("posts").document("\(id)").collection("comments").document(userPostID).setData(["commentid" : userPostID], merge: true)
            let num = Int.random(in: 0...1)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10)) {self.db.collection("BlindTiger").document(cleanSchool).collection("posts").document(id).collection("comments").document(userPostID).updateData(["votes" : FieldValue.increment(Int64(num))])}

        }


    }
}

struct cardCommentedOn: View {
    var postData: post
    // @Binding var blockedUsers: [String]
    
    
    var body: some View {
        VStack(alignment: HorizontalAlignment.leading, spacing: 5){
                Text(postData.time.dateValue().timeAgoDisplay())
                    .foregroundColor(.gray)
                    .font(.callout)
                    .padding(.leading)
        
            HStack{
                Text(postData.content)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                Text("\(postData.votes)")
                    .font(.title)
                    .lineLimit(1)
                    .allowsTightening(true)
                    .padding(.vertical)
            }.padding(.horizontal)


        }
        .padding(.vertical)
        .background(Rectangle().foregroundColor(.white).shadow(color: Color.black.opacity(0.15), radius: 6))
        
    }

    
}


