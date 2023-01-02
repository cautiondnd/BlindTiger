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
        let banner = GADBannerView(adSize: GADAdSizeBanner)

        banner.adUnitID = "ca-app-pub-5704345460704356/2000662981"
        // REAL ADS: ca-app-pub-5704345460704356/2000662981
        // FAKE ADS: ca-app-pub-3940256099942544/2934735716
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        banner.load(GADRequest())
        return banner
    }
    func updateUIView(_ uiView: GADBannerView, context: UIViewRepresentableContext<adView>) {

    }
}



struct NativeAdView: UIViewRepresentable {
  typealias UIViewType = GADNativeAdView

  @ObservedObject var nativeAdViewModel: ViewModel
    
    

   func makeUIView(context: Context) -> GADNativeAdView {
       
       nativeAdViewModel.loadAd()
    
       
       let nibView =  Bundle.main.loadNibNamed(
        "GADTMediumTemplateView",
        owner: nil,
        options: nil)?.first as! GADNativeAdView
       
       return nibView
     
  }

  func updateUIView(_ nativeAdView: GADNativeAdView, context: Context) {
     
    guard let nativeAd = nativeAdViewModel.nativeAd else { return }
      
      print("Updated view update")
        
      // Modifying the adview to conform to the medium template
      
      (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
      nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
      
      
      nativeAdView.translatesAutoresizingMaskIntoConstraints = true

      // Create the layout constraints


        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body

        nativeAdView.bodyView?.isHidden = nativeAd.body == nil

        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil

        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil


        (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
        nativeAdView.storeView?.isHidden = nativeAd.store == nil

        (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
        nativeAdView.priceView?.isHidden = nativeAd.price == nil

        (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
        nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil

       
        nativeAdView.callToActionView?.isUserInteractionEnabled = false
  
        let widthConstraint = NSLayoutConstraint(item: nativeAdView, attribute: .width, relatedBy: .equal, toItem: UIApplication.shared.windows.first?.rootViewController!.view, attribute: .width, multiplier: 0.9, constant: 0)
      
//      widthConstraint.priority = .
      widthConstraint.isActive = true
     
      

        nativeAdView.nativeAd = nativeAd
        }
}


class ViewModel: NSObject, ObservableObject, GADNativeAdLoaderDelegate, GADNativeAdDelegate {
  @Published var nativeAd: GADNativeAd?
  private var adLoader: GADAdLoader!
    
    let adViewOptions = GADNativeAdViewAdOptions()
    
    
  func loadAd() {
      let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
          multipleAdsOptions.numberOfAds = 5
    
    adLoader = GADAdLoader(
      adUnitID:
        "ca-app-pub-5704345460704356/5119431943",
      rootViewController: nil,
      adTypes: [.native], options: [multipleAdsOptions])
    adLoader.delegate = self
    adLoader.load(GADRequest())
      
      }

    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        
        self.nativeAd = nativeAd
        nativeAd.delegate = self
       
    }

  func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
    print("\(adLoader) failed with error: \(error.localizedDescription)")
  }
    
   
}



struct nativeAdViewDisplay: View{
    
    @StateObject private var viewModel = ViewModel()
    var body: some View{
        
        // Change foregroundColor to .clear if you don't want to display it like a card
        
        NativeAdView(nativeAdViewModel: viewModel).frame(width: 350,height: 350,alignment: .center).padding()
            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white).shadow(color: Color.black.opacity(0.15), radius: 6)).padding(.horizontal).padding(.vertical, 5).aspectRatio(contentMode: .fill)
//
       
    }
}

//NATIVE ADS: ca-app-pub-5704345460704356/5119431943
//FAKE ADS: ca-app-pub-3940256099942544/2934735716
