//
//  RatingCards.swift
//  BlindTiger
//
//  Created by dante  delgado on 7/6/22.
//

import SwiftUI
import Firebase



struct orgCard: View {
    var org: org
    @State var numberOfComments = 0
    
    var body: some View {
        
        NavigationLink(destination: {RatingCommentView(rootOrg: org)}, label: {
        
        VStack(spacing: 5){
                Text(org.title)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .allowsTightening(true)
            
            ratingStarsAndNumReviews
            HStack{
                Spacer()
                Text("Tap anywhere to rate")
                    .font(.caption2)
                    .foregroundColor(.gray)
                Spacer()
            }
               
        }
      //  .onAppear() {getNumberComments()}
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white).shadow(color: Color.black.opacity(0.15), radius: 6))
        .padding(.horizontal)
        }).buttonStyle(PlainButtonStyle())
    }
    var ratingStarsAndNumReviews: some View {
        HStack(spacing: 0){
            let rating = Double(org.totRating)/Double(org.numRatings)
            if rating > 0 {
                Text(String(format: "%.1f ", rating))
                    .font(.title3)
                    .bold()
                    .offset(y: 1)
            }
            else {
                Text("N/A ")
                    .font(.headline)
                    .offset(y: 1)
            }
            
            StarRating(rating: rating).foregroundColor(.orange)
            Text(" (\(org.numRatings))")
                .foregroundColor(.gray)
        }
    }

//    func getNumberComments() {
//        db.collection("BlindTiger").document(cleanSchool).collection("reviews").document(org.id).collection("ratings").whereField("content", isNotEqualTo: "") .getDocuments {(querySnapshot, err) in
//
//            return self.numberOfComments = querySnapshot!.count
//        }
//    }
    
}


struct orgCommentedOn: View {
    var org: org
    @State var userRating: Int
    @State var numberOfReviews = 0
    
    var body: some View {
        let rating: Double = Double(org.totRating)/Double(org.numRatings)
        VStack{
            HStack{
                VStack(){
                    StarRating(rating: rating).foregroundColor(.orange)
                    if rating > 0 {Text(String(format: "%.1f ", rating)).font(.title)}
                    else {Text("N/A").font(.title)}
                    Text("(\(org.numRatings) ratings)").font(.footnote).foregroundColor(.gray)
                }.padding(.trailing, 3)
                VStack{
                    Text(org.title).font(.title3).bold().multilineTextAlignment(.center)
                    HStack{
                        Spacer()
                        Text(org.description).font(.footnote)
                        Spacer()
                    }
                    
                }
            }.padding(.horizontal)
            Divider().padding(5)
            Text("Tap to rate:").font(.footnote).foregroundColor(.gray).padding(.bottom, 3)
            RateButton
        }
        .padding(.vertical)
        .background(Rectangle().foregroundColor(.white).shadow(color: Color.black.opacity(0.15), radius: 6))
    }
        
        var RateButton: some View {
                HStack {
                Button(
                    action: {
                        adjustRating(num: 1)
                        userRating = 1
                    },
                    label: {
                        if userRating >= 1 { Image(systemName: "star.fill") }
                        else { Image(systemName: "star") }
                    })
                
                Button(
                    action: {
                        adjustRating(num: 2)
                        userRating = 2
                    },
                    label: {
                        if userRating >= 2 { Image(systemName: "star.fill") }
                        else { Image(systemName: "star") }
                    })
                
                Button(
                    action: {
                        adjustRating(num: 3)
                        userRating = 3
                    },
                    label: {
                        if userRating >= 3 { Image(systemName: "star.fill") }
                        else { Image(systemName: "star") }
                    })
                
                Button(
                    action: {
                        userRating = 4
                        adjustRating(num: 4)
                    },
                    label: {
                        if userRating >= 4 { Image(systemName: "star.fill") }
                        else { Image(systemName: "star") }
                    })
                
                Button(
                    action: {
                        userRating = 5
                        adjustRating(num: 5)
                    },
                    label: {
                        if userRating == 5 { Image(systemName: "star.fill") }
                        else { Image(systemName: "star") }
                    })
                
            }
        }
        func adjustRating(num: Int) {
            let userRating = UserDefaults.standard.integer(forKey: "\(org.id)rating")
            let postRef = db.collection("BlindTiger").document(cleanSchool).collection("reviews").document(org.id)
            
            if userRating < 1 {
                postRef.updateData(["numRatings" : FieldValue.increment(Int64(3))])
            }
            postRef.updateData(["totRating" : FieldValue.increment(Int64(-userRating*3))])
            UserDefaults.standard.set(num, forKey: "\(org.id)rating")
            postRef.updateData(["totRating" : FieldValue.increment(Int64(num*3))])
            
            UserDefaults.standard.set(num, forKey: "\(org.id)rating")
        }
    }


