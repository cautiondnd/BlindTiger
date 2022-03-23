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
            
               if hasSignedIn == false {
            
            PreLoginView(info: self.delegate)
            }
                        else{
                            TabBar(selectedTab: 0)
                        }
            
        }
        
    }
    
    
}


//initialize firebase
class AppDelegate: NSObject, UIApplicationDelegate, GIDSignInDelegate, ObservableObject {
    
    
    
    @Published var showAlert = false
    @Published var goWelcome = false
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
            
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            else{
                let uid = Auth.auth().currentUser?.uid
                
                if (Auth.auth().currentUser?.email?.hasSuffix(".edu"))! || Auth.auth().currentUser?.email == "blindtigertesting@gmail.com"{
                    db.collection("BlindTiger").document(cleanSchool).collection("users").document(uid!).getDocument { (document, error) in
                        if let document = document, document.exists {
                            self.goHome = true;
                            UserDefaults.standard.set(true, forKey: "hasSignedIn")
                        } else {
                            self.goWelcome = true
                        }
                    }
                }
                else {
                    self.showAlert = true
                }
                
            }
        }
        
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print(error.localizedDescription)
    }
    
    
}



