//
//  CarouselViewProvider.swift
//  YCarousel
//
//  Created by Karthik K Manoj on 07/20/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import Foundation
import UIKit

/// The default implementation of `CarouselViewDataSource` used when you instantiate a
/// `CarouselView` with an array of views.
internal final class CarouselViewProvider {
    internal let views: [UIView]

    internal init(views: [UIView]) {
        self.views = views
    }
}

extension CarouselViewProvider: CarouselViewDataSource {
    func carouselView(pageAt index: Int) -> UIView { views[index] }

    var numberOfPages: Int { views.count }
}
