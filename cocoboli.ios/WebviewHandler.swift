//
//  WebviewHandler.swift
//  cocoboli.ios
//
//  Created by agilityaaa-n on 2022/04/17.
//

import Foundation
import WebKit
import os

extension WebviewController: WKNavigationDelegate, WKUIDelegate {
    
    /**
     * start webview
     */
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // webview load 이후 실행
        os_log("[WebView] - start webview")
        
        // location , camera, album authorization
        let locationService = LocationService()
        let cameraService = CameraService()
        let albumService = AlbumService()

        locationService.requestLocation { coordinate in
            let lat         = coordinate.latitude.description
            let lng         = coordinate.longitude.description
            let position    = ["lat": lat, "lng": lng]
            let stringData  = self.objectToString(object: position)
            
            print("location data", stringData)

            self.webviews[0].evaluateJavaScript("currentLocation(\(stringData))")
        }
        
        cameraService.requestCameraAuthorization()
        albumService.requestAlbumAuthorization()
    }

    /**
     * finish load webview
     */
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        os_log("[WebView] - load webview")
    }
    
    /**
     * fail webview
     */
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        os_log("[WebView] - fail load webview")
    }
    
    /**
     * open popup [window.open]
     *  ---------- 팝업 열기 ----------
     *  - window.open() 호출 시 별도 팝업 webview가 생성되어야 합니다.
     *  라이브러리 정보 새창을 띄우는 경우에도 분기 처리를 해준다.
     */
    func webView(
        _ webView: WKWebView,
        createWebViewWith configuration: WKWebViewConfiguration,
        for navigationAction: WKNavigationAction,
        windowFeatures: WKWindowFeatures) -> WKWebView?
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

    /**
     * close popup [window.close]
     *  ---------- 팝업 닫기 ----------
     *  - window.close()가 호출되면 앞에서 생성한 팝업 webview를 닫아야 합니다.
     */
    func webViewDidClose(_ webView: WKWebView) {
        self.webviews.popLast()?.removeFromSuperview()
    }

    /**
     * 
     * 웹 뷰에서 새창 혹은 url scheme을 실행하는 경우 호출
     * 호출 되는 scheme:
     * kakao, tel, etc...
     */
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        os_log("[WebView] - call javascript open scheme (내부호출)")

        if let url = navigationAction.request.url {
            if let scheme = url.scheme {
                os_log("[WebView] - scheme: %d", scheme)

                if url.scheme == "tel" {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                
            }
        }

        decisionHandler(.allow)
    }

    // MARK: - override javascript function
    /**
     *  override javascritp alert
     */
    func webView(_
        webView: WKWebView,
        runJavaScriptAlertPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping () -> Void)
    {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: {(action) in completionHandler()}))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
