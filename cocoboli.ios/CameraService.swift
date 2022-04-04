//
//  CameraService.swift
//  cocoboli.ios
//
//  Created by agilityaaa-n on 2022/04/04.
//

import Foundation
import AVFoundation

class CameraService: NSObject {
    
    
    func requestCameraAuthorization() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {
            authorized in
            
            if authorized {
                // 허용
            }
            else {
                // 거부
            }
        })
    }

}
