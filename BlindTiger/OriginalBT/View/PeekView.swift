////
////  PeekView.swift
////  BlindTiger
////
////  Created by dante  delgado on 11/28/20.
////
//
//import SwiftUI
//import GoogleMobileAds
//
//
//struct PeekView: View {
//    @State var selected = 0
//    
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    @ObservedObject var peekData = peekViewModel()
//    var selectedSchool: String
//    @Binding var peekBlockedUsers: [String]
//
//    
//    
//    var peekPosts: [post] {
//        if selected == 0 {
//            return peekData.peekPosts.sorted(by: { $0.time.seconds > $1.time.seconds })
//        }
//        else {
//            return peekData.peekPosts.sorted(by: { $0.votes > $1.votes })
//        }
//    }
//    @GestureState private var dragOffset = CGSize.zero
//    
//    var body: some View {
//        VStack(spacing: 0){
//            
//            ZStack{
//                
//                HStack{
//                    Spacer()
//                    Button(action: {selected = 0}, label: {
//                        if selected == 0 {
//                            Text("Recent")
//                                .fontWeight(.bold)
//                                .frame(width: 100)
//                                .foregroundColor(.black)
//                                .background(
//                                    Rectangle().frame(height: 2.0).foregroundColor(.black).offset(y: 9.0))
//                            
//                        }
//                        else{Text("Recent")
//                            .frame(width: 100)
//                            .foregroundColor(.black)}
//                        
//                    })
//                    Spacer()
//                    Button(action: {selected = 1}, label: {
//                        if selected == 1 {
//                            Text("Liked")
//                                .fontWeight(.bold)
//                                .frame(width: 100)
//                                .foregroundColor(.black)
//                                .background(
//                                    Rectangle().frame(height: 2.0).foregroundColor(.black).offset(y: 9.0))
//                            
//                        }
//                        else{Text("Liked")
//                            .frame(width: 100)
//                            .foregroundColor(.black)}
//                        
//                    })
//                    Spacer()
//                }//.padding(.horizontal)
//                .background(Rectangle().foregroundColor(.customOrange))
//                // .padding(.bottom, 3)
//            }
//            
//            
//            if peekPosts.isEmpty {
//                if peekData.initialLoading == true{
//                    VStack{
//                        Spacer()
//                        ActivityIndicator(shouldAnimate: $peekData.initialLoading)
//                        Spacer()
//                    }
//                }
//                //dont need this bc it cant be empty but whatever
//                else{
//                    VStack{
//                        Spacer()
//                        Image(systemName: "tray")
//                            .font(.system(size: 60, weight: .light))
//                            .foregroundColor(.customOrange)
//                        
//                        Text("No Posts Yet").font(.body).fontWeight(.medium).padding(.top)
//                        Text("It seems no one has posted to this school's BlindTiger yet. Check back later.").multilineTextAlignment(.center
//                        ).padding(.horizontal)
//                        
//                        Spacer()
//                    }
//                    
//                }
//            }
//            else{
//                ScrollView{
//                   
//                    VStack{
////                        Button(action: {peekBlockedUsers.removeAll()
////                            UserDefaults.standard.set(peekBlockedUsers, forKey: "peekBlockedUsers")
////                        }, label: {
////                            Text("reset peek blocked users")
////                        })
//                       
//                        ForEach(peekPosts) {post in
//                            if peekBlockedUsers.contains(post.authoruid) {}
//                            else {
//                            if (peekPosts.firstIndex(where: { $0.id == post.id})!.isMultiple(of: 7) && peekPosts.firstIndex(where: { $0.id == post.id}) != 0) {
//                                VStack{
//                                    peekCardView(content: post.content , votes: post.votes, time: post.time, authoruid: post.authoruid, anonymous: post.anonymous, id: post.id, authorusername: post.authorusername, selectedSchool: selectedSchool, reports: post.reports, reported: UserDefaults.standard.bool(forKey: "\(post.id)reported"), peekBlockedUsers: $peekBlockedUsers)
//                                    
//                                    adView().frame(height: 250).padding()
//                                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white).shadow(color: Color.black.opacity(0.15), radius: 6)).padding(.horizontal).padding(.vertical, 5)
//                                }
//                            }
//                            else{
//                                peekCardView(content: post.content , votes: post.votes, time: post.time, authoruid: post.authoruid, anonymous: post.anonymous, id: post.id, authorusername: post.authorusername, selectedSchool: selectedSchool, reports: post.reports, reported: UserDefaults.standard.bool(forKey: "\(post.id)reported"), peekBlockedUsers: $peekBlockedUsers)
//                            }
//                        }
//                            
//                            
//                            
//                            
//                            
//                        }
//                        if selected == 0 {
//                            if peekData.numberOfPostsLoaded <= peekPosts.count {
//                                Button(action: {peekData.numberOfPostsLoaded += 30; peekData.fetchData(selectedSchool: selectedSchool)}, label: {
//                                    HStack{
//                                        // Image(systemName: "arrow.clockwise").padding().font(.title3).foregroundColor(.gray)
//                                        Text("More...").padding()
//                                    }
//                                    
//                                })}
//                        }
//                    }.ignoresSafeArea(.all)
//                }
//                //UNDO: gesture doesnt work for some reason
//                //            .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
//                //
//                //                if(value.translation.width < -90) {
//                //                    self.selected = 1
//                //                }
//                //                if(value.translation.width > 90) {
//                //                    self.selected = 0
//                //                }
//                //
//                //            }))
//                
//            }
//            
//            
//            // Spacer()
//        }
//        
//        
//        .background(Rectangle().foregroundColor(.customGray).ignoresSafeArea(edges: .all))
//        
//        .navigationBarTitle(Text(""), displayMode: .inline)
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading: Button(action: {
//            self.presentationMode.wrappedValue.dismiss()
//        }, label: {
//            Image(systemName: "chevron.left").padding(.vertical).padding(.trailing).foregroundColor(.black)
//        }))
//        
//        .toolbar{
//            ToolbarItem(placement: .principal) {
//                VStack(spacing: 0){
//                Image("tiger")
//                    .resizable()
//                    .frame(width: 25, height: 25)
//                    .aspectRatio(contentMode: .fill)
//                Text(selectedSchool.capitalized)
//                    .font(.callout)
//                    .foregroundColor(.black)
//                    .fontWeight(.medium)
//                }
//            }
//        }
//        .navigationBarColor(UIColor(Color.customOrange))
//        .onAppear() {peekData.fetchData(selectedSchool: selectedSchool)}
//    }
//}
//
//
//
//
//