struct StarRating: View {
    var rating: Double
    var body: some View {
        HStack(spacing: 0){
             if rating >= 4.75 {
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
            }
            else if rating >= 4.25 {
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star.leadinghalf.fill")
            }
            else if rating >= 3.75 {
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star")
            }
            else if rating >= 3.25 {
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star.leadinghalf.fill")
                Image(systemName: "star")
            }
            else if rating >= 2.75 {
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star")
                Image(systemName: "star")
            }
            else if rating >= 2.25 {
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star.leadinghalf.fill")
                Image(systemName: "star")
                Image(systemName: "star")
            }
            else if rating >= 1.75 {
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star")
                Image(systemName: "star")
                Image(systemName: "star")
            }
            else if rating >= 1.25 {
                Image(systemName: "star.fill")
                Image(systemName: "star.leadinghalf.fill")
                Image(systemName: "star")
                Image(systemName: "star")
                Image(systemName: "star")
            }
            else if rating >= 0.75 {
                Image(systemName: "star.fill")
                Image(systemName: "star")
                Image(systemName: "star")
                Image(systemName: "star")
                Image(systemName: "star")
            }
            else if rating >= 0.25 {
                Image(systemName: "star.leadinghalf.fill")
                Image(systemName: "star")
                Image(systemName: "star")
                Image(systemName: "star")
                Image(systemName: "star")
            }
            else {
                Image(systemName: "star")
                Image(systemName: "star")
                Image(systemName: "star")
                Image(systemName: "star")
                Image(systemName: "star")
            }
        }
    }
}
    
    
    





struct reviewCommentCard: View {
    var reviewData: review
    @State var votes: Int
    @State var upvote: Bool
    @State var downvote: Bool
    @State var reported: Bool
    var canVote = true
    
    // @Binding var blockedUsers: [String]
    
    
    var body: some View {
        
        VStack(alignment: HorizontalAlignment.leading){
            ratingTimeAndSettings
            HStack{
                Text(reviewData.content)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                votingButton
            }.padding(.horizontal)
        }
        .padding(.vertical)
        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white).shadow(color: Color.black.opacity(0.15), radius: 6))
        .padding(.horizontal)
        
    }

    var ratingTimeAndSettings: some View {
        HStack(spacing: 0) {
            StarRating(rating: Double(reviewData.rating))
            Text(" ◦ \(reviewData.time.dateValue().timeAgoDisplay())")
                .foregroundColor(.gray)
                .font(.callout)
            Spacer()
            ReviewSettings(review: reviewData, reported: reported)
                .offset(y: -10)
        }.padding(.leading)
    }
    
    var votingButton: some View {
        VStack{
            if canVote{
                Button(
                    action: {upvotePost()},
                    label: {Image(systemName: "chevron.up")
                            .foregroundColor(upvote == true ? .orange : .gray)
                        .font(.title)})}
            Text("\(votes)")
                .font(.title)
                .lineLimit(1)
                .allowsTightening(true)
                .padding(.vertical, 10)
            if canVote{
                Button(
                    action: {downvotePost()},
                    label: {Image(systemName: "chevron.down")
                            .foregroundColor(downvote == true ? .orange : .gray)
                        .font(.title)})}
            
            
        }
    }
    
    
    func downvotePost() {
        let postRef = db.collection("BlindTiger").document(cleanSchool).collection("reviews").document(reviewData.rootPostID).collection("ratings").document(reviewData.id)
            downvote.toggle();
        UserDefaults.standard.set(self.downvote, forKey: "\(reviewData.rootPostID)downvoted");
        UserDefaults.standard.set(false, forKey: "\(reviewData.rootPostID)upvoted");
            if downvote == true {
                if upvote == true {
                    upvote = false
                    postRef.updateData(["votes" : FieldValue.increment(Int64(-6))])
                    votes -= 2
                }
                else {
                    postRef.updateData(["votes" : FieldValue.increment(Int64(-3))])
                    votes -= 1
                }
            }
            else {
                //GODMODE uncomment
                postRef.updateData(["votes" : FieldValue.increment(Int64(3))])
                votes += 1
            }
    }
    
    func upvotePost() {
        let postRef = db.collection("BlindTiger").document(cleanSchool).collection("reviews").document(reviewData.rootPostID).collection("ratings").document(reviewData.id)
        upvote.toggle();
        UserDefaults.standard.set(self.upvote, forKey: "\(reviewData.rootPostID)upvoted");
        UserDefaults.standard.set(false, forKey: "\(reviewData.rootPostID)downvoted")
        if upvote == true {
            if downvote == true {
                downvote = false
                postRef.updateData(["votes" : FieldValue.increment(Int64(6))])
                votes += 2

            }
            else {
                // TEST change for how much one upvote upvotes
                postRef.updateData(["votes" : FieldValue.increment(Int64(3))])
                votes += 1
            }
        }
        else {
            //GODMODE uncomment
            postRef.updateData(["votes" : FieldValue.increment(Int64(-3))])
            votes -= 1
        }
    
    }

}

