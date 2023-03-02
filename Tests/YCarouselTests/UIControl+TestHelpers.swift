//
//  UIControl+TestHelpers.swift
//  YCarousel
//
//  Created by Karthik K Manoj on 07/20/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import UIKit

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0), with: self)
            }
        }
    }
}
