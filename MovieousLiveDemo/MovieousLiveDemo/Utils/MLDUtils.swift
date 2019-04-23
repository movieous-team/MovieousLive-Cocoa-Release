//
//  MLDUtils.swift
//  MovieousLiveDemo
//
//  Created by Chris Wang on 2019/4/10.
//  Copyright © 2019 Movieous Team. All rights reserved.
//

import UIKit

func ShowAlert(error: Error, controller: UIViewController) {
    ShowAlert(title: "错误", message: error.localizedDescription, action: "好的", controller: controller)
}

func ShowAlert(title: String, message: String, action: String, controller: UIViewController) {
    DispatchQueue.main.async {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: action, style: .default, handler: nil))
        controller.present(alertController, animated: true, completion: nil)
    }
}
