//
//  SchoolSelectionModel.swift
//  BlindTiger
//
//  Created by dante  delgado on 7/30/22.
//

import SwiftUI
import Firebase


class SchoolSelectModel: ObservableObject {
    @Published var allSchools = [School]()
    @Published var featuredSchools = [School]()
    @Published var initialLoading = true
    
    func fetchSchools() {
        db.collection("BlindTiger").whereField("featured", isEqualTo: true).getDocuments { (query, err) in
            
            guard let documents = query?.documents else{return}
                    
            self.featuredSchools = documents.map { (queryDocumentSnapshot) -> School in
                let data = queryDocumentSnapshot.data()

                let id = queryDocumentSnapshot.documentID
                let name = data["name"] as? String ?? ""
                let featured = data["featured"] as? Bool ?? false
                let showing = data["showing"] as? Bool ?? false
                

                return School(id: id, name: name.capitalized, featured: featured, showing: showing)

            }
        }
        db.collection("BlindTiger").order(by: "name").getDocuments { (query, err) in
            
            guard let documents = query?.documents else{return}
                    
            self.allSchools = documents.map { (queryDocumentSnapshot) -> School in
                let data = queryDocumentSnapshot.data()

                let id = queryDocumentSnapshot.documentID
                let name = data["name"] as? String ?? ""
                let featured = data["featured"] as? Bool ?? false
                let showing = data["showing"] as? Bool ?? false
                

                return School(id: id, name: name.capitalized, featured: featured, showing: showing)

            }
            self.initialLoading = false
        }
    }
    
}
