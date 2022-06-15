////
////  WelcomeViewModel.swift
////  BlindTiger
////
////  Created by dante  delgado on 11/12/20.
////
//
//import SwiftUI
//import Firebase
//
//class WelcomeViewModel: ObservableObject{
//    @Published var fullName = Auth.auth().currentUser?.displayName ?? ""
//    @Published var userName = ""
//    @Published var userNameAlert = false
//    @Published var fullNameAlert = false
//    @Published var goHome = false
//    @Published var goPreLogin = false
//    @Published var validateErrorShowing = false
//    
//    @Published var imageData = Data(count: 0)
//    @Published var showImagePicker = false
//    
//    //make sure that the username is filled out
//    func validate() -> String? {
//        //reset the alerts so it turns off if they fill it out
//        userNameAlert = false
//        fullNameAlert = false
//        
//        if userName.trimmingCharacters(in: .whitespacesAndNewlines) == "" || userName.count < 6 || userName.count > 20 {
//            userNameAlert = true
//        }
//        if fullName.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
//            fullNameAlert = true
//        }
//        if fullNameAlert == true || userNameAlert == true {return String("")}
//        else {
//            return nil
//        }
//    }
//    
//    let db = Firestore.firestore()
//    
//    
//    func getStarted() {
//        // make sure someone is signed in so that we can force unwrap shit
//        if Auth.auth().currentUser == nil {
//            // if somehow no one is signed in go back to prelogin
//            goPreLogin = true
//        }
//        else {
//            
//            let error = validate()
//            if error != nil {
//                // if theres an error show error messages
//                validateErrorShowing = true
//            }
//            
//            else {
//                UserDefaults.standard.set(true, forKey: "hasSignedIn")
//                
//                let uid = Auth.auth().currentUser!.uid
//                
//                
//                // add a name field to school doc if its not there already so its not empty
//                db.collection("BlindTiger").document(cleanSchool).setData([
//                    "name": cleanSchool
//                ])
//                // create user in apropraite school and add url to user document
//
//                UploadImage(imageData: imageData) { [self] (url) in
//                    db.collection("BlindTiger").document(cleanSchool).collection("users").document(uid).setData([
//                        
//                        "fullname": fullName,
//                        "username": userName,
//                        "uid": uid,
//                        "email": Auth.auth().currentUser?.email ?? "",
//                        "dateCreated": Date(),
//                        "imageurl": url
//                        
//                    ]) { err in
//                        if err != nil {
//                            //if something goes wrong in creating user go to prelogin
//                            goPreLogin = false
//                        } else {
//                            self.goHome = true
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
