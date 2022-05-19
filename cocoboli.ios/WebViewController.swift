//
//  WebviewController.swift
//  cocoboli.ios
//
//  Created by agilityaaa-n on 2022/04/17.
//

import UIKit
import WebKit

class WebviewController: UIViewController {

    var webviews = [WKWebView]()

    let locationService = LocationService()
    let cameraService = CameraService()
    let albumService = AlbumService()
    let micService = MicrophoneService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let host = URL(string: Constants.MAIN_URL)
        let webConfiguration = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        
        contentController.add(self, name: "location")

        webConfiguration.userContentController = contentController
        webConfiguration.defaultWebpagePreferences.allowsContentJavaScript = true
        webConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = true

        self.createWebView(frame: self.view.frame, config: webConfiguration)
            .load(URLRequest(url: host!))        
    }
    
    func createWebView(frame: CGRect, config: WKWebViewConfiguration) -> WKWebView {
        let webview = WKWebView(frame: frame, configuration: config)
        webview.uiDelegate = self
        webview.navigationDelegate = self
        webview.allowsBackForwardNavigationGestures = true
        webview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webview.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(webview)
        self.webviews.append(webview)

//        let safeArea = self.view.safeAreaLayoutGuide
//        webview.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0).isActive = true
//        webview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
//        webview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
//        webview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
//        webview.scrollView.contentInsetAdjustmentBehavior = .never
                
        return webview
    }

    func objectToString(object obj: Any) -> String {
        let jsonData = try! JSONSerialization.data(withJSONObject: obj, options: [])
        return String(data: jsonData, encoding: .utf8)!
    }
    
    func requestAndSendLocation() {
        locationService.requestLocation { coordinate in
            let lat         = coordinate.latitude.description
            let lng         = coordinate.longitude.description
            let position    = ["lat": lat, "lng": lng]
            let stringData  = self.objectToString(object: position)
            
            print("location", stringData)
            
            self.webviews[0].evaluateJavaScript("currentLocation(\(stringData))")
        }
    }
}
