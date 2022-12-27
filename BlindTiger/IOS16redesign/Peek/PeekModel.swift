//
//  PeekModel.swift
//  BlindTiger
//
//  Created by dante  delgado on 6/21/22.
//

import Foundation

class PeekModel: ObservableObject {
    @Published var schools = [School]()
    @Published var initialLoading = true
    
    func fetchSchools() {
        if schools.isEmpty {
            db.collection("BlindTiger").order(by: "showing").getDocuments { (query, err) in
                
                guard let documents = query?.documents else{return}
                
                self.schools = documents.map { (queryDocumentSnapshot) -> School in
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

    
    

    
}

struct School: Identifiable, Hashable {
    var id: String
    var name: String
    var featured = false
    var showing = false
}

