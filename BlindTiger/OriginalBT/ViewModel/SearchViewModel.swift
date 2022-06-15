////
////  SearchViewModel.swift
////  BlindTiger
////
////  Created by dante  delgado on 11/28/20.
////
//
//import SwiftUI
//import Firebase
//
//class SearchViewModel: ObservableObject {
//   // @Published var schools = Set<School>()
//    @Published var notEmptySchools = Set<School>()
//    func fetchSearchData() {
//        db.collection("BlindTiger").addSnapshotListener { (querySnapshot, error) in
//            //make sure something is in posts
//            guard let documents = querySnapshot?.documents
//            else{
//                print("no documents")
//                return
//            }
//            for doc in documents {
//                db.collection("BlindTiger").document(doc.documentID).collection("posts").limit(to: 1).getDocuments { querySnapshot, error in
//                    if querySnapshot?.isEmpty == false {
//                        if doc.documentID.lowercased() != cleanSchool.lowercased() {
//                        var name = doc.documentID.capitalized
//                        if name.count < 4 {name = name.uppercased()}
//                        
//                        self.notEmptySchools.insert(School(id: name, name: name))}}
//                }
//            }
//            
//            //not using the map underneath anymore but keeping it incase there are problems
//            // map data to a post struct
////            self.schools.formUnion( documents.map { (queryDocumentSnapshot) -> School in
////                
////                
////                var name = queryDocumentSnapshot.documentID.capitalized
////                if name.count < 4 {name = name.uppercased()}
////                
////                return School(id: name, name: name)
////                
////            })
//            
//        }
//        
//    }
//}
//
//struct School: Identifiable, Hashable {
//    var id: String
//    var name: String
//}
