//
//  RatingsModel.swift
//  BlindTiger
//
//  Created by dante  delgado on 7/11/22.
//

import SwiftUI
import Firebase


class RatingModel: ObservableObject {
    var fullCategoryList = ["All", "Clubs", "Sports", "Greek", "Dorms", "Hobby/Leisure", "Arts", "Campus Serivces", "Academic", "Work Study", "Cultural/Religous", "Political/Charity", "Study Abroad", "Other"]
    var categories = ["Sports", "Greek", "Dorms", "Hobby/Leisure", "Arts", "Campus Serivces", "Academic", "Work Study", "Cultural/Religous", "Political/Charity", "Study Abroad", "Other"]
    @Published var orgCategoryFeeds = [[org](), [org](), [org](), [org](), [org](), [org](), [org](), [org](), [org](), [org](), [org](), [org]()]
    @Published var categoryLoading = [true, true, true, true, true, true, true, true, true, true, true, true]

    @Published var allOrgs = [org]()
    @Published var clubs = [org]()
        
    @Published var searchOrgs = [org]()
    @Published var searchLoading = true
    
//    @Published var greek = [org]()
//    @Published var dorms = [org]()
//    @Published var services = [org]()
//    @Published var abroad = [org]()
//    @Published var achademicClubs = [org]()
//    @Published var recClubs = [org]()
//    @Published var religousClubs = [org]()
//    @Published var otherClubs = [org]()
//    @Published var other = [org]()
    @Published var clubLoading = true
    
    @Published var initialLoading = true
    @Published var orgSearch = ""
    @Published var filterTab = "All"
    
