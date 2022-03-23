//
//  Welcome.swift
//  BlindTiger
//
//  Created by dante  delgado on 11/9/20.
//

import SwiftUI
import Firebase



struct Welcome: View {
    
    @ObservedObject var welcomeData = WelcomeViewModel()
    
    @State var showTerms = true
    
    var body: some View {
        
        VStack{
            
            Image("tiger")
                .resizable()
                .frame(width: 100, height: 100)
                .aspectRatio(contentMode: .fill)
            
            
            VStack(spacing: 0){
                Text("Welcome to \(cleanSchool.capitalized)'s")
                    .font(.title3)
                    .fontWeight(.medium)
                
                
                
                Image("logoscript")
                    .resizable()
                    .frame(width: 200, height: 50)
            }
            
            VStack{
                ZStack{
                    if welcomeData.imageData.count == 0{
                        ZStack{
                            Image(systemName: "plus").foregroundColor(.black) .font(.system(size: 45, weight: .light))
                            Circle().stroke(lineWidth: 1).frame(width: 115, height: 115)
                        }
                    }
                    else{
                        Image(uiImage: UIImage(data: welcomeData.imageData)!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 115, height: 115)
                            .clipShape(Circle())
                    }
                    
                }
                .padding(.top)
                .onTapGesture(perform: {
                    welcomeData.showImagePicker.toggle()
                })
                Text("Profile Picture").padding(.bottom)
            }
            
            VStack(spacing: 0){
                HStack{
                    Text("Full Name:").foregroundColor(.gray).font(.caption)
                    Spacer()
                }.padding(.leading, 30)
                TextField("Full Name", text: $welcomeData.fullName)
                    .disableAutocorrection(true)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.gray).opacity(0.6) )
                    .padding(.vertical, 2)
                    .padding(.horizontal, 30.0)
                HStack{
                    Text("Field must be filled out")
                        .font(.caption)
                        .foregroundColor(welcomeData.fullNameAlert && welcomeData.validateErrorShowing ? .red : .clear)
                    Spacer()
                }.padding(.horizontal, 30.0)
                
                HStack{
                    Text("Username:").foregroundColor(.gray).font(.caption)
                    Spacer()
                }.padding(.leading, 30)
                TextField("Username (6-20 characters)", text: $welcomeData.userName)
                    .disableAutocorrection(true)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.gray).opacity(0.6))
                    .padding(.vertical, 2)
                    .padding(.horizontal, 30.0)
                
                HStack{
                    
                    Text("Username must be between 6-20 characters")
                        .font(.caption)
                        .foregroundColor(welcomeData.userNameAlert && welcomeData.validateErrorShowing ? .red : .clear)
                    
                    Spacer()
                    
                }.padding(.horizontal, 30.0)
                
                
            }
            
            
            
            
            
            Spacer()
            
            Spacer()
            
            Button(action: {welcomeData.getStarted()}, label: {
                HStack{
                    Spacer()
                    
                    Text("Sign Up")
                        .foregroundColor(.white)
                    Spacer()
                }.padding(.vertical)
                .background(Capsule().foregroundColor(.darkModeforeground))
            }).padding(.horizontal)
            Text("Your account will only be avalable if you choose to post publicly")
                .font(.caption)
                .foregroundColor(.black)
                .opacity(0.8)
                .multilineTextAlignment(.center)
            
            
            
            
        }
        .onTapGesture {UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)}
        
        .sheet(isPresented: $welcomeData.showImagePicker, content: {
            ImagePicker(picker: $welcomeData.showImagePicker, img_Data: $welcomeData.imageData).accentColor(.orange)
        })
        .alert(isPresented: $showTerms) {
            Alert(title: Text("Don't Be a Jerk"), message: Text("There is no tolerance for objectionable content on BlindTiger. By clicking Accept you agree not to post defamatory, discriminatory, or mean-spirited content, including references or commentary about religion, race, sexual orientation, gender, national/ethnic origin, or other targeted groups. You agree not to discuss or incite illegal activity. And not to post overtly sexual or pornographic material. To read full Terms Of Service and Privacy Policy visit https://www.facebook.com/BlindTiger-104201294967669."), dismissButton: .default(Text("Accept")))}
        .background(Image("welcome").resizable().ignoresSafeArea(.all))
        .navigationBarHidden(true)
        
        NavigationLink(destination: PreLoginView(info: AppDelegate()), isActive: $welcomeData.goPreLogin) {
            EmptyView()}
        NavigationLink(destination: TabBar(selectedTab: 0), isActive: $welcomeData.goHome) {
            EmptyView()}
        
        
        
    }
}




