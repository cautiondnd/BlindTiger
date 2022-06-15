//
//  KeyboardExtensions.swift
//  BlindTiger
//
//  Created by dante  delgado on 11/26/20.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
