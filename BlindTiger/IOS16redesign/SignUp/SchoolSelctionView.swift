//
//  SchoolSelctionView.swift
//  BlindTiger
//
//  Created by dante  delgado on 7/29/22.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct SchoolSelection: View {
    @ObservedObject var info : AppDelegate
    @State var goHome = false
    @State var showTerms = false
    var body: some View {
        
        VStack(spacing: 0){
            
                Text("Welcome to")
                    .italic()
                Image("logoscript")
                    .resizable()
                    .frame(width: 200, height: 50)

            ScrollView{
            Text("SELECT YOUR SCHOOL:")
                .font(.headline)
                .padding(.top, 10)
                if info.initialLoading {
                    fullScreenProgessView()
                }
                else {
                    featuredSchools
                    allSchools
                    
                    
                    Text("Don't see your school?\nSign in with your school email to start a new feed:")
                        .multilineTextAlignment(.center)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Button(action: {googleSignin()}, label: {
                        HStack{
                            Spacer()
                            Image("google-icon").resizable().frame(width: 15, height: 15)
                            Text("Continue With Google")
                                .foregroundColor(.white)
                            Spacer()}
                    }).padding(.vertical)
                        .background(Capsule().foregroundColor(.darkModeforeground))
                        .padding(.horizontal)
                    
                }
              
            }
            NavigationLink(destination: TabBarView().navigationBarBackButtonHidden(true).navigationTitle("").navigationBarHidden(true), isActive: $info.goHome) {EmptyView()}
        }
        .onAppear() {showTerms = true;info.fetchSchools()}
        .background(Image("welcome").resizable().ignoresSafeArea(.all))
        .alert(isPresented: $showTerms) {
            Alert(title: Text("Don't Be a Jerk"), message: Text("There is no tolerance for objectionable content on BlindTiger. By clicking Accept you agree not to post defamatory, discriminatory, or mean-spirited content, including references or commentary about religion, race, sexual orientation, gender, national/ethnic origin, or other targeted groups. You agree not to discuss or incite illegal activity and not to post overtly sexual material. To read full Terms Of Service and Privacy Policy visit https://www.facebook.com/BlindTiger-104201294967669."), dismissButton: .default(Text("Accept")))}
        
    }
    
    var featuredSchools: some View {
        VStack(spacing: 0) {
            HStack{
                Text("Featured")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.leading)
                    .padding(.bottom, 2)
                Spacer()
            }
            VStack(alignment: HorizontalAlignment.leading, spacing: 0){
                ForEach(info.featuredSchools) {school in
                    Button(
                        action: {
                            info.createUserSchoolSelect(selectedSchool: school.id)
                        }, label: {
                            VStack(alignment: HorizontalAlignment.leading, spacing: 0){
                                    Text(school.name)
                                    .foregroundColor(.black)
                                        .padding(.horizontal)
                                        .padding(.vertical, 12)
                                if info.featuredSchools.last != school {Divider()}
                            }
                            
                            })}}
            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white))
            .padding(.horizontal)
        }
    }
    var allSchools: some View {
        VStack(alignment: HorizontalAlignment.leading, spacing: 0) {
            HStack{
                Text("All")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.leading)
                    .padding(.bottom, 2)
                Spacer()
            }
            VStack(alignment: HorizontalAlignment.leading, spacing: 0){
                ForEach(info.allSchools) {school in
                    Button(
                        action: {
                            info.createUserSchoolSelect(selectedSchool: school.id)
                        }, label: {
                            VStack(alignment: HorizontalAlignment.leading, spacing: 0){
                                    Text(school.name)
                                    .foregroundColor(.black)
                                        .padding(.horizontal)
                                        .padding(.vertical, 12)
                                if info.allSchools.last != school {Divider()}
                            }
                            
                        })}}
            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white))
            .padding(.horizontal)
        }
    }
    
  
    
    func googleSignin() {
        
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
        
        GIDSignIn.sharedInstance()?.signIn()
                              
    }
}