struct ReviewSettings: View {
    let review: review
    @State var reported: Bool
    @State var showAlert = false
    
    var body: some View {
        
        Menu {
            if Auth.auth().currentUser?.uid == review.authoruid {
                Button(action: {showAlert = true}, label: {Label("Delete", systemImage: "trash")})
            
            }
            else {
                
                Button(action: {reportPost(postID: review.id, rootPostID: review.rootPostID)}, label: {
                    reported ?
                    Label("Reported", systemImage: "flag.fill") : Label("Report", systemImage: "flag")})
                
                Button(action: {showAlert = true}, label: {Label("Block", systemImage: "hand.raised")})
                    
            }
            
        } label: {
            Image(systemName: "ellipsis")
                .padding(.horizontal)
                .foregroundColor(.gray)
        }
        .alert(isPresented: $showAlert, content: {
            //GODMODE make ==
            Auth.auth().currentUser?.uid == review.authoruid ?
                Alert(
                    title: Text("Delete Post?"),
                    message: Text("There is no way to recover a post once deleted."),
                    primaryButton: .default(Text("Cancel")) {},
                    secondaryButton: .destructive(Text("Delete")) {
                        deletePost(postID: review.id, rootPostID: review.rootPostID);
                        UserDefaults.standard.set(false, forKey: "\(review.rootPostID)upvoted");
                        UserDefaults.standard.set(false, forKey: "\(review.rootPostID)downvoted")}):
                Alert(
                    title: Text("Block User?"),
                    message: Text("Are you sure you want to block this user?"),
                    primaryButton: .default(Text("Cancel")) {},
                    secondaryButton: .destructive(Text("Block")) {
                        var blockedUsers: [String] = UserDefaults.standard.stringArray(forKey: "blockedUsers") ?? []
                        blockedUsers.append(review.authoruid)
                        UserDefaults.standard.set(blockedUsers, forKey: "blockedUsers")
                    })
        })

    }
    
    func deletePost(postID: String, rootPostID: String) {
       db.collection("BlindTiger").document(cleanSchool).collection("reviews").document(rootPostID).collection("ratings").document(postID).delete()
    }
    
    func reportPost(postID: String, rootPostID: String) {
        let postRef = db.collection("BlindTiger").document(cleanSchool).collection("reviews").document(rootPostID).collection("ratings").document(postID)
        
        reported.toggle()
        if reported == true {
            postRef.updateData(["reports" : FieldValue.increment(Int64(1))])}
        else{
            postRef.updateData(["reports" : FieldValue.increment(Int64(-1))])}
        UserDefaults.standard.set(self.reported, forKey: "\(review.rootPostID)reported")
        
    }
}

struct review: Identifiable, Hashable {
    var id: String
    var rootPostID: String
    var content: String
    var votes: Int
    var time: Timestamp
    var authoruid: String
    var reports : Int
    var rating: Int
}

struct org: Identifiable, Hashable {
    var title: String
    var description: String
    var id: String
    var totRating: Int
    var numRatings: Int
    var category: String
}
