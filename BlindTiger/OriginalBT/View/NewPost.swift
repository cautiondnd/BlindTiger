////
////  NewPost.swift
////  Slots Demo
////
////  Created by dante  delgado on 11/17/20.
////
//
//import SwiftUI
//
//struct NewPost: View {
//    @ObservedObject var newPostData = NewPostViewModel()
//    @Binding var selectedTab: Int
//    @State private var buttonPressed = false
//    @State var showNotAnonymousAlert = false
//
//    var body: some View {
//        NavigationView{
//        ZStack{
//            Rectangle().foregroundColor(.customGray).ignoresSafeArea(edges: .all)
//        VStack{
//            HStack{
//                Spacer()
//                Button(action: {
//                        if newPostData.isAnonymous == false
//                        { if newPostData.validationError == false
//                                {showNotAnonymousAlert = true} }
//                        else {
//                            newPostData.newPost()
//                            self.selectedTab = newPostData.selectedTab
//                           
//                        };
//                        buttonPressed = true
//                    
//                }, label: {
//                    Text("Post")
//                        .font(.title3)
//                        .fontWeight(.bold)
//                        .foregroundColor(.customOrange)
//                        .padding([.leading, .bottom, .trailing])
//                    
//                    
//                })
//// shouldnt ever be called btu just in case
//                    .alert(isPresented: $newPostData.dbErr, content: {
//                        Alert(title: Text("Something Went Wrong"), message: Text("Something went wrong on our end :( Please try again in a few minutes."), dismissButton: .default(Text("OK")))
//                    })
//            }
//            ZStack(alignment: Alignment.leading){
//            TextEditor(text: $newPostData.newPostContent)
//                    .frame(maxWidth: .infinity, maxHeight: 200, alignment: .center).padding()
//                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white).shadow(radius: 10))
//                if newPostData.newPostContent == "" {
//                    Text("Whats on your mind?").foregroundColor(.gray).padding(.leading).offset(y: -81).padding(.leading, 5)}
//            }
//            
//            HStack{
//                
//                if newPostData.newPostContent.trimmingCharacters(in: .whitespacesAndNewlines) == "" && buttonPressed == true
//                {Text("Must be filled out").font(.caption).foregroundColor(.red)}
//                
//                Spacer()
//                ZStack{
//                    Text("\(newPostData.newPostContent.count)/240")
//                        .foregroundColor(newPostData.newPostContent.count > 240 ? .red : .gray)
//                }
//                Text(".").foregroundColor(.clear)
//                
//                    
//                
//                }
//            Toggle(isOn: $newPostData.isAnonymous, label: {
//                Text("Post Anonymously?")
//            }).toggleStyle(SwitchToggleStyle(tint: Color.customOrange))
//
//            Spacer()
//            
//        }.padding()
//     
//            
//            
//            VStack{
//                
//                Spacer()
//                
//                //TEST
////                Button(action: {
////                    //
////                   // newPostData.postAutoPost(autoSchool: "bc")
////                   // newPostData.postAutoPost(autoSchool: "umich")
////                   // newPostData.postAutoPost(autoSchool: "virginia")
////                    newPostData.postAutoPost(autoSchool: "belmont")
////                  //  newPostData.postAutoPost(autoSchool: "umd")
////
////                }, label: {
////                    //
////                    Text("post to belmont").padding().background(Color.green)
////                })
//                
////                Button(action: {newPostData.getAutoPost()
////                    newPostData.newPostContent = newPostData.reusedPost.content
////                        print(newPostData.reusedPost)
////                    
////                }, label: {
////                    Text("get new post").padding().background(Color.blue)
////                })
////                Button(action: {UserDefaults.standard.set(1615668997, forKey: "reusedPostTime")}, label: {
////                    Text("reset")
////                })
////                
//                //TEST
//                
//                Text("Contact Us: BlindTigerApp@gmail.com").foregroundColor(.gray).font(.caption).padding()}.ignoresSafeArea(.keyboard, edges: .bottom)
//    }
//        //put away keyboard on tap
//        .onTapGesture {
//        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//    }
//        //take away error msgs on disappear
//        .onDisappear(){ buttonPressed = false}
//        .navigationBarHidden(true)
//        }
//        .navigationBarHidden(true)
//        .alert(isPresented: $showNotAnonymousAlert, content: {
//                Alert(title: Text("Post Publicly?"), message: Text("This post will not be anonymous and your username will be displayed."), primaryButton: .default(Text("Cancel")) {showNotAnonymousAlert = false}, secondaryButton: .default(Text("Post").fontWeight(.bold).foregroundColor(.customOrange)) { newPostData.newPost();
//                        self.selectedTab = newPostData.selectedTab} )})
//        
//
//    }
//}
//
//
//
