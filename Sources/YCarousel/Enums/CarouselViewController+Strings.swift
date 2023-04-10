//
//  CarouselViewController+Strings.swift
//  YCarousel
//
//  Created by Sahil Saini on 05/04/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import Foundation
import YCoreUI

extension CarouselViewController {
    /// Strings
    enum Strings: String, Localizable, CaseIterable {
        /// Buttons
        case previous = "Previous_Arrow_Button"
        case next = "Next_Arrow_Button"

        /// Bundle
        static var bundle: Bundle { .module }
    }
}
