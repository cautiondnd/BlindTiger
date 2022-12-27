//
//  PeekHomeView.swift
//  BlindTigerRedesign
//
//  Created by dante  delgado on 3/25/22.
//

import SwiftUI

struct PeekHomeView: View {
    @ObservedObject var peekData = PeekModel()
    init() { UITableView.appearance().backgroundColor = .clear }


    var body: some View {
            //Fallback on earlier versons
            VStack(spacing: 0){
               
                if peekData.initialLoading == true {fullScreenProgessView()}
                else{
                    List{
                        featuredSchools
                        allSchools
                    }.shadow(color: Color.black.opacity(0.15), radius: 4)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .background(Color.customGray)
            .onAppear() {peekData.fetchSchools()}
            .navigationBarColor(UIColor(Color.customOrange))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Peek")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                }
            }
        
           
        }
    
//    var firstOpenNavBar: some View {
//        HStack{
//            if #available(iOS 16.0, *) {
//                Text("Peek")
//                    .padding(.leading)
//                    .font(.largeTitle)
//                    .foregroundColor(.black)
//                    .fontWeight(.semibold)
//            } else {
//                // Fallback on earlier versions
//                Text("Peek")
//                    .padding(.leading)
//                    .font(.largeTitle)
//                    .foregroundColor(.black)
//            }
//            Spacer()
//        }.background(Color.customOrange)
//    }
        
    var featuredSchools: some View {
        Section(header: Text("Featured")) {
            ForEach(peekData.schools.sorted(by: {$0.name.lowercased() < $1.name.lowercased()})) { school in
                if school.featured == true && school.name.lowercased() != cleanSchool{
                    NavigationLink(
                        destination: PeekSchoolView(selectedSchool: school.id.lowercased()),
                        label: {
                            Text(school.name)})
                }
            }
        }
    }
    
    var allSchools: some View {
        Section(header: Text("All Schools")) {
            ForEach(peekData.schools.sorted(by: {$0.name.lowercased() < $1.name.lowercased()})) { school in
                if school.name.lowercased() != cleanSchool {
                    NavigationLink(
                        destination: PeekSchoolView(selectedSchool: school.id.lowercased()),
                        label: {
                            Text(school.name)})
                }
            }
        }
    }
        
    }
