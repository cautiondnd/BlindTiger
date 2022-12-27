//
//  SchoolSelectionView.swift
//  BlindTiger
//
//  Created by dante  delgado on 7/29/22.
//

import SwiftUI
import Firebase

struct SchoolSelect: View {
    var schools = [School(id: "bates", name: "bates"), School(id: "vanderbilt", name: "vanderbilt")]
    @State var goHome = false
    var body: some View {
        List {
            ForEach (schools) { school in
                NavigationLink(destination: {TabBarView(selectedTab: 0)}) {
                    Button(action: {
                        db.collection("BlindTiger").document(school.name).collection("users").document(Auth.auth().currentUser!.uid).setData([
                            "uid": Auth.auth().currentUser?.uid ?? "",
                            "email": Auth.auth().currentUser?.email ?? "",
                            "dateCreated": Date(),
                            "cleanSchool": school], merge: true) { err in
                                if err != nil {}
                                else {print("acc created")}
                            }
                    }, label: {Text(school.name)})
                }
            }
        }
            
            
        
    }
}

