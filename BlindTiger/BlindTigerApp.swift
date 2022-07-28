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
            
            TabBarView(info: AppDelegate(), selectedTab: 0)
//            let hasSignedIn = UserDefaults.standard.bool(forKey: "hasSignedIn")
//
//
//               if hasSignedIn == false {
//
//            SignInView()
//            }
//                        else{
//                            TabBarView(selectedTab: 0)
//                        }
            
        }
        
    }
    
    
}

//initialize firebase
class AppDelegate: NSObject, UIApplicationDelegate, GIDSignInDelegate, ObservableObject {
    
    
    @Published var hasNotSignedIn = true
    @Published var showAlert = false

    
    
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
            
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            else{
                let uid = Auth.auth().currentUser?.uid
                
                if (Auth.auth().currentUser?.email?.hasSuffix(".edu"))! || Auth.auth().currentUser?.email == "blindtigertesting@gmail.com"{
                 
                    db.collection("BlindTiger").document(cleanSchool).collection("users").document(uid!).setData([
                        
                        "username": Auth.auth().currentUser?.displayName ?? "",
                        "uid": uid ?? "",
                        "email": Auth.auth().currentUser?.email ?? "",
                        "dateCreated": Date(),
                        
                    ]) { err in
                        if err != nil {}
                        else {self.hasNotSignedIn = false; print("acc created")}
                    }
                }
                else {
                    self.showAlert = true; print("alert showing")
                }
                
            }
        }
        
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print(error.localizedDescription)
    }
    
    
}


let db = Firestore.firestore()
//drop everything up to @
let email = Auth.auth().currentUser?.email?.drop(while: { (Character) -> Bool in
    return Character != "@"
})

var currentSchool = email?.dropLast(4).drop(while: { (Character) -> Bool in
    if (email?.filter({ $0 == "." }).count)! > 1 {
        //if theres multiple . then delete everything up to the first one
        return Character != "."
    }
    else{
        //if not then delete everything up to the @
        return Character != "@"
    }
}).dropFirst(1)


//let cleanSchool = String(currentSchool ?? "")
var cleanSchool = "vanderbilt"

