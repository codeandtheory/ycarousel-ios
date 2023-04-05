//
//  CarouselViewController.swift
//  YCarousel
//
//  Created by Visakh Tharakan on 21/07/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import UIKit

/// A view controller that manages a carousel view
public class CarouselViewController: UIViewController, CarouselViewDelegate, CarouselViewDataSource {
    private let pages: [CarouselPage]

    /// Disables key commands. Default is `false`.
    public var disableKeyCommand: Bool = false

    /// The carousel view managed by this controller
    public var carouselView: CarouselView! { view as? CarouselView }

    /// Creates a carousel view controller object with the specified views.
    /// - Parameter views: The list of views to be added as pages
    public required init(views: [UIView]) {
        self.pages = views
        super.init(nibName: nil, bundle: nil)
    }

    /// Creates a carousel view controller with the views of the view controllers.
    /// - Parameter viewControllers: The list of view controllers  whose views are to be added as pages
    public required init(viewControllers: [UIViewController]) {
        pages = viewControllers
        super.init(nibName: nil, bundle: nil)
    }

    internal required init?(coder: NSCoder) { nil }

    /// :nodoc:
    public override func loadView() {
        let carouselView = CarouselView()
        carouselView.dataSource = self
        carouselView.delegate = self
        self.view = carouselView
        setKeys()
    }

    // MARK: - CarouselViewDelegate

    /// Will be called immediately before a page is loaded.
    /// - Parameters:
    ///   - carouselView: A view that displays horizontal pages.
    ///   - page: The page that is about to be loaded.
    ///   - index: Index of the page.
    public func carouselView(_ carouselView: CarouselView, pageWillLoad page: UIView, at index: Int) {
        if let childController = pages[index] as? UIViewController {
            addChild(childController)
        }
    }

    /// Will be called immediately after a page is loaded.
    /// - Parameters:
    ///   - carouselView: A view that displays horizontal pages.
    ///   - page: The page that has been loaded.
    ///   - index: Index of the page.
    public func carouselView(_ carouselView: CarouselView, pageDidLoad page: UIView, at index: Int) {
        if let childController = pages[index] as? UIViewController {
            childController.didMove(toParent: self)
        }
    }

    /// Will be called immediately before a page is unloaded.
    /// - Parameters:
    ///   - carouselView: A view that displays horizontal pages.
    ///   - page: The page that is about to be unloaded.
    ///   - index: Index of the page.
    public func carouselView(_ carouselView: CarouselView, pageWillUnload page: UIView, at index: Int) {
        if let childController = pages[index] as? UIViewController {
            childController.willMove(toParent: nil)
        }
    }

    /// Will be called immediately after a page is unloaded.
    /// - Parameters:
    ///   - carouselView: A view that displays horizontal pages.
    ///   - page: The page that has been unloaded.
    ///   - index: Index of the page.
    public func carouselView(_ carouselView: CarouselView, pageDidUnload page: UIView, at index: Int) {
        if let childController = pages[index] as? UIViewController {
            childController.removeFromParent()
        }
    }

    // MARK: - CarouselViewDataSource

    /// Indicates the number of pages to be displayed.
    public var numberOfPages: Int { pages.count }

    /// Returns the pages to be displayed.
    /// - Parameter index: Indicates the index of a page.
    /// - Returns: UIView
    public func carouselView(pageAt index: Int) -> UIView { pages[index].view }
}

// MARK: - UIKeyCommand

internal extension CarouselViewController {
    func setKeys() {
        let rightArrow = UIKeyCommand(
            title: CarouselViewController.Strings.next.localized,
            action: #selector(rightArrowKeyPressed),
            input: UIKeyCommand.inputRightArrow
        )
        let leftArrow = UIKeyCommand(
            title: CarouselViewController.Strings.previous.localized,
            action: #selector(leftArrowKeyPressed),
            input: UIKeyCommand.inputLeftArrow
        )
        
        addKeyCommand(leftArrow)
        addKeyCommand(rightArrow)
    }

    @objc func leftArrowKeyPressed() {
        if disableKeyCommand {
            return
        }
        self.carouselView.loadView(at: carouselView.currentPage - 1)
    }

    @objc func rightArrowKeyPressed() {
        if disableKeyCommand {
            return
        }
        self.carouselView.loadView(at: carouselView.currentPage + 1)
    }
}
