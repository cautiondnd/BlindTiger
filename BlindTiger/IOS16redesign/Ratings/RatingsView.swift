//
//  RatingsView.swift
//  BlindTigerRedesign
//
//  Created by dante  delgado on 3/25/22.
//

import SwiftUI
import Firebase

struct RatingsView: View {
    @ObservedObject var ratingData = RatingModel()

    @State var showPostSheet = false
    @State var showSearchBar = false

    var body: some View {
        //Ratings page could def function better. Maybe optimize it later down the line. reviewID's being authoruid may cause problems.
        
           // NavigationStack{
        
            
                    VStack(spacing: 0){
                        
                        
                        if ratingData.initialLoading == true {fullScreenProgessView()}
                        else{
                            
                            if ratingData.allOrgs.isEmpty {
                                emptyFeed(title: "No Reviews Yet",
                                          subTitle: "Add organizations to this page so that \(cleanSchool) students can leave reviews")}
                            else{
                                if showSearchBar {
                                    searchBar
                                    if ratingData.searchLoading {fullScreenProgessView()}
                                    else {searchFeed}
                                }
                                else {
                                    categorySelection
                                    categoryFeedTabs
                                }
                                
                            }
                        }
                    }
                    //.searchable(text: $ratingData.orgSearch)
                .onAppear() {ratingData.fetchAllData()}
                .background(Color.customGray)
                .sheet(isPresented: $showPostSheet) {NewOrgView(ratingData: ratingData, showing: $showPostSheet)}
                .navigationTitle(Text("Reviews"))
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarColor(UIColor(Color.customOrange))
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {newPostButton.padding([.leading, .vertical])}
                    ToolbarItem(placement: .navigationBarLeading) {searchButton}
                }
           // }.accentColor(.black)
      
    
        
    }
    var searchBar: some View{
        HStack{
            TextField("Search", text: $ratingData.orgSearch)
                .font(.callout)
                .padding(.leading)
                .padding(.vertical, 6)
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white).opacity(0.25))
                .padding(.horizontal, 5)
            
            Button(action: {showSearchBar = false;ratingData.orgSearch = ""}, label: {Text("Cancel").padding(.trailing).font(.callout).foregroundColor(.black)})
        }
        .padding(.bottom, 5)
        .background(Color.customOrange)
    }
    
    var categoryFeedTabs: some View {
        TabView(selection: $ratingData.filterTab) {
            ScrollView{
                if ratingData.newOrg.title != "" {
                    orgCard(org: ratingData.newOrg)
                }
                OrgCardList(category: "All", categoryFeed: ratingData.allOrgs, loading: $ratingData.initialLoading)
                if !ratingData.noMoreAllOrgs {
                    loadMoreAllOrgs
                }
            }.tag("All")
            ScrollView{
                OrgCardList(category: "Clubs", categoryFeed: ratingData.clubs, loading: $ratingData.clubLoading)
                if !ratingData.noMoreClubs && !ratingData.clubs.isEmpty {
                    loadMoreClubOrgs
                }
            }
            .tag("Clubs").onAppear(){ratingData.fetchClubData()}
            ForEach(0..<12) {num in
                ScrollView{
                    OrgCardList(category: ratingData.categories[num], categoryFeed: ratingData.orgCategoryFeeds[num], loading: $ratingData.categoryLoading[num])
                    if !ratingData.noMoreCategoryOrgs[num] && !ratingData.orgCategoryFeeds[num].isEmpty {
                        Button(action: {
                            ratingData.loadingMoreCategoryOrgs[num] = true; ratingData.moreCategoryOrgs(feedNum: num)}, label: {
                                if ratingData.loadingMoreCategoryOrgs[num] == true {ProgressView()}
                                else{
                                    Text("Load more...").foregroundColor(.orange)
                                }
                            }).padding()
                    }
                }
                .tag(ratingData.categories[num]).onAppear(){ratingData.fetchCategoryData(feedNum: num); print("running")}
            }
        }.tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    var loadMoreAllOrgs: some View {
        Button(action: {
            ratingData.loadingMoreAllOrgs = true; ratingData.moreAllOrgs()}, label: {
            if ratingData.loadingMoreAllOrgs == true {ProgressView()}
            else{
                Text("Load more...").foregroundColor(.orange)
            }
        }).padding()
    }
    var loadMoreClubOrgs: some View {
        Button(action: {
            ratingData.loadingMoreClubs = true; ratingData.moreClubOrgs()}, label: {
            if ratingData.loadingMoreClubs == true {ProgressView()}
            else{
                Text("Load more...").foregroundColor(.orange)
            }
        }).padding()
    }

    
    var searchFeed: some View {
        VStack(spacing: 0){
            let searchOrgs = ratingData.searchOrgs.filter { $0.title.lowercased().contains(ratingData.orgSearch.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))}
            if searchOrgs.isEmpty && ratingData.orgSearch.isEmpty {
                ScrollView{
                    OrgCardList(category: "All", categoryFeed: ratingData.searchOrgs, loading: $ratingData.initialLoading)
                }
            }
            else if searchOrgs.isEmpty && !ratingData.orgSearch.isEmpty{
                emptyFeed(title: "No Matching Orgs", subTitle: "Try searching other names for the organization. If it doesnt exist add it yourself.")
            }
            else {
                ScrollView{
                    OrgCardList(category: "All", categoryFeed: ratingData.searchOrgs.filter { $0.title.lowercased().contains(ratingData.orgSearch.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))}, loading: $ratingData.initialLoading)
                }
            }
        }.onTapGesture {UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)}
    }
    
