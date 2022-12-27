//
//  BulletinModel.swift
//  BlindTiger
//
//  Created by dante  delgado on 6/24/22.
//

import Foundation
import SwiftUI
import Firebase


class BulletinModel: ObservableObject {
    @Published var promos = [promo]()
    @Published var initialLoading = true
    let db = Firestore.firestore()

    
    @Published var title = ""
    @Published var organizer = ""
    @Published var location = ""
    @Published var description = ""
    @Published var theme = ""
    @Published var startTime = Date()
    @Published var endTime = Date()
    
    let uid = Auth.auth().currentUser?.uid

    
    func uploadPromo() {
        if (title.trimmingCharacters(in: .whitespacesAndNewlines) == "" || location.trimmingCharacters(in: .whitespacesAndNewlines) == "") {return}
        else{
            while (startTime.timeIntervalSince(endTime) > 86400) {endTime = endTime.addingTimeInterval(86400)}
            if startTime > endTime {endTime = endTime.addingTimeInterval(86400)}

            let userPost = db.collection("BlindTiger").document(cleanSchool).collection("promotions").addDocument(data: ["title" : title, "authoruid" : uid ?? "", "votes" : 0, "reports" : 0, "startTime" : startTime, "endTime": endTime, "description": description, "organizer": organizer, "location": location, "theme": theme, "numComments": 0])

                   //add document id as a field
                   let userPostID = userPost.documentID
                   db.collection("BlindTiger").document(cleanSchool).collection("promotions").document(userPostID).setData(["id" : userPostID], merge: true)
            let num = Int.random(in: 0...2)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10)) {self.db.collection("BlindTiger").document(cleanSchool).collection("promotions").document(userPostID).updateData(["votes" : FieldValue.increment(Int64(num))])}
            
            title = ""
            organizer = ""
            location = ""
            description = ""
            theme = ""
            startTime = Date()
            endTime = Date()

        }
    }
    
    @Published var allFieldsValid = true
    func validateFields() {
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            title.trimmingCharacters(in: .whitespacesAndNewlines).count > 50 ||
            location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            location.trimmingCharacters(in: .whitespacesAndNewlines).count > 50 ||
            description.trimmingCharacters(in: .whitespacesAndNewlines).count > 280 ||
            organizer.trimmingCharacters(in: .whitespacesAndNewlines).count > 50 ||
            theme.trimmingCharacters(in: .whitespacesAndNewlines).count > 50 ||
            abs(endTime.timeIntervalSince(startTime).rounded(.towardZero).truncatingRemainder(dividingBy: 86400)) < 60 ||
            abs(endTime.timeIntervalSince(startTime).rounded(.towardZero).truncatingRemainder(dividingBy: 86400)) > 86340
        {
            allFieldsValid = false
        }
        else{allFieldsValid = true}
    }

    
    
    func fetchData() {
        if promos.isEmpty {
        //FETCH FOR RECENT THREAD
            db.collection("BlindTiger").document("\(cleanSchool)").collection("promotions").whereField("endTime", isGreaterThan: Timestamp()).getDocuments { query, error in
                guard let documents = query?.documents else{return}
                
                self.promos = documents.map { (queryDocumentSnapshot) -> promo in
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
                    let numComments = data["numComments"] as? Int ?? 0
                    
                    if reports >= 5 {
                        self.db.collection("BlindTiger").document(cleanSchool).collection("promotions").document(id).delete()
                    }
                    
                    return promo(title: title, startTime: startTime, endTime: endTime, votes: votes, id: id, authoruid: authoruid, reports: reports, description: description, organizer: organizer, location: location, theme: theme, numComments: numComments)
                }
                self.initialLoading = false
            }
        }
    }
    
    
    @Published var refreshing: Bool = false {

        didSet {
            if oldValue == false && refreshing == true {
                self.load()
            }
        }
    }

    func load() {
            self.refreshData();
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {self.refreshing = false}
    }

    func refreshData() {
        db.collection("BlindTiger").document("\(cleanSchool)").collection("promotions").whereField("endTime", isGreaterThan: Timestamp()).getDocuments { query, error in
            guard let documents = query?.documents else{return}
            
            self.promos = documents.map { (queryDocumentSnapshot) -> promo in
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
                let numComments = data["numComments"] as? Int ?? 0
                
                if reports >= 5 {
                    self.db.collection("BlindTiger").document(cleanSchool).collection("promotions").document(id).delete()
                }
                
                return promo(title: title, startTime: startTime, endTime: endTime, votes: votes, id: id, authoruid: authoruid, reports: reports, description: description, organizer: organizer, location: location, theme: theme, numComments: numComments)
            }
        }
    }
}
