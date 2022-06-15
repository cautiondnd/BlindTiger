//
//  UploadImage.swift
//  BlindTiger
//
//  Created by dante  delgado on 1/3/21.
//

import SwiftUI
import Firebase

func UploadImage(imageData: Data,completion: @escaping (String) -> ()){
    
    let storage = Storage.storage().reference()
    let uid = Auth.auth().currentUser!.uid
    
    storage.child(uid).putData(imageData, metadata: nil) { (_, err) in
        
        if err != nil{
            completion("")
            return
            
        }
        
        // Downloading Url And Sending Back...
        
        storage.child(uid).downloadURL { (url, err) in
            if err != nil{
                completion("")
                return
                
            }
            completion("\(url!)")
        }
    }
}
