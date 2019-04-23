//
//  MLDStreamerViewController.swift
//  MovieousLiveDemo
//
//  Created by Chris Wang on 2019/4/10.
//  Copyright © 2019 Movieous Team. All rights reserved.
//

import UIKit
import MovieousLive
import SnapKit

class MLDStreamerViewController: UIViewController, MLStreamerDelegate, MLDParameterViewControllerDelegate {
    
    var streamer: MLStreamer? = nil
    var videoConfiguration: MLVideoConfiguration?
    var audioConfiguration: MLAudioConfiguration?
    var startButton: UIButton!
    var muteButton: UIButton!
    var switchCameraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.setRightBarButton(UIBarButtonItem(title: "settings", style: .plain, target: self, action: #selector(settingsButtonPressed(sender:))), animated: false)
        do {
            try streamer = MLStreamer(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
        } catch {
            ShowAlert(error: error, controller: self)
        }
        if let streamer = streamer {
            streamer.delegate = self
            streamer.touchToFocusExposureEnabled = true
            streamer.innerFocusViewEnabled = true
            let LUTFilterRecorderEffect = MovieousLUTFilterCaptureEffect()
            let image = UIImage(named: "filter_test1")!
            LUTFilterRecorderEffect.image = image
            let imageStickerFilterRecorderEffect = MovieousImageStickerCaptureEffect()
            imageStickerFilterRecorderEffect.image = image
            imageStickerFilterRecorderEffect.destRect = CGRect(x: 0, y: 0, width: 100, height: 100)
//            streamer.captureEffects = [LUTFilterRecorderEffect, imageStickerFilterRecorderEffect]
            view.addSubview(streamer.previewView)
            streamer.previewView.frame = view.bounds
            weak var wSelf = self
            streamer.startCapturing { (audioGranted: Bool, audioError: Error?, videoGranted: Bool, videoError: Error?) in
                guard let strongSelf = wSelf else { return }
                if let videoError = videoError {
                    ShowAlert(error: videoError, controller: strongSelf)
                    return
                }
                if let audioError = audioError {
                    ShowAlert(error: audioError, controller: strongSelf)
                    return
                }
                strongSelf.streamer?.startStreamStatisticsUpdate(withInterval: 1)
            }
        }
        
        startButton = UIButton(type: .system)
        startButton.setTitle("开始推流", for: .normal)
        startButton.setTitle("结束推流", for: .selected)
        startButton.addTarget(self, action: #selector(startButtonPressed(sender:)), for: .touchUpInside)
        view.addSubview(startButton)
        startButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view).offset(-30)
            make.centerX.equalTo(view)
        }
        
        switchCameraButton = UIButton(type: .system)
        switchCameraButton.setTitle("切换摄像头", for: .normal)
        switchCameraButton.addTarget(self, action: #selector(switchCameraButtonPressed(sender:)), for: .touchUpInside)
        view.addSubview(switchCameraButton)
        switchCameraButton.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(100)
            make.right.equalTo(view).offset(-40)
        }
    }

    @objc func startButtonPressed(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            do {
                try streamer?.startPushing(withServerURL: <#T##URL#>)
            } catch {
                ShowAlert(error: error, controller: self)
                return
            }
        } else {
            streamer?.stopPushing()
        }
    }
    
    @objc func muteButtonPressed(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        streamer?.mute = sender.isSelected
    }
    
    @objc func switchCameraButtonPressed(sender: UIButton) {
        streamer?.switchCamera()
    }
    
    @objc func settingsButtonPressed(sender: UIBarButtonItem) {
        if let streamer = streamer {
            let controller = MLDParameterViewController(style: .plain)
            controller.title = "streamer configuration"
            controller.parameters = [
                MLDParameter(name: "previewScalingMode", type: .enums, value: streamer.previewScalingMode, candidateValues: MovieousScalingMode.candidateValues()),
                MLDParameter(name: "mirrorFrontPreview", type: .boolean, value: streamer.mirrorFrontPreview),
                MLDParameter(name: "mirrorBackPreview", type: .boolean, value: streamer.mirrorBackPreview),
                MLDParameter(name: "mirrorFrontEncoded", type: .boolean, value: streamer.mirrorFrontEncoded),
                MLDParameter(name: "mirrorBackEncoded", type: .boolean, value: streamer.mirrorBackEncoded),
                MLDParameter(name: "touchToFocusExposureEnabled", type: .boolean, value: streamer.touchToFocusExposureEnabled),
                MLDParameter(name: "innerFocusViewEnabled", type: .boolean, value: streamer.innerFocusViewEnabled),
                MLDParameter(name: "preferredTorchMode", type: .enums, value: streamer.preferredTorchMode, candidateValues: AVCaptureDevice.TorchMode.candidateValues()),
                MLDParameter(name: "preferredMinFrameRate", type: .float, value: streamer.preferredMinFrameRate),
                MLDParameter(name: "preferredMaxFrameRate", type: .float, value: streamer.preferredMaxFrameRate),
                MLDParameter(name: "preferredSessionPreset", type: .enums, value: streamer.preferredSessionPreset, candidateValues: AVCaptureSession.Preset.candidateValues()),
                MLDParameter(name: "preferredDevicePosition", type: .enums, value: streamer.preferredDevicePosition, candidateValues: AVCaptureDevice.Position.candidateValues()),
                MLDParameter(name: "preferredVideoOrientation", type: .enums, value: streamer.preferredVideoOrientation, candidateValues: AVCaptureVideoOrientation.candidateValues()),
                MLDParameter(name: "preferredVideoZoomFactor", type: .float, value: streamer.preferredVideoZoomFactor),
                MLDParameter(name: "preferredContinuousAutoFocusEnable", type: .boolean, value: streamer.preferredContinuousAutoFocusEnable),
                MLDParameter(name: "preferredContinuousAutoExposureEnable", type: .boolean, value: streamer.preferredContinuousAutoExposureEnable),
                MLDParameter(name: "mute", type: .boolean, value: streamer.mute),
            ]
            controller.delegate = self
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func parameterViewController(_ viewController: MLDParameterViewController, parametersDidSaved parameters: [MLDParameter]) {
        for parameter in parameters {
            if let streamer = streamer {
                if type(of: parameter.value) == MovieousScalingMode.self {
                    streamer.setValue((parameter.value as! MovieousScalingMode).rawValue, forKey: parameter.name)
                } else if type(of: parameter.value) == AVCaptureDevice.TorchMode.self {
                    streamer.setValue((parameter.value as! AVCaptureDevice.TorchMode).rawValue, forKey: parameter.name)
                } else if type(of: parameter.value) == AVCaptureVideoOrientation.self {
                    streamer.setValue((parameter.value as! AVCaptureVideoOrientation).rawValue, forKey: parameter.name)
                } else if type(of: parameter.value) == AVCaptureDevice.Position.self {
                    streamer.setValue((parameter.value as! AVCaptureDevice.Position).rawValue, forKey: parameter.name)
                } else {
                    streamer.setValue(parameter.value, forKey: parameter.name)
                }
            }
        }
    }
    
    func streamer(_ streamer: MLStreamer, streamStatisticsDidUpdated streamStatistics: MLStreamStatistics) {
        print(streamStatistics)
    }
    
    func streamer(_ streamer: MLStreamer, didFailedWithError error: Error) {
        streamer.stopPushing()
        ShowAlert(error: error, controller: self)
        DispatchQueue.main.async {
            self.startButton.isSelected = false
        }
    }
}

