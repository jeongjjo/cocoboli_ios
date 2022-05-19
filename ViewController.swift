//
//  ViewController.swift
//  cocoboli.ios
//
//  Created by agilityaaa-n on 2022/04/17.
//

import SwiftUI

struct ViewController: UIViewControllerRepresentable {
    
    let webviewController = WebviewController()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return webviewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        let status = webviewController.locationService.getLocationStatus()
        print("update ui view controller")
        if status != .authorizedAlways && status != .authorizedWhenInUse {
            webviewController.requestAndSendLocation()
        }
    }
}
