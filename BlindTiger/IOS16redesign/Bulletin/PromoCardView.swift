//
//  PromoCardView.swift
//  BlindTiger
//
//  Created by dante  delgado on 6/24/22.
//

import SwiftUI
import Firebase

struct promoCardView: View {
    var promo: promo
    @State var votes: Int
    @State var upvote: Bool
    @State var reported: Bool
    var canVote = true
    
    var body: some View {
            VStack {
                    HStack(alignment: VerticalAlignment.top){
                        Spacer()
                        promoSettings(promo: promo, reported: UserDefaults.standard.bool(forKey: "\(promo.id)reported")) .offset(y:-4)
                    }
                    titleAndDescription
                    HStack{
                        eventInfo
                        Spacer()
                        votingButton
                    }
                    commentButton
                }.padding(.leading, 1)
        .padding()
            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white).shadow(color: Color.black.opacity(0.15), radius: 6))
            .padding(.horizontal)
       
     
    }
    
    var titleAndDescription: some View {
        VStack(spacing: 0){
            Text(promo.title)
                .font(.headline)
                .lineLimit(1)
                .allowsTightening(true)
            if promo.description != "" {
                Text("\(promo.description.components(separatedBy: .newlines).joined(separator: "/"))")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                .allowsTightening(true)}
          
        }.padding(.bottom, 1)
    }
    
    var eventInfo: some View {
        VStack(alignment: HorizontalAlignment.leading){
            
            if #available(iOS 15.0, *) {
                Text("\(promo.startTime.dateValue().formatted(.dateTime.weekday(.wide).month().day()))")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .allowsTightening(true)
            } else {
                // Fallback on earlier versions
                Text("\(promo.startTime.dateValue(), style: .date)")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .allowsTightening(true)
            }

            if #available(iOS 15.0, *) {
                Text("from \(promo.startTime.dateValue().formatted(date: .omitted ,time: .shortened)) - \(promo.endTime.dateValue().formatted(date: .omitted ,time: .shortened)) ")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .allowsTightening(true)
            } else {
                // Fallback on earlier versions
                Text("from \(promo.startTime.dateValue(), style: .time) - \(promo.endTime.dateValue(), style: .time)")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .allowsTightening(true)
            }
            Text("at \(promo.location)")
                .font(.callout)
                .foregroundColor(.gray)
                .lineLimit(1)
                .allowsTightening(true)
        }
    }
    
    var votingButton: some View {
        VStack{
            if canVote {
                Button(
                    action: {upvotePost()},
                    label: {Image(systemName: "chevron.up")
                            .foregroundColor(upvote == true ? .orange : .gray)
                        .font(.title)})
            }
            Text("\(votes)")
                .font(.title)
                .lineLimit(1)
                .allowsTightening(true)
                .padding(.top, 10)
            

        }
    }
    
    var commentButton: some View {
        HStack{
            NavigationLink(
                destination:
                    BulletinCommentView(promoCommentedOn: promo) ) {
                HStack(spacing: 0){
                    Text("\(promo.numComments)")
                        .foregroundColor(.black)
                    Image(systemName: "bubble.right")
                        .foregroundColor(.gray)
                }.padding(.trailing)
            }
            Spacer()
            
        }.padding(.top, 5)
    }


    
    func upvotePost() {
        upvote.toggle();
        UserDefaults.standard.set(self.upvote, forKey: "\(promo.id)upvoted");
        if upvote == true {
            // TEST change for how much one upvote upvotes
            db.collection("BlindTiger").document("\(cleanSchool)").collection("promotions").document("\(promo.id)") .updateData(["votes" : FieldValue.increment(Int64(3))])
                votes += 1
        }
        else {
            //GODMODE uncomment
            db.collection("BlindTiger").document("\(cleanSchool)").collection("promotions").document("\(promo.id)") .updateData(["votes" : FieldValue.increment(Int64(-3))])
            votes -= 1
        }
    
    }
    
}

struct promoSettings: View {
    let promo: promo
    @State var reported: Bool
    @State var showAlert = false
    var body: some View {
        
        Menu {
            if Auth.auth().currentUser?.uid == promo.authoruid {
                Button(action: {showAlert = true}, label: {Label("Delete", systemImage: "trash")})
            
            }
            else {
                
                Button(action: {reportPromo()}, label: {
                    reported ?
                    Label("Reported", systemImage: "flag.fill") : Label("Report", systemImage: "flag")})
                
                Button(action: {showAlert = true}, label: {Label("Block", systemImage: "hand.raised")})
                    
            }
            
        } label: {
            Image(systemName: "ellipsis")
                .foregroundColor(.gray)
                .padding(.leading)
        }
        .alert(isPresented: $showAlert, content: {
            //GODMODE make ==
            Auth.auth().currentUser?.uid == promo.authoruid ?
                Alert(
                    title: Text("Delete Post?"),
                    message: Text("There is no way to recover a post once deleted."),
                    primaryButton: .default(Text("Cancel")) {},
                    secondaryButton: .destructive(Text("Delete")) {deletePromo()}):
                Alert(
                    title: Text("Block User?"),
                    message: Text("Are you sure you want to block this user?"),
                    primaryButton: .default(Text("Cancel")) {},
                    secondaryButton: .destructive(Text("Block")) {
                        var blockedUsers: [String] = UserDefaults.standard.stringArray(forKey: "blockedUsers") ?? []
                        blockedUsers.append(promo.authoruid)
                        UserDefaults.standard.set(blockedUsers, forKey: "blockedUsers")
                    })
        })

    }
    
    func deletePromo() {
        db.collection("BlindTiger").document(cleanSchool).collection("promotions").document(promo.id).delete()
    }
    
    func reportPromo() {
        reported.toggle();
        if reported == true {
            db.collection("BlindTiger").document(cleanSchool).collection("promotions").document(promo.id).updateData(["reports" : FieldValue.increment(Int64(1))])}
        else{
            db.collection("BlindTiger").document(cleanSchool).collection("promotions").document(promo.id).updateData(["reports" : FieldValue.increment(Int64(-1))])}
        UserDefaults.standard.set(self.reported, forKey: "\(promo.id)reported")
    }
    
}

struct promo: Identifiable, Hashable {
    var title: String
    var startTime: Timestamp
    var endTime: Timestamp
    var votes: Int
    var id: String
    var authoruid: String
    var reports: Int
    var description: String
    var organizer: String
    var location: String
    var theme: String
    var numComments = 0
}
