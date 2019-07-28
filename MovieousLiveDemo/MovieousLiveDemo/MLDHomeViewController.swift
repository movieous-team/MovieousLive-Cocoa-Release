//
//  MLDHomeViewController.swift
//  MovieousLiveDemo
//
//  Created by Chris Wang on 2019/4/17.
//  Copyright © 2019 Movieous Team. All rights reserved.
//

import UIKit
import SnapKit
import MovieousLive
import AVFoundation


extension MovieousScalingMode: CandidateValue {
    static func candidateValues() -> [MovieousScalingMode] {
        return [.fill, .aspectFit, .aspectFill]
    }
    
    func string() -> String {
        switch self {
        case .fill:
            return "fill"
        case .aspectFit:
            return "aspectFit"
        default:
            return "aspectFill"
        }
    }
}

extension AVCaptureSession.Preset: CandidateValue {
    static func candidateValues() -> [AVCaptureSession.Preset] {
        return [.high, .medium, .low, cif352x288, .vga640x480, .hd1280x720, .hd1920x1080, .hd4K3840x2160, .iFrame960x540, .iFrame1280x720]
    }
    
    func string() -> String {
        return rawValue
    }
}

extension AVCaptureDevice.Position: CandidateValue {
    static func candidateValues() -> [AVCaptureDevice.Position] {
        return [.unspecified, .back, .front]
    }
    
    func string() -> String {
        switch self {
        case .unspecified:
            return "unspecified"
        case .back:
            return "back"
        default:
            return "front"
        }
    }
}

extension String: CandidateValue {
    static func candidateValues() -> [String] {
        return [
            AVVideoProfileLevelH264Baseline30,
            AVVideoProfileLevelH264Baseline31,
            AVVideoProfileLevelH264Baseline41,
            AVVideoProfileLevelH264BaselineAutoLevel,
            AVVideoProfileLevelH264Main30,
            AVVideoProfileLevelH264Main31,
            AVVideoProfileLevelH264Main32,
            AVVideoProfileLevelH264Main41,
            AVVideoProfileLevelH264MainAutoLevel,
            AVVideoProfileLevelH264High40,
            AVVideoProfileLevelH264High41,
            AVVideoProfileLevelH264HighAutoLevel,
        ]
    }
    
    func string() -> String {
        return self
    }
}

extension AVCaptureDevice.TorchMode: CandidateValue {
    static func candidateValues() -> [AVCaptureDevice.TorchMode] {
        return [.off, .on, .auto]
    }
    
    func string() -> String {
        switch self {
        case .off:
            return "off"
        case .on:
            return "on"
        default:
            return "auto"
        }
    }
}

extension AVCaptureVideoOrientation: CandidateValue {
    static func candidateValues() -> [AVCaptureVideoOrientation] {
        return [.portrait, .portraitUpsideDown, .landscapeRight, .landscapeLeft]
    }
    
    func string() -> String {
        switch self {
        case .portrait:
            return "portrait"
        case .portraitUpsideDown:
            return "portraitUpsideDown"
        case .landscapeRight:
            return "landscapeRight"
        default:
            return "landscapeLeft"
        }
    }
}

