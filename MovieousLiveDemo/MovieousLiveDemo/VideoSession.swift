//
//  VideoSession.swift
//  AgoraPushStreaming
//
//  Created by ZhangJi on 2018/9/28.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit
import AgoraRtcEngineKit

@objc class VideoSession: NSObject {
    @objc var uid: Int64 = 0
    @objc var hostingView: UIView!
    @objc var canvas: AgoraRtcVideoCanvas!
    
    @objc init(uid: Int64) {
        self.uid = uid
        
        hostingView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        
        canvas = AgoraRtcVideoCanvas()
        canvas.uid = UInt(uid)
        canvas.view = hostingView
        canvas.renderMode = .hidden
    }
}

extension VideoSession {
    @objc static func localSession() -> VideoSession {
        return VideoSession(uid: 0)
    }
}
