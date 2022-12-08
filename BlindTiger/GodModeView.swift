//
//  GodModeView.swift
//  BlindTiger
//
//  Created by dante  delgado on 8/30/22.
//

import SwiftUI
import Firebase

struct GodModeView: View {
    @State var belmontUsers = 797
    @State var batesUsers = 2269
    @State var americanUsers = 20
    @State var fordhamUsers = 210
    @State var vanderbiltUsers = 4
    @State var berkleeUsers = 0
    

    var body: some View {
        VStack{
            HStack{
                VStack{
                    Button(action: {cleanSchool = "bates"}, label: {Text("Bates")})
                    Text("\(batesUsers)").padding().background(RoundedRectangle(cornerRadius: 10).foregroundColor(.gray))
                }
                Spacer()
                VStack{
                    Button(action: {cleanSchool = "belmont"}, label: {Text("Belmont")})
                    Text("\(belmontUsers)").padding().background(RoundedRectangle(cornerRadius: 10).foregroundColor(.gray))
                    
                }
                Spacer()
                VStack{
                    Button(action: {cleanSchool = "american"}, label: {Text("American")})
                    Text("\(americanUsers)").padding().background(RoundedRectangle(cornerRadius: 10).foregroundColor(.gray))
                }
            }
            HStack{
                Spacer()
                VStack{
                    Button(action: {cleanSchool = "vanderbilt"}, label: {Text("Vanderbilt")})
                    Text("\(vanderbiltUsers)").padding().background(RoundedRectangle(cornerRadius: 10).foregroundColor(.gray))
                }
                Spacer()
                VStack{
                    Button(action: {cleanSchool = "fordham"}, label: {Text("Fordham")})
                    Text("\(fordhamUsers)").padding().background(RoundedRectangle(cornerRadius: 10).foregroundColor(.gray))
                }
                Spacer()
                VStack{
                    Button(action: {cleanSchool = "berklee"}, label: {Text("Berklee")})
                    Text("\(berkleeUsers)").padding().background(RoundedRectangle(cornerRadius: 10).foregroundColor(.gray))
                }
            }
                
            
            
            
            Button(action: {
                db.collection("BlindTiger").document("belmont").collection("users").order(by: "dateCreated").whereField("dateCreated", isGreaterThan: Timestamp(date: Date(timeIntervalSince1970: 1664254506))).getDocuments { docs, err in
                    belmontUsers += docs!.count
                }
                db.collection("BlindTiger").document("bates").collection("users").order(by: "dateCreated").whereField("dateCreated", isGreaterThan: Timestamp(date: Date(timeIntervalSince1970: 1664254506))).getDocuments { docs, err in
                    batesUsers += docs!.count
                }
                db.collection("BlindTiger").document("american").collection("users").order(by: "dateCreated").whereField("dateCreated", isGreaterThan: Timestamp(date: Date(timeIntervalSince1970: 1664254506))).getDocuments { docs, err in
                    americanUsers += docs!.count
                }
                db.collection("BlindTiger").document("vanderbilt").collection("users").order(by: "dateCreated").whereField("dateCreated", isGreaterThan: Timestamp(date: Date(timeIntervalSince1970: 1664254506))).getDocuments { docs, err in
                    vanderbiltUsers += docs!.count
                }
                db.collection("BlindTiger").document("fordham").collection("users").order(by: "dateCreated").whereField("dateCreated", isGreaterThan: Timestamp(date: Date(timeIntervalSince1970: 1664254506))).getDocuments { docs, err in
                    fordhamUsers += docs!.count
                }
                db.collection("BlindTiger").document("fordham").collection("users").order(by: "dateCreated").whereField("dateCreated", isGreaterThan: Timestamp(date: Date(timeIntervalSince1970: 1664254506))).getDocuments { docs, err in
                    berkleeUsers += docs!.count
                }
               
                
                
            }, label: {Text("Get Data").capsuleButtonStyle()})
            
        }
        
    }
}

