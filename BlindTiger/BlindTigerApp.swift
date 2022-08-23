//
//  BlindTigerApp.swift
//  BlindTiger
//
//  Created by dante  delgado on 11/2/20.
//

import SwiftUI
import Firebase
import GoogleSignIn
import GoogleMobileAds


@main
struct BlindTigerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @State var selected = 0
    
    var body: some Scene {
        WindowGroup {
          
            let hasSignedIn = UserDefaults.standard.bool(forKey: "hasSignedIn")
            if hasSignedIn == true {
                TabBarView(selectedTab: 0)
            }
            else {
              //  SchoolSelection(info: self.delegate)
                SignInView(info: self.delegate)
            }
            //SchoolSelection(info: self.delegate)
            
//
//
//               if hasSignedIn == false {
//
  //          SchoolSelection()
            
        //  SignInView(info: self.delegate)
//            }
//                        else{
//                            TabBarView(selectedTab: 0)
//                        }
            
        }
        
    }
    
    
}

//initialize firebase
class AppDelegate: NSObject, UIApplicationDelegate, GIDSignInDelegate, ObservableObject {
    
    @Published var showSheet = true
    @Published var goSchoolSelect = false
    @Published var goHome = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        //initialize firebase
        FirebaseApp.configure()
        //initialize google
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        //initialize adMob
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        
        return true
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard let user = user else{return}
        
        let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
        //signing into firebase
        Auth.auth().signIn(with: credential) { (result, err) in
            
            if err != nil {print("couldnt signin"); return}
            self.validateSignIn()
        }
        
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print(error.localizedDescription)
    }
    

    
    func validateSignIn() {
        print("funcran")
        let seperatedEmail = Auth.auth().currentUser?.email?.components(separatedBy: "@").last!.components(separatedBy: ".")
        let school = seperatedEmail![seperatedEmail!.count -  2]
        let uid = Auth.auth().currentUser?.uid
        
        if (Auth.auth().currentUser?.email?.hasSuffix(".edu"))! {
            db.collection("BlindTiger").document(school).collection("users").document(uid!).setData([
                "username": Auth.auth().currentUser?.displayName ?? "",
                "uid": uid ?? "",
                "email": Auth.auth().currentUser?.email ?? "",
                "dateCreated": Date(),
                "cleanSchool": school
            ], merge: true)
            showSheet = false
            goHome = true
            cleanSchool = school
            UserDefaults.standard.set(cleanSchool, forKey: "cleanSchool")
            UserDefaults.standard.set(true, forKey: "hasSignedIn")
        }
        else {
            db.collectionGroup("users").whereField("uid", isEqualTo: Auth.auth().currentUser!.uid).order(by: "cleanSchool", descending: false).getDocuments { querySnap, err in
                if (((querySnap?.documents.last?.exists)) != nil) {
                    print(querySnap?.documents.last?.data()["cleanSchool"] as? String ?? "gmail")
                    cleanSchool = (querySnap?.documents.last?.data()["cleanSchool"] as? String ?? "gmail")
                    self.showSheet = false
                    self.goHome = true
                    UserDefaults.standard.set(true, forKey: "hasSignedIn")
                }
                else {
                    self.goSchoolSelect = true
                }
            }
        }
    }
    
    func createUserSchoolSelect(selectedSchool: String) {
        cleanSchool = selectedSchool;
        UserDefaults.standard.set(selectedSchool, forKey: "cleanSchool")
        db.collection("BlindTiger").document(cleanSchool).collection("users").document(Auth.auth().currentUser!.uid).setData([
            "username": Auth.auth().currentUser?.displayName ?? "",
            "uid": Auth.auth().currentUser?.uid ?? "",
            "email": Auth.auth().currentUser?.email ?? "",
            "dateCreated": Date(),
            "cleanSchool": selectedSchool])
        UserDefaults.standard.set(true, forKey: "hasSignedIn")
        showSheet = false
        goHome = true
    }
    
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


let db = Firestore.firestore()
//drop everything up to @
//let email = Auth.auth().currentUser?.email?.drop(while: { (Character) -> Bool in
//    return Character != "@"
//})
//
//var currentSchool = email?.dropLast(4).drop(while: { (Character) -> Bool in
//    if (email?.filter({ $0 == "." }).count)! > 1 {
//        //if theres multiple . then delete everything up to the first one
//        return Character != "."
//    }
//    else{
//        //if not then delete everything up to the @
//        return Character != "@"
//    }
//}).dropFirst(1)
//
let seperatedEmail = Auth.auth().currentUser?.email?.components(separatedBy: "@").last!.components(separatedBy: ".")
let userSchool = seperatedEmail?[(seperatedEmail?.count ?? 0) -  2] ?? "gmail"
var cleanSchool = UserDefaults.standard.string(forKey: "cleanSchool") ?? userSchool
//var cleanSchool = "vanderbilt"

