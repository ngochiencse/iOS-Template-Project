//
//  TutorialViewModel.swift
//  ios_template_project
//
//  Created by Hien Pham on 9/20/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class TutorialViewModelImpl: TutorialViewModel {
    private(set) var imageArray: [UIImage] = []
    init() {
        var imageArray: [UIImage] = Array()
        for index in 0...4 {
            let imageName = String(format: "tutorial_%d", index + 1)
            var suitableImageNameForCurrentDeviceSize: String
            let screenSize: CGSize = UIScreen.main.bounds.size
            if screenSize.width <= 320 {
                suitableImageNameForCurrentDeviceSize = imageName.appending("_ip5")
            } else if screenSize.width <= 375 {
                suitableImageNameForCurrentDeviceSize = imageName.appending("_ip6")
            } else {
                suitableImageNameForCurrentDeviceSize = imageName.appending("_ip6plus")
            }
            let image: UIImage = UIImage(named: suitableImageNameForCurrentDeviceSize)!
            imageArray.append(image)
        }
        self.imageArray = imageArray
    }
}
