////
////  Home.swift
////  BlindTiger
////
////  Created by dante  delgado on 11/3/20.
////
//
//import SwiftUI
//import Firebase
//import GoogleMobileAds
//
//struct Home: View {
//    @ObservedObject var homeData = homeViewModel()
//    //liked or recent selected
//    @State var selected = 0
// //   @State var blockedUsersInit = [String]()
//    
//    @Binding var blockedUsers: [String]
//    
//    var homePosts: [post] {
//        
//        if selected == 0 {
//                        return homeData.posts.sorted(by: { $0.time.seconds > $1.time.seconds })
//        }
//        else {
//            return homeData.posts.sorted(by: { $0.votes > $1.votes })
//        }
//            
//    }
//    @GestureState private var dragOffset = CGSize.zero
//    
//    
//    
//    var body: some View {
//        
//        
//        
//        NavigationView{
//            VStack(spacing: 0) {
//                      //  liked and recent buttons
//                        HStack{
//                            Spacer()
//                            Button(action: {selected = 0}, label: {
//                                if selected == 0 {
//                                    Text("Recent")
//                                        .fontWeight(.bold)
//                                        .frame(width: 100)
//                                        .foregroundColor(.black)
//                                        .background(
//                                            Rectangle().frame(height: 2.0).foregroundColor(.black).offset(y: 10.0))
//                                    
//                                }
//                                else{Text("Recent")
//                                    .frame(width: 100)
//                                    .foregroundColor(.black)}
//                                
//                            })
//                            Spacer()
//                            Button(action: {selected = 1
//                                
//                            }, label: {
//                                if selected == 1 {
//                                    Text("Liked")
//                                        .fontWeight(.bold)
//                                        .frame(width: 100)
//                                        .foregroundColor(.black)
//                                        .background(
//                                            Rectangle().frame(height: 2.0).foregroundColor(.black).offset(y: 10.0))
//                                    
//                                }
//                                else{Text("Liked")
//                                    .frame(width: 100)
//                                    .foregroundColor(.black)}
//                                
//                            })
//                            Spacer()
//                        }.padding(.bottom, 1).background(Color(UIColor(.customOrange)))
//          
//                if homeData.initialLoading == true{
//                    VStack{
//                        Spacer()
//                        ActivityIndicator(shouldAnimate: $homeData.initialLoading)
//                        Spacer()
//                    }
//                }
//                else{
//                    if homePosts.isEmpty {
//                        
//                        VStack{
//                            Spacer()
//                            Image(systemName: "tray")
//                                .font(.system(size: 60, weight: .light))
//                                .foregroundColor(.customOrange)
//                            Text("No Posts Yet").font(.body).fontWeight(.medium).padding(.top)
//                            Text("It seems no one has posted to your school's BlindTiger yet. Be the first!").multilineTextAlignment(.center).padding(.horizontal)
//                            Spacer()}
//                    }
//                    else{
//                        RefreshableScrollView(height: 70, refreshing: self.$homeData.loading) {
//                            ScrollView{
//                                VStack{
//                                 // test for blocking
////                                    Button(action: {blockedUsers.removeAll()
////                                        UserDefaults.standard.set(blockedUsers, forKey: "blockedUsers")
////                                    }, label: {
////                                        Text("Unblock all users")
////
////                                    })
//                                    
//                                  
//                                    
//                                    ForEach(homePosts) {post in
//                                        if blockedUsers.contains(post.authoruid) {}
//                                        else{
//                                        if (homePosts.firstIndex(where: { $0.id == post.id})!.isMultiple(of: 7) && homePosts.firstIndex(where: { $0.id == post.id}) != 0) {
//                                            VStack{
//                                                cardView(content: post.content , votes: post.votes, time: post.time, authoruid: post.authoruid, anonymous: post.anonymous, id: post.id, authorusername: post.authorusername, reports: post.reports, upvote: UserDefaults.standard.bool(forKey: "\(post.id)upvoted"), downvote: UserDefaults.standard.bool(forKey: "\(post.id)downvoted"), reported: UserDefaults.standard.bool(forKey: "\(post.id)reported"), blockedUsers: $blockedUsers)
//                                                
//                                                adView().frame(height: 250).padding()
//                                                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white).shadow(color: Color.black.opacity(0.15), radius: 6)).padding(.horizontal).padding(.vertical, 5)
//                                            }
//                                        }
//                                        else{
//                                            cardView(content: post.content , votes: post.votes, time: post.time, authoruid: post.authoruid, anonymous: post.anonymous, id: post.id, authorusername: post.authorusername, reports: post.reports, upvote: UserDefaults.standard.bool(forKey: "\(post.id)upvoted"), downvote: UserDefaults.standard.bool(forKey: "\(post.id)downvoted"), reported: UserDefaults.standard.bool(forKey: "\(post.id)reported"), blockedUsers: $blockedUsers)
//                                        }
//                                        }
//                                        
//                                    }
//                                    if selected == 0 {
//                                        if homeData.numberOfPostsLoaded <= homePosts.count {
//                                            Button(action: {homeData.numberOfPostsLoaded += 30; homeData.fetchData()}, label: {
//                                                HStack{
//                                                    // Image(systemName: "arrow.clockwise").padding().font(.title3).foregroundColor(.gray)
//                                                    Text("More...").padding()
//                                                }
//                                                
//                                            })}
//                                    }
//                                }
//                            }
//                        }
//                        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
//                            
//                            if(value.translation.width < -80) {
//                                selected = 1
//                            }
//                            if(value.translation.width > 80) {
//                                selected = 0
//                            }
//                            
//                        }))
//                        
//                        
//                    }
//                }
//                
//                
//            }
//            .navigationBarTitle(Text(""), displayMode: .inline)
//            .navigationBarBackButtonHidden(true)
//        
//            .toolbar{
//                ToolbarItem(placement: .principal) {
//                    Image("tiger")
//                        .resizable()
//                        .frame(width: 45, height: 45)
//                        .aspectRatio(contentMode: .fill)
//                }
//            }.navigationBarColor(UIColor(Color.customOrange))
////            .navigationBarHidden(true)
//            .background(Color(UIColor(.customGray)).ignoresSafeArea(edges: .all))
//            .onAppear() {homeData.fetchData()
//                //initialize the userdefaults with an empty array
//              //  UserDefaults.standard.set(blockedUsersInit, forKey: "blockedUsers")
//
//            }
//            
//            NavigationLink(destination: PreLoginView(info: AppDelegate()), isActive: $homeData.goPreLogin) {EmptyView()}
//                
//        }.navigationBarHidden(true)
//        
//    }
//}
//
//
//
//struct adView : UIViewRepresentable {
//
//
//    func makeUIView(context: UIViewRepresentableContext<adView>) -> GADBannerView {
//        let banner = GADBannerView(adSize: kGADAdSizeBanner)
//
//        banner.adUnitID = "ca-app-pub-5704345460704356/2000662981"
//        // REAL ADS: ca-app-pub-5704345460704356/2000662981
//        // FAKE ADS: ca-app-pub-3940256099942544/2934735716
//        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
//        banner.load(GADRequest())
//        return banner
//    }
//    func updateUIView(_ uiView: GADBannerView, context: UIViewRepresentableContext<adView>) {
//
//    }
//}

