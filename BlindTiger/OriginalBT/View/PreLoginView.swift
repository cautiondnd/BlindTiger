////
////  PreLoginView.swift
////  BlindTiger
////
////  Created by dante  delgado on 11/2/20.
////
//
//import SwiftUI
//import GoogleSignIn
//import Firebase
//
//struct PreLoginView: View {
//    
//    @ObservedObject var info : AppDelegate
//    
//    var body: some View {
//        
//        NavigationView{
//            VStack{
//                Image("tiger")
//                    .resizable()
//                    .frame(width: 100, height: 100)
//                Image("logoscript")
//                    .resizable()
//                    .frame(width: 200, height: 50).offset(y: -10)
//                VStack(alignment: HorizontalAlignment.leading){
//                    HStack{
//                        Image(systemName: "person.fill.questionmark").font(.title2).foregroundColor(.black)
//                        
//                        
//                        Text("Choose whether to post anonymously or display your username.")
//                            .font(.subheadline)
//                            .fontWeight(.medium)
//                            .allowsTightening(true)
//                        
//                    }.padding()
//                    HStack{
//                        Image(systemName: "graduationcap").font(.title2).foregroundColor(.black)
//                        
//                        Text("Post to a private feed of only people that go to your school.")
//                            .font(.subheadline)
//                            .fontWeight(.medium)
//                            .allowsTightening(true)
//                    }.padding(.horizontal)
//                    HStack{
//                        Image(systemName: "eyes").font(.title2).foregroundColor(.black)
//                        
//                        Text("Peek on other feeds to see whats happening at diffrent schools.")
//                            .font(.subheadline)
//                            .fontWeight(.medium)
//                            .allowsTightening(true)
//                        
//                    }.padding()
//                }
//                Spacer()
//                Text("Please register using a school affiliated email ending in '.edu'")
//                    .font(.caption)
//                    .foregroundColor(.black)
//                    .opacity(0.8)
//                    .multilineTextAlignment(.center)
//                Button(action: {
//                    googleSignin();
//                     }, label: {
//                    HStack{
//                        Spacer()
//                        Image("google-icon").resizable().frame(width: 15, height: 15)
//                        Text("Continue With Google")
//                            .foregroundColor(.white)
//                        Spacer()
//                    }.padding(.vertical)
//                    .background(Capsule().foregroundColor(.darkModeforeground))
//                    
//                    
//                })
//                
//                
//                NavigationLink(destination: Welcome(), isActive: $info.goWelcome) {
//                    EmptyView()}
//                NavigationLink(destination: TabBar(selectedTab: 0), isActive: $info.goHome) {
//                    EmptyView()}
//                
//                
//                
//            }.padding()
//            .background(Image("bg").resizable().ignoresSafeArea(.all))
//            .alert(isPresented: $info.showAlert, content: {
//                Alert(title: Text("Invalid Email"), message: Text("Please use a school affiliated email ending in '.edu'"), dismissButton: .default(Text("OK")))
//            })
//            
//            .navigationBarHidden(true)
//        }.navigationBarHidden(true)
//        
//    }
//    
//    
//    func googleSignin() {
//        
//        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
//        
//        GIDSignIn.sharedInstance()?.signIn()
//    }
//    
//    
//}
//
//
//
//
//
//
//
