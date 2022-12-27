//
//  NewPromoView.swift
//  BlindTiger
//
//  Created by dante  delgado on 6/24/22.
//

import SwiftUI

struct NewPromoView: View {
    @ObservedObject var bulletinData: BulletinModel
    @Binding var showing: Bool
    @State var showErrors = false
    var body: some View {
        GeometryReader { geometry in
            VStack{
                postButton
                eventInfo
                timeSelection
                Spacer()
            }
            .background(Color.customGray)
                .onTapGesture {UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)}
        }.ignoresSafeArea(.keyboard, edges: .bottom)
           
        
        
    }
    
    var postButton: some View {
        HStack{
            Spacer()
            Button(action: {
                bulletinData.validateFields();
                //if fields are valid post if not show errors
                if bulletinData.allFieldsValid {
                    bulletinData.uploadPromo();
                    showing = false}
                else {showErrors = true}
            },
                   label: {Text("Post")
                    .capsuleButtonStyle()
                    .padding()})
        }
    }
    
    var eventInfo: some View {
        VStack(alignment: HorizontalAlignment.leading){
            Text("Event Info")
                .padding(.leading)
                .foregroundColor(.gray)
            customTextField(bindingText: $bulletinData.title, showErrors: $showErrors, placeHolderText: "Title", isOptional: false)
            customTextField(bindingText: $bulletinData.organizer, showErrors: $showErrors, placeHolderText: "Organizer (Optional)", isOptional: true)
            customTextField(bindingText: $bulletinData.location, showErrors: $showErrors, placeHolderText: "Location", isOptional: false)
            descriptionTextField
            customTextField(bindingText: $bulletinData.theme, showErrors: $showErrors, placeHolderText: "Theme (Optional)", isOptional: true)

            
        }
    }
    
 
    
    var descriptionTextField: some View {
        VStack(alignment: HorizontalAlignment.leading, spacing: 2){
                // Fallback on earlier versions
            
            ZStack(alignment: Alignment.topLeading){
                TextEditor(text: $bulletinData.description)
                    .frame(height: 100)
                    
                if bulletinData.description.isEmpty {
                    Text("Description (Optional)")
                    .foregroundColor(Color(UIColor.placeholderText))
                    .padding(.leading, 7)
                    .padding(.top, 9)
                    .allowsHitTesting(false)
                }
            }.padding(.leading, 5)
            .padding(.vertical, 5)
            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white)).padding([.leading, .trailing])
            
            if showErrors && bulletinData.description.trimmingCharacters(in: .whitespacesAndNewlines).count > 280 {
                Text("Description must be less than 280 charecters (\(bulletinData.description.trimmingCharacters(in: .whitespacesAndNewlines).count)/280)")
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.leading)
            }
        }
        
    }
    
    var timeSelection: some View {
        VStack(alignment: HorizontalAlignment.leading){
                Text("Time")
                    .padding(.leading)
                    .foregroundColor(.gray)
            VStack(spacing: 5){
                if #available(iOS 15, *) {
                    DatePicker("Date", selection: ($bulletinData.startTime), in: Date.now..., displayedComponents: .date)
                        .padding(.horizontal)
                        .padding(.top, 5)
                        .padding(.bottom, 2.5)
                } else {
                    // Fallback on earlier versions
                    DatePicker("Date", selection: ($bulletinData.startTime), in: Date()..., displayedComponents: .date)
                        .padding(.horizontal)
                        .padding(.top, 5)
                        .padding(.bottom, 2.5)
                }
                Divider()
                DatePicker("Start", selection: $bulletinData.startTime, displayedComponents: .hourAndMinute)
                    .padding(.horizontal)
                    .padding(.vertical, 2.5)
                Divider()
                DatePicker("End", selection: $bulletinData.endTime, displayedComponents: .hourAndMinute)
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                    .padding(.top, 2.5)
            }.background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white))
                .padding(.horizontal)
                .onTapGesture {
                    print(bulletinData.endTime.timeIntervalSince(bulletinData.startTime).rounded(.towardZero) )
                }
            
            
            if
                (abs(bulletinData.endTime.timeIntervalSince(bulletinData.startTime).rounded(.towardZero).truncatingRemainder(dividingBy: 86400)) < 60 || abs(bulletinData.endTime.timeIntervalSince(bulletinData.startTime).rounded(.towardZero).truncatingRemainder(dividingBy: 86400)) > 86340)  && showErrors  {
                Text("Event cannot start and end at same time")
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.leading)
            }
        }
    }
}



struct customTextField: View {
    @Binding var bindingText: String
    @Binding var showErrors: Bool
    var placeHolderText: String
    var isOptional: Bool
    var charLimit = 50
    
    
    var body: some View{
        VStack(alignment: HorizontalAlignment.leading, spacing: 2){
            TextField(placeHolderText, text: $bindingText)
                .padding(.leading)
                .padding(.vertical, 10)
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white))
                .padding(.horizontal)
            
            if showErrors && !isOptional && bindingText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text("\(placeHolderText.components(separatedBy: " ").first ?? "") must be filled out")
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.leading)
            }
            if showErrors && bindingText.trimmingCharacters(in: .whitespacesAndNewlines).count > charLimit {
                Text("\(placeHolderText.components(separatedBy: " ").first ?? "") must be less than 50 charecters (\(bindingText.trimmingCharacters(in: .whitespacesAndNewlines).count)/\(charLimit))")
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.leading)
            }
        }
        
    }
}
