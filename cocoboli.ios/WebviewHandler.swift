//
//  WebviewHandler.swift
//  cocoboli.ios
//
//  Created by agilityaaa-n on 2022/04/17.
//

import Foundation
import WebKit
import os

extension WebviewController: WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    
    /**
     * script handler
     */
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let name = message.name
        
        if name.isEqual("location") {
            print("call location method")
            let status = locationService.getLocationStatus()
            
            if status == .denied || status == .restricted {
                let alertTitle      = "위치권한 설정이 '안함'으로 되어있습니다."
                let alertMessage    = "앱 설정 화면으로 가시겠습니까?"
                let okTitle         = "확인"
                let noTitle         = "취소"
                
                let alert       = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                let noAction    = UIAlertAction(title: noTitle, style: .destructive, handler: nil)
                let okAction    = UIAlertAction(title: okTitle, style: .default) {
                    (action: UIAlertAction) in
                    UIApplication.shared.open(NSURL(string:UIApplication.openSettingsURLString)! as URL)
                }

                alert.addAction(noAction)
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)

            }  else {
                self.requestAndSendLocation()
            }
        }
    }
    
    
    /**
     * start webview
     */
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // webview load 이후 실행
        os_log("[WebView] - start webview")
        
        self.requestAndSendLocation()
                
        cameraService.requestCameraAuthorization()
        albumService.requestAlbumAuthorization()
        micService.requestMicrophone()
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
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    {
        os_log("[WebView] - call javascript open scheme (내부호출)")
        
        let request = navigationAction.request
        let optUrl = request.url
        let optUrlScheme = optUrl?.scheme

        guard let url = optUrl, let scheme = optUrlScheme
            else {
                return decisionHandler(.cancel)
        }

        debugPrint("url : \(url)")

        if scheme != "http" && scheme != "https" {
            if scheme == "ispmobile" && !UIApplication.shared.canOpenURL(url) {  //ISP 미설치 시
                let ispUrl = URL(string: "http://itunes.apple.com/kr/app/id369125087?mt=8")!
                UIApplication.shared.open(ispUrl)
            }
            else if scheme == "kftc-bankpay" && !UIApplication.shared.canOpenURL(url) {    //BANKPAY 미설치 시
                let bankpayUrl = URL(string: "http://itunes.apple.com/us/app/id398456030?mt=8")!
                UIApplication.shared.open(bankpayUrl)
            }
            else {
                if( UIApplication.shared.canOpenURL(url) ) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    //1. App 미설치 확인
                    //2. info.plist 내 scheme 등록 확인
                }
            }
        }
        else if scheme == "tel" {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
