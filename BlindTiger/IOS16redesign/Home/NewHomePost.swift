//
//  NewHomePost.swift
//  BlindTigerRedesign
//
//  Created by dante  delgado on 6/11/22.
//

import SwiftUI

struct NewHomePost: View {
    @ObservedObject var homeData: HomeModel
    @Binding var showing: Bool
    @State var showErrors = false
    var body: some View {

        GeometryReader { geometry in
            VStack(){
                postButton
                newPostField
                //fetchOldPostsButton (TESTING ONLY)
                Spacer()
                Text("Contact Us: BlindTigerApp@gmail.com")
                    .foregroundColor(.gray)
                    .font(.caption)
                    .padding()
                    
            }.background(Color.customGray).ignoresSafeArea()
        }.ignoresSafeArea(.keyboard, edges: .bottom)
                
    }
    
    var newPostField: some View {
        VStack(alignment: HorizontalAlignment.leading){
                // Fallback on earlier versions
            ZStack(alignment: Alignment.topLeading){
                TextEditor(text: $homeData.newPostContent)
                    .frame(height: 250)
                    
                if homeData.newPostContent.isEmpty {
                    Text("What's on your mind")
                    .foregroundColor(Color(UIColor.placeholderText))
                    .padding(.leading, 7)
                    .padding(.top, 9)
                    .allowsHitTesting(false)
                }
            }.padding(.leading, 5)
                .padding(.vertical, 5)
            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white)).padding([.leading, .trailing])
            if showErrors && homeData.newPostContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text("Field must be filled out")
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.leading)
            }
            
            HStack {
                Text("\(homeData.newPostContent.components(separatedBy: "\n").count)/10")
                    .padding(.leading)
                    .foregroundColor(homeData.newPostContent.components(separatedBy: "\n").count > 10 ? .red : .gray)
                Spacer()
                Text("\(homeData.newPostContent.count)/280")
                    .padding(.trailing)
                    .foregroundColor(homeData.newPostContent.count > 280 ? .red : .gray)
                
            }
            
        }
    }
    
    var postButton: some View {
        HStack{
            Spacer()
            Button(action:
                    {homeData.validateFields();
                if homeData.isValid {
                    homeData.uploadPost();
                    showing = false                    
                }
                else {
                    showErrors = true
                }
            },
                   label:
                    {
                Text("Post")
                .capsuleButtonStyle()
                .padding()
            })
                    
        }
    }
    
//    var fetchOldPostsButton: some View {
//        HStack{
//            Button(action: {
//                let randNum = Int.random(in: 1630510235...1663602212)
//                let randDate = Date(timeIntervalSince1970: TimeInterval(randNum))
//                db.collection("BlindTiger").document("bates").collection("posts").order(by: "time").start(after: [randDate]).limit(to: 1).getDocuments { snap, err in
//                    homeData.newPostContent = snap?.documents.first?.data()["content"] as? String ?? ""
//                    print(snap?.documents.first?.data()["id"] as! String)
//                    print("going")
//                }
//
//            }, label: {Text("New Bates Post").font(.headline)})
//            Spacer()
//            Button(action: {
//                let randNum = Int.random(in: 1643691635...1663602212)
//                let randDate = Date(timeIntervalSince1970: TimeInterval(randNum))
//                db.collection("BlindTiger").document("belmont").collection("posts").order(by: "time").start(after: [randDate]).limit(to: 1).getDocuments { snap, err in
//                    homeData.newPostContent = snap?.documents.first?.data()["content"] as? String ?? ""
//                    print(snap?.documents.first?.data()["id"] as! String)
//                }
//
//            }, label: {Text("New Belmont Post").font(.headline)})
//        }
//    }
}

extension Text {
    func capsuleButtonStyle() -> some View {
        self
            .padding(.vertical, 4)
            .padding(.horizontal)
            .background(Color.orange)
            .foregroundColor(.white)
            .font(Font.body.bold())
            .clipShape(Capsule())
        
    }
}