    @Published var title = ""
    @Published var description = ""
    @Published var category = ""
    
    
    func fetchAllData() {
        //FETCH FOR RECENT THREAD
        if allOrgs.isEmpty {
            db.collection("BlindTiger").document("\(cleanSchool)").collection("reviews").order(by: "numRatings", descending: true).limit(to: 10).getDocuments { query, error in
                guard let documents = query?.documents else{return}
                
                self.allOrgs = documents.map { (queryDocumentSnapshot) -> org in
                    let data = queryDocumentSnapshot.data()
                    
                    let numRatings = data["numRatings"] as? Int ?? 0
                    let title = data["title"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    let totRating = data["totRating"] as? Int ?? 0
                    let id = data["id"] as? String ?? ""
                    let category = data["category"] as? String ?? ""
                    
                    
                    return org(title: title, description: description, id: id, totRating: totRating, numRatings: numRatings, category: category)
                }
                self.initialLoading = false
            }
        }
    }
    
    @Published var loadingMoreAllOrgs = false
    @Published var noMoreAllOrgs = false
    func moreAllOrgs() {
        db.collection("BlindTiger").document(cleanSchool).collection("reviews").document(allOrgs.last?.id ?? "x").addSnapshotListener { doc, err in
            guard let lastDoc = doc else {return}
            db.collection("BlindTiger").document("\(cleanSchool)").collection("reviews").order(by: "numRatings", descending: true).start(afterDocument: lastDoc).limit(to: 20).getDocuments { query, error in
                guard let documents = query?.documents else{return}

                let newOrgs = documents.map { (queryDocumentSnapshot) -> org in
                    let data = queryDocumentSnapshot.data()

                    let numRatings = data["numRatings"] as? Int ?? 0
                    let title = data["title"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    let totRating = data["totRating"] as? Int ?? 0
                    let id = data["id"] as? String ?? ""
                    let category = data["category"] as? String ?? ""


                    return org(title: title, description: description, id: id, totRating: totRating, numRatings: numRatings, category: category)
                }
                self.allOrgs.append(contentsOf: newOrgs)
                self.loadingMoreAllOrgs = false
                if newOrgs.count < 10 {self.noMoreAllOrgs = true}
            }
        }
    }
    
    
    func fetchClubData() {
        
        //FETCH FOR RECENT THREAD
        if clubs.isEmpty{
            db.collection("BlindTiger").document("\(cleanSchool)").collection("reviews").whereField("category", in: ["Achademic", "Arts", "Cultural/Religous", "Hobby/Leisure", "Political/Advocacy"]).order(by: "numRatings", descending: true).limit(to: 10).getDocuments { query, error in
                guard let documents = query?.documents else{return}
                
                self.clubs = documents.map { (queryDocumentSnapshot) -> org in
                    let data = queryDocumentSnapshot.data()
                    
                    let numRatings = data["numRatings"] as? Int ?? 0
                    let title = data["title"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    let totRating = data["totRating"] as? Int ?? 0
                    let id = data["id"] as? String ?? ""
                    let category = data["category"] as? String ?? ""
                    
                    
                    return org(title: title, description: description, id: id, totRating: totRating, numRatings: numRatings, category: category)
                }
                self.clubLoading = false
            }
        }
    }
    
    @Published var loadingMoreClubs = false
    @Published var noMoreClubs = false
    func moreClubOrgs() {
        db.collection("BlindTiger").document(cleanSchool).collection("reviews").document(clubs.last?.id ?? "x").addSnapshotListener { doc, err in
            guard let lastDoc = doc else {return}
            db.collection("BlindTiger").document("\(cleanSchool)").collection("reviews").whereField("category", in: ["Achademic", "Arts", "Cultural/Religous", "Hobby/Leisure", "Political/Advocacy"]).order(by: "numRatings", descending: true).start(afterDocument: lastDoc).limit(to: 20).getDocuments { query, error in
                guard let documents = query?.documents else{return}

                let newOrgs = documents.map { (queryDocumentSnapshot) -> org in
                    let data = queryDocumentSnapshot.data()

                    let numRatings = data["numRatings"] as? Int ?? 0
                    let title = data["title"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    let totRating = data["totRating"] as? Int ?? 0
                    let id = data["id"] as? String ?? ""
                    let category = data["category"] as? String ?? ""


                    return org(title: title, description: description, id: id, totRating: totRating, numRatings: numRatings, category: category)
                }
                self.clubs.append(contentsOf: newOrgs)
                if newOrgs.count < 10 {self.noMoreClubs = true}
                self.loadingMoreClubs = false
            }
        }
    }
    
    func fetchCategoryData(feedNum: Int) {
        //FETCH FOR RECENT THREAD
        if orgCategoryFeeds[feedNum].isEmpty{
            db.collection("BlindTiger").document("\(cleanSchool)").collection("reviews").whereField("category", isEqualTo: categories[feedNum]).order(by: "numRatings", descending: true).limit(to: 10).getDocuments { query, error in
                guard let documents = query?.documents else{return}
                
                self.orgCategoryFeeds[feedNum] = documents.map { (queryDocumentSnapshot) -> org in
                    let data = queryDocumentSnapshot.data()
                    
                    let numRatings = data["numRatings"] as? Int ?? 0
                    let title = data["title"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    let totRating = data["totRating"] as? Int ?? 0
                    let id = data["id"] as? String ?? ""
                    let category = data["category"] as? String ?? ""
                    
                    
                    return org(title: title, description: description, id: id, totRating: totRating, numRatings: numRatings, category: category)
                }
                self.categoryLoading[feedNum] = false
            }
        }
    }
    
    @Published var loadingMoreCategoryOrgs = [false, false, false, false, false, false, false, false, false, false, false, false]
    @Published var noMoreCategoryOrgs = [false, false, false, false, false, false, false, false, false, false, false, false]
    func moreCategoryOrgs(feedNum: Int) {
        db.collection("BlindTiger").document(cleanSchool).collection("reviews").document(orgCategoryFeeds[feedNum].last?.id ?? "x").addSnapshotListener { doc, err in
            guard let lastDoc = doc else {return}
            db.collection("BlindTiger").document("\(cleanSchool)").collection("reviews").whereField("category", isEqualTo: self.categories[feedNum]).order(by: "numRatings", descending: true).start(afterDocument: lastDoc).limit(to: 20).getDocuments { query, error in
                guard let documents = query?.documents else{return}

                let newOrgs = documents.map { (queryDocumentSnapshot) -> org in
                    let data = queryDocumentSnapshot.data()

                    let numRatings = data["numRatings"] as? Int ?? 0
                    let title = data["title"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    let totRating = data["totRating"] as? Int ?? 0
                    let id = data["id"] as? String ?? ""
                    let category = data["category"] as? String ?? ""


                    return org(title: title, description: description, id: id, totRating: totRating, numRatings: numRatings, category: category)
                }
                self.orgCategoryFeeds[feedNum].append(contentsOf: newOrgs)
                self.loadingMoreCategoryOrgs[feedNum] = false
                if newOrgs.count < 10 {self.noMoreCategoryOrgs[feedNum] = true}
            }
        }
    }
    
    func fetchSearchData() {
        if searchOrgs.isEmpty {
            db.collection("BlindTiger").document("\(cleanSchool)").collection("reviews").order(by: "numRatings", descending: true).getDocuments { query, error in
                guard let documents = query?.documents else{return}
                
                self.searchOrgs = documents.map { (queryDocumentSnapshot) -> org in
                    let data = queryDocumentSnapshot.data()
                    
                    let numRatings = data["numRatings"] as? Int ?? 0
                    let title = data["title"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    let totRating = data["totRating"] as? Int ?? 0
                    let id = data["id"] as? String ?? ""
                    let category = data["category"] as? String ?? ""
                    
                    
                  
                    
                    return org(title: title, description: description, id: id, totRating: totRating, numRatings: numRatings, category: category)
                }
                self.searchLoading = false
            }
        }
    }
    @Published var newOrg = org(title: "", description: "", id: "", totRating: 0, numRatings: 0, category: "")
    func uploadOrg() {

        let userPost = db.collection("BlindTiger").document(cleanSchool).collection("reviews").addDocument(data: ["title" : title, "description": description, "category": category, "numRatings": 0, "totRating": 0])


               //add document id as a field
               let newPostId = userPost.documentID
               db.collection("BlindTiger").document(cleanSchool).collection("reviews").document(newPostId).setData(["id" : newPostId], merge: true)
        newOrg = org(title: title, description: description, id: newPostId, totRating: 0, numRatings: 0, category: category)
        filterTab = "All"
        
        title = ""
        description = ""
        category = ""
    }
    
    func refreshHomeData() {
        db.collection("BlindTiger").document("\(cleanSchool)").collection("reviews").order(by: "numRatings", descending: true).limit(to: 10).getDocuments { query, error in
            guard let documents = query?.documents else{return}
            
            self.allOrgs = documents.map { (queryDocumentSnapshot) -> org in
                let data = queryDocumentSnapshot.data()
                
                let numRatings = data["numRatings"] as? Int ?? 0
                let title = data["title"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let totRating = data["totRating"] as? Int ?? 0
                let id = data["id"] as? String ?? ""
                let category = data["category"] as? String ?? ""
                
                
                return org(title: title, description: description, id: id, totRating: totRating, numRatings: numRatings, category: category)
            }
            self.initialLoading = false
        }
    }
    
    @Published var allFieldsValid = true
    func validateFields() {
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            title.trimmingCharacters(in: .whitespacesAndNewlines).count > 50 ||
            description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            description.trimmingCharacters(in: .whitespacesAndNewlines).count > 500 ||
            category.isEmpty {
            allFieldsValid = false
        }
        else{allFieldsValid = true}
    }
}
