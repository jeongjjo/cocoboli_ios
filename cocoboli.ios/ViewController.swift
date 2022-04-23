//
//  ViewController.swift
//  cocoboli.ios
//
//  Created by agilityaaa-n on 2022/04/10.
//

import Foundation
import UIKit
import WebKit

class ViewController: UIViewController {
    
    var webViews = [WKWebView]()
    
    let locationService = LocationService()
    let cameraService = CameraService()
    let albumService = AlbumService()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load call")
        

        
        let webview = self.createWebview()
        let url = URL(string: Constants.MAIN_URL)
        let request = URLRequest(url: url!)
        
        webview.load(request)
    }
    
    func createWebview() -> WKWebView {
        let contentController = WKUserContentController()
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController = contentController

        let webView = WKWebView(frame: self.view.bounds, configuration: webConfiguration)
        webView.scrollView.isScrollEnabled = false
        
        self.view.addSubview(webView)
        self.webViews.append(webView)
                
        return webView

    }
}
