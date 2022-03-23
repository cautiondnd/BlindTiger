//
//  NotSelfProfileView.swift
//  BlindTiger
//
//  Created by dante  delgado on 11/30/20.
//
//
//  profileView.swift
//  Slots Demo
//
//  Created by dante  delgado on 11/23/20.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct NotSelfProfileView: View {
    var userID: String
    @ObservedObject var profileData = ProfileViewModel()
    @State var cameFromSecondaryView = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var blockedUsers: [String]
    
    
    var body: some View {
        NavigationView{
        ZStack{
            let userTotalVotes = profileData.userPosts.map(\.votes).reduce(0, +)
            VStack{
            RoundedRectangle(cornerRadius: 10).foregroundColor(.customOrange).ignoresSafeArea( edges: .all).frame(maxWidth: .infinity, maxHeight: 250, alignment: .center)
                Spacer()
            }
        VStack{
            

            
            HStack{
                if profileData.profinfo.imageurl == "" {
                ZStack{
                    Circle().frame(width: 100, height: 100).foregroundColor(.customOrange)
                    Image("tiger").resizable().frame(width: 75, height: 75).opacity(1).offset(y: 3)
                }
                }
                else{
                    WebImage(url: URL(string: profileData.profinfo.imageurl)).resizable().placeholder {
                        ZStack{
                            Circle().frame(width: 100, height: 100).foregroundColor(.white)
                            Image("tiger").resizable().frame(width: 75, height: 75).opacity(1).offset(y: 3)
                        }

                    } .aspectRatio(contentMode: .fill) .frame(width: 100, height: 100).clipShape(Circle())
                }
                
                VStack(alignment: HorizontalAlignment.leading){
                Text(profileData.profinfo.username)
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .allowsTightening(true)
                
                    
                
           
                Text(profileData.profinfo.fullname)
                    .font(.subheadline)
                    .lineLimit(1)
                    .allowsTightening(true)
                    
                }
            
                Spacer()
            
            
            
            }.padding(.horizontal)
            
            HStack{
                Spacer()
                VStack{
                    Text("\(profileData.userPosts.count)")
                        .fontWeight(.medium)
                    Text("Posts")
                        .font(.caption)
                        .fontWeight(.light)
                }.padding().padding(.horizontal).background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white).shadow(radius: 5))
                
                Spacer()
                
                VStack{
                    Text("\(userTotalVotes)")
                        .fontWeight(.medium)
                    Text("Score")
                        .font(.caption)
                        .fontWeight(.light)
                }.padding().padding(.horizontal).background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white).shadow(radius: 5))
                
                Spacer()
            }
            
            if profileData.initialLoading == true{
                VStack{
                    Spacer()
                    ActivityIndicator(shouldAnimate: $profileData.initialLoading)
                    Spacer()
                }
            }
            else{
                if profileData.userPosts.allSatisfy { $0.anonymous == true } {
                    VStack{
                        Spacer()
                        Image(systemName: "tray")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(.customOrange)
                        Text("No Public Posts").font(.body).fontWeight(.medium).padding(.top).padding(.bottom, 1)
                        Text("It looks like this user has not yet posted publicly.").multilineTextAlignment(.center).padding(.horizontal)
                        Spacer()}
                }
                else{
                ScrollView{
                    VStack{
                    ForEach(profileData.userPosts.sorted(by: { $0.time.seconds > $1.time.seconds })) {post in
                       
                        if post.anonymous == false {
                            profileCardView(content: post.content , votes: post.votes, time: post.time, authoruid: post.authoruid, anonymous: post.anonymous, id: post.id, authorusername: post.authorusername, reports: post.reports, reported: UserDefaults.standard.bool(forKey: "\(post.id)reported"), cameFromSecondaryView: true, blockedUsers: $blockedUsers)
                        }
                    }.padding(.top, 1)
                       
                }
            
                
                }
                }
            }
            
        }
        }

        .background(Rectangle().foregroundColor(.customGray).ignoresSafeArea(edges: .all))
        //presmode dismiss makes the nav stack reset on tab changes
        .onAppear(){profileData.fetchData(userID: userID); profileData.fetchProfileData(userID: userID); self.presentationMode.wrappedValue.dismiss()}

        .navigationBarHidden(true)

            
    }
        .navigationBarHidden(cameFromSecondaryView)
        
        .navigationBarTitle(Text(""), displayMode: .inline)
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading: Button(action: {
//                self.presentationMode.wrappedValue.dismiss()
//                }, label: {
//                Image(systemName: "chevron.left").foregroundColor(.black)
//                }))
        .toolbar{
            ToolbarItem(placement: .principal) {
                Image("tiger")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .aspectRatio(contentMode: .fill)
            }
        }
        .navigationBarColor(UIColor(Color.customOrange))


    }
}

