//
//  CarouselPage.swift
//  YCarousel
//
//  Created by Visakh Tharakan on 17/08/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import UIKit

/// Anything that can present a view to be used as a carousel page.
/// In our case it will be either `UIView` or `UIViewController`.
/// Used by `CarouselViewController`
protocol CarouselPage {
    /// The view
    var view: UIView! { get }
}

extension UIView: CarouselPage {
    /// The view
    var view: UIView! { self }
}

extension UIViewController: CarouselPage { }
