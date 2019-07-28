//
//  MLDFilter.swift
//  MovieousLiveDemo
//
//  Created by Chris Wang on 2019/5/28.
//  Copyright © 2019 Movieous Team. All rights reserved.
//

import UIKit
import MovieousBase

class MLDFilter: NSObject, MovieousExternalFilter {
    static let shared = MLDFilter()
    
    static func sharedInstance() -> MovieousExternalFilter {
        return shared
    }
    
    func processPixelBuffer(_ pixelBuffer: CVPixelBuffer, sampleTimingInfo: CMSampleTimingInfo) -> Unmanaged<CVPixelBuffer> {
        return Unmanaged.passUnretained(pixelBuffer)
    }
}