//    var firstOpenNavBar: some View {
//        HStack{
//            searchButton.font(.title2).padding(.horizontal)
//            Spacer()
//            Text("Reviews")
//                .font(.headline)
//                .foregroundColor(.black)
//                .fontWeight(.semibold)
//            Spacer()
//            newPostButton.font(.title2).padding(.horizontal)
//        }.padding(.bottom, 5).background(Color.customOrange)
//    }
    
    
    var searchButton: some View {
        Button(action: {
            showSearchBar.toggle()
            ratingData.fetchSearchData()
            ratingData.orgSearch = ""
            
        }, label: {Image(systemName: "magnifyingglass").foregroundColor(.black)})
    }
    
    var newPostButton: some View {
        Button(action:
                {showPostSheet = true},
               label:
                {Image(systemName: "plus.app").foregroundColor(.black)})

    }

    

    
    var categorySelection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { value in
                HStack{
                    ForEach(ratingData.fullCategoryList, id: \.self) {category in
                        orgCategoryButton(category: category, currentTab: $ratingData.filterTab)
                    }
                }.padding(2)
                    .onChange(of: ratingData.filterTab) {newValue in value.scrollTo(ratingData.filterTab)}
            }
        }
    }
    
}

struct OrgCardList: View {
    var category: String
    var categoryFeed: [org]
    @Binding var loading: Bool
    
    var body: some View {
        if loading {
            fullScreenProgessView()
        }
        else{
            if categoryFeed.isEmpty {
                emptyFeed(title: "No Reviews", subTitle: "It looks like there are no \(category) organizations at your school.")
            }
            else{
              // ScrollView{
                    Spacer(minLength: 5)
                ForEach(Array(categoryFeed.enumerated()), id: \.element) {index, org in
                        orgCard(org: org)
                    //todo: undo if cpm doesnt change
//                    if index.isMultiple(of: 7) && index != 0 {
//                        adView()
//                            .frame(height: 100)
//                            .padding()
//                             .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white).shadow(color: Color.black.opacity(0.15), radius: 6))
//                             .padding(.horizontal)
//                             .padding(.vertical, 5)
//                    }
                        
                    //}
                    
                }
            }
        }
    }
}

struct orgCategoryButton: View {
    var category: String
    @Binding var currentTab: String
    var body: some View {
        Button(
            action: {currentTab = category},
            label:
            {
                // Fallback on earlier versions
                Text(category)
                    .font(.callout)
                    .padding(.vertical, 4)
                    .padding(.horizontal)
                    .background(currentTab == category ? Color.orange: Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(.orange, lineWidth: 1.5))
          })
        .shadow(color: Color.black.opacity(0.15), radius: 6)
        .buttonStyle(PlainButtonStyle())
    }
}

