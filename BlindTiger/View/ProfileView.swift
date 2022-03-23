//
//  profileView.swift
//  Slots Demo
//
//  Created by dante  delgado on 11/23/20.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct ProfileView: View {
    var userID: String
    @ObservedObject var profileData = ProfileViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var editProfile = false
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
                if editProfile == false {
                    WebImage(url: URL(string: profileData.profinfo.imageurl)).resizable().placeholder {
                        ZStack{
                            //circle same color as background so it doesnt do anything
                            Circle().frame(width: 100, height: 100).foregroundColor(.customOrange)
                            Image("tiger").resizable().frame(width: 75, height: 75).opacity(1).offset(y: 3)
                        }

                    } .aspectRatio(contentMode: .fill) .frame(width: 100, height: 100).clipShape(Circle()) }
                else{
                    WebImage(url: URL(string: profileData.profinfo.imageurl)).resizable().placeholder {
                        ZStack{
                            //circle same color as background so it doesnt do anything
                            Circle().frame(width: 100, height: 100).foregroundColor(.customGray).opacity(0.2)
                            Image("tiger").resizable().frame(width: 75, height: 75).opacity(1).offset(y: 3)
                        }

                    } .opacity(0.6).aspectRatio(contentMode: .fill) .frame(width: 100, height: 100).clipShape(Circle()).onTapGesture {
                         profileData.showImagePicker.toggle()}
                    
                }
            //    }
                
                VStack(alignment: HorizontalAlignment.leading){
                    
                    if editProfile == false {
                    Text(profileData.profinfo.username)
                .font(.largeTitle)
                .fontWeight(.medium)
                .lineLimit(1)
                .allowsTightening(true)
                    }
                    else{
                        TextField("\(profileData.profinfo.username)", text: $profileData.usernameEdit)
                            .disableAutocorrection(true)
                            .font(.largeTitle)
                            .accentColor(.blue)
                    }
                
                
                
                    
                
                    if editProfile == false {
                Text(profileData.profinfo.fullname)
                .font(.subheadline)
                .lineLimit(1)
                .allowsTightening(true)
                    }
                    else{
                        TextField("\(profileData.profinfo.fullname)", text: $profileData.fullNameEdit)
                            .font(.subheadline)
                            .accentColor(.blue)
                    }
                    
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
                if profileData.userPosts.isEmpty {
                    VStack{
                        Spacer()
                        Image(systemName: "tray")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(.customOrange)
                        Text("No Posts Found").font(.body).fontWeight(.medium).padding(.top).padding(.bottom, 1)
                        Text("Make a post to get started.").multilineTextAlignment(.center).padding(.horizontal)
                        Spacer()}
                }
                else{
                ScrollView{
                    VStack{
                        
                    ForEach(profileData.userPosts.sorted(by: { $0.time.seconds > $1.time.seconds })) {post in
                       
                     
                        profileCardView(content: post.content , votes: post.votes, time: post.time, authoruid: post.authoruid, anonymous: post.anonymous, id: post.id, authorusername: post.authorusername, reports: post.reports, reported: UserDefaults.standard.bool(forKey: "\(post.id)reported"), cameFromSecondaryView: false, blockedUsers: $blockedUsers)
                        
                    }.padding(.top, 1)
                        //adding an unblock button to profile but it causes some bugs
                        if !blockedUsers.isEmpty{
                        Button(action: {blockedUsers.removeAll()
                            UserDefaults.standard.set(blockedUsers, forKey: "blockedUsers")
                        }, label: {
                            Text("Unblock all users")

                        })
                    }
                    }
                }
            
            }
            }
                
            
            
        }
        }
        .sheet(isPresented: $profileData.showImagePicker, content: {
            ImagePicker(picker: $profileData.showImagePicker, img_Data: $profileData.imgData).accentColor(.orange)
        })
       
        .onChange(of: profileData.imgData) { (newData) in
                    // whenever image is selected update image in Firebase...
                    profileData.updateImage()
                }
        .background(Rectangle().foregroundColor(.customGray).ignoresSafeArea(edges: .all))
        .navigationBarTitle(Text(""), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        
        .navigationBarItems(trailing: editProfile == false ? AnyView( Button(action: {editProfile = true}, label: {Image(systemName: "square.and.pencil").foregroundColor(.black).padding([.vertical, .leading])})) : AnyView(Button(action: {profileData.updateInfo(); editProfile = false}, label: {Text("Save").padding([.vertical, .leading])})) )

//        .navigationBarItems(leading: editProfile == true ? AnyView(Button(action: {editProfile = false}, label: {Text("Cancel")})) : AnyView(EmptyView()) )
        .toolbar{
            ToolbarItem(placement: .principal) {
                Text("Profile")
                    .font(.headline)
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
            }
        }
        .navigationBarColor(UIColor(Color.customOrange))

        }
        .navigationBarHidden(true)

        
        .onAppear(){profileData.fetchData(userID: userID); profileData.fetchProfileData(userID: userID); editProfile = false}
        .alert(isPresented: $profileData.showValidationAlert, content: {
            Alert(title: Text("Invalid Username"), message: Text("Username must be between 6-20 characters"), dismissButton: .default(Text("OK")))
        })
        
    }
}




