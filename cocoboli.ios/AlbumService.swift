//
//  AlbumService.swift
//  cocoboli.ios
//
//  Created by agilityaaa-n on 2022/04/04.
//

import Foundation
import Photos

class AlbumService: NSObject {
    
    func requestAlbumAuthorization() {
        PHPhotoLibrary.requestAuthorization({
            status in
            
            switch (status) {
            case .notDetermined:
                // 선택하지 않음
                break
            case .restricted:
                // 제한
                break
            case .denied:
                // 거부
                break
            case .authorized:
                // 허용
                break
            case .limited:
                // 제한적 허용
                break
            @unknown default:
                break
            }
        })
    }

}
