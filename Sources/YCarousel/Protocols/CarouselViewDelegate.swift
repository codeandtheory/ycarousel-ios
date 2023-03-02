//
//  CarouselViewDelegate.swift
//  YCarousel
//
//  Created by Visakh Tharakan on 21/07/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import UIKit

/// The methods that an object adopts to announce when a page loads or unloads
public protocol CarouselViewDelegate: AnyObject {
    /// Will be called immediately before a page is loaded.
    /// - Parameters:
    ///   - carouselView: A view that displays horizontal pages.
    ///   - page: The page that is about to be loaded.
    ///   - index: Index of the page.
    func carouselView(_ carouselView: CarouselView, pageWillLoad page: UIView, at index: Int)

    /// Will be called immediately after a page is loaded.
    /// - Parameters:
    ///   - carouselView: A view that displays horizontal pages.
    ///   - page: The page that has been loaded.
    ///   - index: Index of the page.
    func carouselView(_ carouselView: CarouselView, pageDidLoad page: UIView, at index: Int)

    /// Will be called immediately before a page is unloaded.
    /// - Parameters:
    ///   - carouselView: A view that displays horizontal pages.
    ///   - page: The page that is about to be unloaded.
    ///   - index: Index of the page.
    func carouselView(_ carouselView: CarouselView, pageWillUnload page: UIView, at index: Int)

    /// Will be called immediately after a page is unloaded.
    /// - Parameters:
    ///   - carouselView: A view that displays horizontal pages.
    ///   - page: The page that has been unloaded.
    ///   - index: Index of the page.
    func carouselView(_ carouselView: CarouselView, pageDidUnload page: UIView, at index: Int)
}
