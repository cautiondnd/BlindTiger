//
//  BulletinView.swift
//  BlindTigerRedesign
//
//  Created by dante  delgado on 3/25/22.
//

import SwiftUI

struct BulletinView: View {
    @ObservedObject var bulletinData = BulletinModel()
    @State var showPostSheet = false
    
    var body: some View {
        
           // NavigationStack{
            VStack(spacing: 0) {
                    if bulletinData.initialLoading == true {
                        fullScreenProgessView()
                    }
                    else{
                        if bulletinData.promos.isEmpty {
                            emptyFeed(title: "No Upcoming Events", subTitle: "Not much is happening. Use this page to promote on campus events.")
                        }
                        else {
                           bulletinFeed
                        }
                    }
                }
                .onAppear() {bulletinData.fetchData()}
                .background(Color.customGray)
                .sheet(isPresented: $showPostSheet) {NewPromoView(bulletinData: bulletinData, showing: $showPostSheet).onDisappear() {bulletinData.refreshData()}}
                
                .navigationTitle(Text("Events"))
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarColor(UIColor(Color.customOrange))
                .toolbar{ToolbarItem(placement: .navigationBarTrailing) {newPostButton.padding([.leading,.vertical])}}
         //   }.accentColor(.black)
        
        
    }
    
    var bulletinFeed: some View{
        RefreshableScrollView(refreshing: $bulletinData.refreshing){
            let blockedUsers: [String] = UserDefaults.standard.stringArray(forKey: "blockedUsers") ?? [String]()
            Spacer(minLength: 5)
            
            VStack{
                ForEach( Array(bulletinData.promos.sorted {$0.startTime.seconds < $1.startTime.seconds}.enumerated()), id: \.element ) {index, promo in
                    if !blockedUsers.contains(promo.authoruid) {
                        promoCardView(promo: promo, votes: promo.votes, upvote: UserDefaults.standard.bool(forKey: "\(promo.id)upvoted"), reported: UserDefaults.standard.bool(forKey: "\(promo.id)reported"))
                    }
//                    if index.isMultiple(of: 7) && index != 0 {
//                        midPostAd()
//                    }
                }
                
            }
        }
    }
    
//    var firstOpenNavBar: some View {
//        ZStack{
//            HStack{
//                Spacer()
//                Text("Events")
//                    .font(.headline)
//                    .foregroundColor(.black)
//                    .fontWeight(.semibold)
//                Spacer()}
//        HStack{
//            Spacer()
//            newPostButton.font(.title2).padding(.horizontal)
//        }
//        }.padding(.bottom, 5).background(Color.customOrange)
//    }
//    
    var newPostButton: some View {
        Button(action:
                {showPostSheet = true},
               label:
                {Image(systemName: "plus.app").foregroundColor(.black)})

    }
}

