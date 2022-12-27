//
//  adView.swift
//  BlindTiger
//
//  Created by dante  delgado on 12/8/22.
//

import Foundation
import SwiftUI
import GoogleMobileAds

struct adView : UIViewRepresentable {


    func makeUIView(context: UIViewRepresentableContext<adView>) -> GADBannerView {
        let banner = GADBannerView(adSize: kGADAdSizeBanner)

        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        // REAL ADS: ca-app-pub-5704345460704356/2000662981
        // FAKE ADS: ca-app-pub-3940256099942544/2934735716
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        banner.load(GADRequest())
        return banner
    }
    func updateUIView(_ uiView: GADBannerView, context: UIViewRepresentableContext<adView>) {

    }
}

//NATIVE ADS: ca-app-pub-5704345460704356/5119431943
//FAKE ADS: ca-app-pub-3940256099942544/2934735716
