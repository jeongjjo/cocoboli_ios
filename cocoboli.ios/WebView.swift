//
//  WebView.swift
//  cocoboli.ios
//
//  Created by cho.min-su on 2022/03/10.
//

import SwiftUI
import WebKit
import CoreLocation
import os

struct WebView: UIViewRepresentable {
            
    func makeCoordinator() -> WebView.Coordinator {
        return Coordinator()
    }
    
    func makeUIView(context: Context) -> WKWebView {
        print("make ui view")
        
        return self.createWebview(context: context)
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        print("update ui view")
        
        let url = URL(string: Constants.MAIN_URL)
        uiView.load(URLRequest(url: url!))
        
        let locationService = LocationService()
        let cameraService = CameraService()
        let albumService = AlbumService()

        locationService.requestLocation { coordinate in
            let lat         = coordinate.latitude.description
            let lng         = coordinate.longitude.description
            let position    = ["lat": lat, "lng": lng]
            let stringData  = self.objectToString(object: position)

            uiView.evaluateJavaScript("currentLocation(\(stringData))")
        }
        
        cameraService.requestCameraAuthorization()
        albumService.requestAlbumAuthorization()
    }

    /**
     * swift에서 생성 혹은 Handling한 자료를 javascript에 보내기 위해서는 값을 string으로 변경해야 된다.
     * javascript에 데이터를 보내기 전 호출하여 string으로 변경한다.
     * custom class, custom class list는 변경할 수 없다.
     */
    func objectToString(object obj: Any) -> String {
        let jsonData = try! JSONSerialization.data(withJSONObject: obj, options: [])
        return String(data: jsonData, encoding: .utf8)!
    }
    
    func createWebview(context: Context) -> WKWebView {
        let webConfiguration = WKWebViewConfiguration()
        let contentController = WKUserContentController()

        webConfiguration.userContentController = contentController
        webConfiguration.defaultWebpagePreferences.allowsContentJavaScript = true
        webConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.isScrollEnabled = false
        
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator

        return webView
    }
    
    class Coordinator:NSObject, WKUIDelegate, WKNavigationDelegate {
        
        func webView(
            _ webView: WKWebView,
            createWebViewWith configuration: WKWebViewConfiguration,
            for navigationAction: WKNavigationAction,
            windowFeatures: WKWindowFeatures
        ) -> WKWebView?
        {
            os_log("[WebView] - call javascript open")
            
            if let url = navigationAction.request.url {
                if url.absoluteString.count != 0 {
                    os_log("[WebView] - open url | %d", url.description)
                    UIApplication.shared.open(url, options: [:])
                }
            }
            
            return nil
        }
        
        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
        {
            os_log("[WebView] - call javascript open scheme (내부호출)")
            if let url = navigationAction.request.url {
//                os_log("[WebView] - url: %d", url)
                print(url)
                if let scheme = url.scheme {
                    os_log("[WebView] - scheme: %d", scheme)
                }
//                if  url.scheme == "kakaolink" {
//                    os_log("[WebView] - Kakao | execute kakao link")
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                    decisionHandler(.cancel)
//                    return
//                } else if url.scheme == "tel" {
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                }
            }

            // 서비스 상황에 맞는 나머지 로직을 구현합니다.
//            decisionHandler(.allow)
        }

        
    }
}

struct WebView_Preview: PreviewProvider {
    static var previews: some View {
        WebView()
    }
}
