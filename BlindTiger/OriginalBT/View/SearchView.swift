////
////  SearchView.swift
////  BlindTiger
////
////  Created by dante  delgado on 11/15/20.
////
//
//import SwiftUI
//
//struct SearchView: View {
//    @State var schoolSearch = ""
//    @ObservedObject var searchData = SearchViewModel()
//    @State var searchResults = [String]()
//    @Binding var peekBlockedUsers: [String]
//  //  init() { UITableView.appearance().backgroundColor = .clear }
//
//
//    var body: some View {
//
//        let schools = searchData.notEmptySchools
//
//        NavigationView{
//            VStack(spacing: 0){
//            ZStack{
//                Rectangle().foregroundColor(.customOrange).ignoresSafeArea( edges: .all).frame(maxWidth: .infinity, maxHeight: 55, alignment: .center)
//
//            TextField("Search", text: $schoolSearch)
//                .padding(6)
//                .background(Capsule().foregroundColor(.white)).padding(.horizontal)
//
//
//                }
//
//                //FOR TESTING
////                HStack{
////                    Button(action: {cleanSchool = "bates"}, label: {
////                        Text("bates")
////                    })
//////                    Button(action: {cleanSchool = "virginia"}, label: {
//////                        Text("uva")
//////                    })
//////                    Button(action: {cleanSchool = "umich"}, label: {
//////                        Text("umich")
//////                    })
//////                    Button(action: {cleanSchool = "bc"}, label: {
//////                        Text("bc")
//////                    })
////                    Button(action: {cleanSchool = "belmont"}, label: {
////                        Text("belmont")
////                    })
//////                    Button(action: {cleanSchool = "umd"}, label: {
//////                        Text("umd")
//////                    })
//////
//////
//////
////                }
//                // ^testing only
//
//            //change baclgroundcolor
//            if schoolSearch.isEmpty{
//        List(
//            schools.sorted(by: { $0.name < $1.name })
//        ) { school in
//
//            NavigationLink(
//                destination: PeekView(selectedSchool: school.name.lowercased(), peekBlockedUsers: $peekBlockedUsers),
//                label: {
//                    Text(school.name)
//
//                }
//            )
//
//        }
//        .shadow(color: Color.black.opacity(0.15), radius: 6)
//
//        .listStyle(InsetGroupedListStyle())
//
//
//
//
//            }
//            else {
//
//                List(
//                    schools.filter { $0.name.uppercased().hasPrefix(schoolSearch.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)) }.sorted(by: { $0.name < $1.name })
//                ) { school in
//                    NavigationLink(
//                        destination: PeekView(selectedSchool: school.name.lowercased(), peekBlockedUsers: $peekBlockedUsers),
//                        label: {
//                            Text(school.name)
//
//                        })
//
//
//                }.shadow(color: Color.black.opacity(0.15), radius: 6)
//                .listStyle(InsetGroupedListStyle())
//            }
//
//        }
//
//            .background(Rectangle().foregroundColor(.customGray).ignoresSafeArea(edges: .all))
//        .navigationBarTitle(Text(""), displayMode: .inline)
//        .navigationBarBackButtonHidden(true)
//        .toolbar{
//            ToolbarItem(placement: .navigationBarLeading) {
//                Text("Peek")
//                    .font(.largeTitle)
//                    .foregroundColor(.black)
//                    .fontWeight(.semibold)
//            }
//        }.navigationBarColor(UIColor(Color.customOrange))
//        .navigationBarBackButtonHidden(true)
//        .onAppear() {searchData.fetchSearchData()
//            UITableView.appearance().backgroundColor = .clear
//        }
//
//
//    }
//
//        .navigationBarHidden(true)
//        .background(Color.customGray)
//
//    }
//}
//
//
//
//
//