class MLDHomeViewController: UIViewController, MLDParameterViewControllerDelegate {
    let startButton = UIButton(type: .system)
    let videoSettingsButton = UIButton(type: .system)
    let audioSettingsButton = UIButton(type: .system)
    let videoConfiguration = MLVideoConfiguration.default()
    let audioConfiguration = MLAudioConfiguration.default()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        
        startButton.setTitle("直播", for: .normal)
        startButton.addTarget(self, action: #selector(startButtonPressed(sender:)), for: .touchUpInside)
        view.addSubview(startButton)
        startButton.snp.makeConstraints { (make) in
            make.center.equalTo(view)
        }
        
        videoSettingsButton.setTitle("视频设置", for: .normal)
        videoSettingsButton.addTarget(self, action: #selector(videoSettingsButtonPressed(sender:)), for: .touchUpInside)
        view.addSubview(videoSettingsButton)
        videoSettingsButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(view).offset(-50)
            make.top.equalTo(view).offset(100)
        }
        
        audioSettingsButton.setTitle("音频设置", for: .normal)
        audioSettingsButton.addTarget(self, action: #selector(audioSettingsButtonPressed(sender:)), for: .touchUpInside)
        view.addSubview(audioSettingsButton)
        audioSettingsButton.snp.makeConstraints { (make) in
            make.leading.equalTo(view).offset(50)
            make.top.equalTo(view).offset(100)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc func startButtonPressed(sender: UIButton) {
        let controller = MLDStreamerViewController()
        controller.videoConfiguration = videoConfiguration
        controller.audioConfiguration = audioConfiguration
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func videoSettingsButtonPressed(sender: UIButton) {
        let controller = MLDParameterViewController()
        controller.title = "video configuration"
        controller.parameters = [
            MLDParameter(name: "size.width", type: .float, value: Float(videoConfiguration.size.width)),
            MLDParameter(name: "size.height", type: .float, value: Float(videoConfiguration.size.height)),
            MLDParameter(name: "previewScalingMode", type: .enums, value: videoConfiguration.previewScalingMode, candidateValues: MovieousScalingMode.candidateValues()),
            MLDParameter(name: "mirrorFrontPreview", type: .boolean, value: videoConfiguration.mirrorFrontPreview),
            MLDParameter(name: "mirrorBackPreview", type: .boolean, value: videoConfiguration.mirrorBackPreview),
            MLDParameter(name: "mirrorFrontEncoded", type: .boolean, value: videoConfiguration.mirrorFrontEncoded),
            MLDParameter(name: "mirrorBackEncoded", type: .boolean, value: videoConfiguration.mirrorBackEncoded),
            MLDParameter(name: "blurSwitch", type: .boolean, value: videoConfiguration.blurSwitch),
            MLDParameter(name: "touchToFocusExposureEnabled", type: .boolean, value: videoConfiguration.touchToFocusExposureEnabled),
            MLDParameter(name: "innerFocusViewEnabled", type: .boolean, value: videoConfiguration.innerFocusViewEnabled),
            MLDParameter(name: "preferredTorchMode", type: .enums, value: videoConfiguration.preferredTorchMode, candidateValues: AVCaptureDevice.TorchMode.candidateValues()),
            MLDParameter(name: "preferredMinFrameRate", type: .float, value: videoConfiguration.preferredMinFrameRate),
            MLDParameter(name: "preferredMaxFrameRate", type: .float, value: videoConfiguration.preferredMaxFrameRate),
            MLDParameter(name: "preferredSessionPreset", type: .enums, value: videoConfiguration.preferredSessionPreset, candidateValues: AVCaptureSession.Preset.candidateValues()),
            MLDParameter(name: "preferredDevicePosition", type: .enums, value: videoConfiguration.preferredDevicePosition, candidateValues: AVCaptureDevice.Position.candidateValues()),
            MLDParameter(name: "preferredVideoOrientation", type: .enums, value: videoConfiguration.preferredVideoOrientation, candidateValues: AVCaptureVideoOrientation.candidateValues()),
            MLDParameter(name: "preferredVideoZoomFactor", type: .float, value: videoConfiguration.preferredVideoZoomFactor),
            MLDParameter(name: "preferredContinuousAutoFocusEnable", type: .boolean, value: videoConfiguration.preferredContinuousAutoFocusEnable),
            MLDParameter(name: "preferredContinuousAutoExposureEnable", type: .boolean, value: videoConfiguration.preferredContinuousAutoExposureEnable),
            MLDParameter(name: "averageVideoBitRate", type: .int, value: videoConfiguration.averageVideoBitRate),
            MLDParameter(name: "maxKeyframeInterval", type: .int, value: videoConfiguration.maxKeyframeInterval),
            MLDParameter(name: "maxKeyFrameIntervalDuration", type: .int, value: videoConfiguration.maxKeyFrameIntervalDuration),
            MLDParameter(name: "videoProfileLevel", type: .enums, value: videoConfiguration.videoProfileLevel, candidateValues: String.candidateValues()),
        ]
        if #available(iOS 12.0, *) {
            controller.parameters.append(MLDParameter(name: "maximizePowerEfficiency", type: .boolean, value: videoConfiguration.maximizePowerEfficiency))
        }
        controller.delegate = self;
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func audioSettingsButtonPressed(sender: UIButton) {
        let controller = MLDParameterViewController()
        controller.title = "audio configuration"
        controller.parameters = [
            MLDParameter(name: "bitrate", type: .int, value: audioConfiguration.bitrate),
            MLDParameter(name: "mute", type: .boolean, value: audioConfiguration.mute),
        ]
        controller.delegate = self;
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func parameterViewController(_ viewController: MLDParameterViewController, parametersDidSaved parameters: [MLDParameter]) {
        if viewController.title == "video configuration" {
            for parameter in parameters {
                if parameter.name == "size.width" {
                    videoConfiguration.size.width = CGFloat(parameter.value as! Float)
                } else if parameter.name == "size.height" {
                    videoConfiguration.size.height = CGFloat(parameter.value as! Float)
                } else {
                    if type(of: parameter.value) == MovieousScalingMode.self {
                        videoConfiguration.setValue((parameter.value as! MovieousScalingMode).rawValue, forKey: parameter.name)
                    } else if type(of: parameter.value) == AVCaptureDevice.TorchMode.self {
                        videoConfiguration.setValue((parameter.value as! AVCaptureDevice.TorchMode).rawValue, forKey: parameter.name)
                    } else if type(of: parameter.value) == AVCaptureVideoOrientation.self {
                        videoConfiguration.setValue((parameter.value as! AVCaptureVideoOrientation).rawValue, forKey: parameter.name)
                    } else if type(of: parameter.value) == AVCaptureDevice.Position.self {
                        videoConfiguration.setValue((parameter.value as! AVCaptureDevice.Position).rawValue, forKey: parameter.name)
                    } else {
                        videoConfiguration.setValue(parameter.value, forKey: parameter.name)
                    }
                }
            }
        } else {
            for parameter in parameters {
                audioConfiguration.setValue(parameter.value, forKey: parameter.name)
            }
        }
    }
}
