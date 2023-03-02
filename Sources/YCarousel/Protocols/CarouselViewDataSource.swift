//
//  CarouselViewDataSource.swift
//  YCarousel
//
//  Created by Visakh Tharakan on 21/07/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import UIKit

/// The methods that an object adopts to provide views for a `CarouselView`.
public protocol CarouselViewDataSource: AnyObject {
    /// Total number of pages for a `CarouselView`.
    var numberOfPages: Int { get }

    /// Returns the view at the index you specify.
    /// - Parameter index: An index locating a view in `CarouselView`.
    /// - Returns: A `UIView` object.
    func carouselView(pageAt index: Int) -> UIView
}
