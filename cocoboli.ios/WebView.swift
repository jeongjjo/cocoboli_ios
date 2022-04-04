//
//  WebView.swift
//  cocoboli.ios
//
//  Created by cho.min-su on 2022/03/10.
//

import SwiftUI
import WebKit
import CoreLocation

struct WebView: UIViewRepresentable {
    
    var url: String
    var webView: WKWebView?
    
    let locationService = LocationService()
    let webConfiguration = WKWebViewConfiguration()
    let contentController = WKUserContentController()
    
    func makeUIView(context: Context) -> some UIView {
        print("make ui view")

        // 초기 실행시 트리거 되는 함수 설정
        //let userScript = WKUserScript(source: "test()", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        //contentController.addUserScript(userScript)

        webConfiguration.userContentController = contentController

        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.scrollView.isScrollEnabled = false

        guard let url = URL(string: self.url) else {
            return webView
        }
        
        webView.load(URLRequest(url: url))
        
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        print("update ui view")

        locationService.requestLocation { coordinate in
            let lat         = coordinate.latitude.description
            let lng         = coordinate.longitude.description
            let position    = ["lat": lat, "lng": lng]
            let stringData  = self.objectToString(object: position)

            self.webView?.evaluateJavaScript("currentLocation(\(stringData))")
        }
        
        CameraService().requestCameraAuthorization()
        AlbumService().requestAlbumAuthorization()
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
}

struct WebView_Preview: PreviewProvider {
    static var previews: some View {
        WebView(url: Constants.MAIN_URL)
    }
}
