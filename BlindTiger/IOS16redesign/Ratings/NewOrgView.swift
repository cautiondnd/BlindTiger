//
//  NewOrgView.swift
//  BlindTiger
//
//  Created by dante  delgado on 7/11/22.
//

import SwiftUI

struct NewOrgView: View {
    @ObservedObject var ratingData: RatingModel
    @Binding var showing: Bool
    @State var showErrors = false
    var body: some View {
        GeometryReader { geometry in

            VStack(alignment: HorizontalAlignment.center,spacing: 0){
                    postButton
                
                VStack(alignment: HorizontalAlignment.leading){
                    Text("New Reviewable Content")
                        .padding(.leading)
                        .foregroundColor(.gray)
                    customTextField(bindingText: $ratingData.title, showErrors: $showErrors, placeHolderText: "Title", isOptional: false)
                    descriptionTextField
                    categorySelection
                   
                    
                    Spacer()
                }
            }
            .background(Color.customGray)
            .onTapGesture {UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)}
        }.ignoresSafeArea(.keyboard, edges: .bottom)
            
       
        
    }
    var categorySelection: some View {
        VStack(alignment: HorizontalAlignment.leading){
            HStack{
                Text("Category:").foregroundColor(Color(UIColor.systemGray3))
                Spacer()
                Picker("Category", selection: $ratingData.category) {
                    Text("Select Category").tag("")
                    ForEach(ratingData.categories, id: \.self) {category in
                        Text(category).tag(category)
                    }
                   
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white))
            .padding(.horizontal)
            if showErrors && ratingData.category.isEmpty {
                Text("Must select a category")
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.leading)
            }
            
        }
    }
    var descriptionTextField: some View {
        VStack(alignment: HorizontalAlignment.leading, spacing: 2){
          
                // Fallback on earlier versions
            
            ZStack(alignment: Alignment.topLeading){
                TextEditor(text: $ratingData.description)
                    .frame(height: 250)
                    
                if ratingData.description.isEmpty {
                    Text("Description")
                    .foregroundColor(Color(UIColor.placeholderText))
                    .padding(.leading, 7)
                    .padding(.top, 9)
                    .allowsHitTesting(false)
                }
            }.padding(.leading, 5)
                .padding(.vertical, 5)
            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white)).padding([.leading, .trailing])
            
            
            if showErrors && ratingData.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text("Description must be filled out")
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.leading)
            }
            
            if showErrors && ratingData.description.trimmingCharacters(in: .whitespacesAndNewlines).count > 500 {
                Text("Description field must be less than 500 charecters (\(ratingData.description.trimmingCharacters(in: .whitespacesAndNewlines).count)/500)")
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.leading)
            }
        }
        
    }
    
    var postButton: some View {
        HStack{
            Spacer()
            Button(action: {
                ratingData.validateFields();
                //if fields are valid post if not show errors
                if ratingData.allFieldsValid {
                    ratingData.uploadOrg();
                    showing = false}
                else {showErrors = true}
            },
                   label:
                    {Text("Post")
                    .capsuleButtonStyle()
                    .padding()})
        }
    }
}



