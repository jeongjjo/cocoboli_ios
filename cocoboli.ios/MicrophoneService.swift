//
//  MicrophoneService.swift
//  cocoboli.ios
//
//  Created by agilityaaa-n on 2022/05/19.
//

import Foundation
import AVFAudio


class MicrophoneService : NSObject {
    
    override init() {
        
    }
    
    func requestMicrophone() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                print("Mic 허용")
            }
            else {
                print("Mic 거부")
            }
        }
    }
}
