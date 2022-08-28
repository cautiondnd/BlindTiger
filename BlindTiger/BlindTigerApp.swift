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
import CryptoKit
import AuthenticationServices


@main
struct BlindTigerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @State var selected = 0
    
    var body: some Scene {
        WindowGroup {
          
            let hasSignedIn = UserDefaults.standard.bool(forKey: "hasSignedIn")
            if hasSignedIn == true {
                TabBarView()
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
    
    @Published var nonce = ""
    
    func appleAuthinticate(credential: ASAuthorizationAppleIDCredential) {
        
        guard let token = credential.identityToken else {
            print("error w firebase")
            return
        }
        
        guard let tokenString = String(data: token, encoding: .utf8) else {
            print("error with Token")
            return
        }
        
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)
        
        Auth.auth().signIn(with: firebaseCredential) { (result, err) in
            if let error = err {
                print(error.localizedDescription)
                return
            }
            
            //user logged in
            self.validateSignIn()
        }
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
                    UserDefaults.standard.set(cleanSchool, forKey: "cleanSchool")
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

let seperatedEmail = Auth.auth().currentUser?.email?.components(separatedBy: "@").last!.components(separatedBy: ".")
let userSchool = seperatedEmail?[(seperatedEmail?.count ?? 0) -  2] ?? "gmail"
var cleanSchool = UserDefaults.standard.string(forKey: "cleanSchool") ?? userSchool
//var cleanSchool = "vanderbilt"

// helpers for apple signin
func randomNonceString(length: Int = 32) -> String {
  precondition(length > 0)
  let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
  var result = ""
  var remainingLength = length

  while remainingLength > 0 {
    let randoms: [UInt8] = (0 ..< 16).map { _ in
      var random: UInt8 = 0
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }
      return random
    }

    randoms.forEach { random in
      if remainingLength == 0 {
        return
      }

      if random < charset.count {
        result.append(charset[Int(random)])
        remainingLength -= 1
      }
    }
  }

  return result
}

    
private func sha256(_ input: String) -> String {
  let inputData = Data(input.utf8)
  let hashedData = SHA256.hash(data: inputData)
  let hashString = hashedData.compactMap {
    String(format: "%02x", $0)
  }.joined()

  return hashString
}
