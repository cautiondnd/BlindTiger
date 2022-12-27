//
//  SignInView.swift
//  BlindTigerRedesign
//
//  Created by dante  delgado on 3/23/22.
//

import SwiftUI
import GoogleSignIn
import Firebase
import AuthenticationServices
import CryptoKit

struct SignInView: View {
    @ObservedObject var info : AppDelegate
    @State var user = Auth.auth().currentUser
    
    var body: some View {
            NavigationView {
                VStack {
                    signUpHeader
                    VStack(spacing: 20) {
                        signUpDescription(symbol: "graduationcap", description: "Post anonymously to a private feed for your school.")
                        signUpDescription(symbol: "eyes", description: "Peek on other feeds to see whats happening at diffrent schools.")
                        signUpDescription(symbol: "newspaper", description: "Promote on campus events")
                        signUpDescription(symbol: "star.circle", description: "Leave reviews for clubs, dorms, and more.")
                    }
                    Spacer()
                    appleSignInButton
                    googleSignInButton.padding(.bottom)
                    
                    NavigationLink(destination: SchoolSelection(info: info).navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $info.goSchoolSelect) {EmptyView()}
                    NavigationLink(destination: TabBarView().navigationBarBackButtonHidden(true).navigationTitle("").navigationBarHidden(true), isActive: $info.goHome) {EmptyView()}
                }
                .background(Image("bg").resizable().ignoresSafeArea(.all))
                .navigationBarHidden(true)
            }
    }
    
    var signUpHeader: some View {
        VStack(spacing: 0) {
            Image("tiger")
                .resizable()
                .frame(width: 100, height: 100)
            Image("logoscript")
                .resizable()
                .frame(width: 200, height: 50).offset(y: -5)
        }
    }
    var appleSignInButton: some View {
        SignInWithAppleButton { (request) in
            info.nonce = randomNonceString()
            request.requestedScopes = [.email,.fullName]
            request.nonce = SHA256.hash(data: Data(info.nonce.utf8)).compactMap { String(format: "%02x", $0) }.joined()
        } onCompletion: {(result) in
            
            switch result {
            case .success(let user):
                guard let credential = user.credential as? ASAuthorizationAppleIDCredential else{
                print("error with firebase")
                    return
                }
                info.appleAuthinticate(credential: credential)
                
            case.failure(let error):
                print(error)
                
            }
        }.signInWithAppleButtonStyle(.black)
            .clipShape(Capsule())
            .frame(maxWidth: .infinity, maxHeight: 50)
            .padding(.horizontal)
    }
    var googleSignInButton: some View {
        Button(action: {
            googleSignin()
                        
        }, label: {
            HStack{
                Spacer()
                Image("google-icon").resizable().frame(width: 15, height: 15)
                Text("Sign in with Google")
                    .font(Font.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
                Spacer()}
            .frame(maxWidth: .infinity, maxHeight: 50)
                .background(Capsule().foregroundColor(.darkModeforeground))
                .padding(.horizontal)
        })
    }
    
    func googleSignin() {
        
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
        
        GIDSignIn.sharedInstance()?.signIn()
                              
    }
    
}

struct signUpDescription: View {
    var symbol: String
    var description: String
    
    var body: some View{
        HStack(spacing:0){
            Image(systemName: symbol).font(.title2).foregroundColor(.black).frame(width: 20, height:20).padding(.leading)
            
            Text(description)
                .font(.callout)
                .fontWeight(.medium)
                .allowsTightening(true)
                .padding(.leading)
            Spacer()

        }
        .padding(.horizontal)
        //.padding(.top, 20)
    }
}
