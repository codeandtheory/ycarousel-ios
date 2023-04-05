//
//  CarouselView.swift
//  YCarousel
//
//  Created by Karthik K Manoj on 07/20/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import UIKit
import YCoreUI

/// A horizontally scrolling carousel view
public class CarouselView: UIView {
    /// The object that acts as the delegate of the CarouselView.
    public weak var delegate: CarouselViewDelegate?

    /// The object that acts as the data source of the CarouselView.
    public weak var dataSource: CarouselViewDataSource? {
        didSet {
            buildPageIfValid()
        }
    }

    /// The current page number.
    public private(set) var currentPage: Int {
        get { pageControl.currentPage }

        set { pageControl.currentPage = newValue }
    }

    /// Horizontal padding around the scroll view page within the carousel.
    ///
    /// This translates into whether adjacent pages are visible to either side of the current page.
    /// Defaults to `.zero` (no adjacent pages visible unless panning).
    /// Negative values lead to undefined behavior.
    public let horizontalPadding: CGFloat

    private var numberOfPages: Int {
        dataSource?.numberOfPages ?? .zero
    }

    private var pageWidth: CGFloat = .nan {
        didSet {
            if pageWidth != oldValue {
                // we need to unload pages when the width changes because
                // leading constraints are based upon width
                unloadPages()
                loadPages(at: currentPage)
                updateScrollView(using: currentPage)
            }
        }
    }
    
    private let pageControlBottomSpacing: CGFloat = 16
    private var viewProvider: CarouselViewProvider?

    internal let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.accessibilityIdentifier = AccessibilityIdentifier.scrollView
        return scrollView
    }()

    internal let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    /// A control that displays a horizontal series of dots, each of which corresponds to a page.
    public private(set) lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.accessibilityIdentifier = AccessibilityIdentifier.pageControl
        pageControl.backgroundStyle = .prominent
        pageControl.addTarget(self, action: #selector(pageControlValueChanged), for: .valueChanged)
        return pageControl
    }()

    /// Initializes an empty carousel view
    /// - Parameters:
    ///   - frame: the initial frame of the carousel (defaults to `.zero`)
    ///   - horizontalPadding: the horizontal padding to use (defaults to `0`)
    public required init(frame: CGRect = .zero, horizontalPadding: CGFloat = 0) {
        self.horizontalPadding = horizontalPadding
        super.init(frame: frame)
    }

    /// :nodoc:
    public required init?(coder: NSCoder) { nil }

    /// Initializes a carousel view populated with the specified views
    /// - Parameters:
    ///   - frame: the initial frame of the carousel (defaults to `.zero`)
    ///   - views: the carousel pages to display
    ///   - horizontalPadding: the horizontal padding to use (defaults to `0`)
    public required init(frame: CGRect = .zero, views: [UIView], horizontalPadding: CGFloat = 0) {
        viewProvider = CarouselViewProvider(views: views)
        dataSource = viewProvider
        self.horizontalPadding = horizontalPadding
        super.init(frame: frame)

        buildPageIfValid()
    }

    /// :nodoc:
    public override func layoutSubviews() {
        super.layoutSubviews()
        pageWidth = scrollView.bounds.width
    }

    /// :nodoc:
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if pageControl.frame.contains(point) {
            return pageControl
        }
        // All other touches within the carousel view should be forwarded to the scroll view
        if bounds.contains(point) {
            return scrollView
        }
        return nil
    }

    /// Load view at index
    /// - Parameter index: index of view
    public func loadView(at index: Int) {
        guard 0..<numberOfPages ~= index else {
            return
        }
        currentPage = index
        gotoPage(at: index)
    }
}

internal extension CarouselView {
    func loadPage(at index: Int) {
        guard 0..<numberOfPages ~= index,
              let page = dataSource?.carouselView(pageAt: index),
              page.superview == nil else { return }

        delegate?.carouselView(self, pageWillLoad: page, at: index)
        contentView.addSubview(page)
        delegate?.carouselView(self, pageDidLoad: page, at: index)

        constrain(page: page, at: index)
    }

    func unloadPage(at index: Int) {
        guard 0..<numberOfPages ~= index,
              let page = dataSource?.carouselView(pageAt: index),
              page.superview != nil else { return }

        delegate?.carouselView(self, pageWillUnload: page, at: index)
        page.removeFromSuperview()
        delegate?.carouselView(self, pageDidUnload: page, at: index)
    }
}

private extension CarouselView {
    func build() {
        buildViews()
        configureView()
    }

    func buildViews() {
        addSubview(scrollView)
        scrollView.constrainEdges(.vertical)
        scrollView.constrain(.leadingAnchor, to: leadingAnchor, constant: horizontalPadding)
        scrollView.constrain(.trailingAnchor, to: trailingAnchor, constant: -horizontalPadding)

        scrollView.addSubview(contentView)
        contentView.constrainEdges(to: scrollView.contentLayoutGuide)
        contentView.constrain(.heightAnchor, to: scrollView.heightAnchor)
        contentView.constrain(.widthAnchor, to: scrollView.widthAnchor, multiplier: CGFloat(numberOfPages))

        addSubview(pageControl)
        pageControl.constrain(.centerXAnchor, to: centerXAnchor)
        pageControl.constrain(.bottomAnchor, to: bottomAnchor, constant: -pageControlBottomSpacing)
    }

    func configureView() {
        backgroundColor = .clear
        clipsToBounds = true
        configureScrollView()
    }

    func configureScrollView() {
        scrollView.delegate = self
        scrollView.backgroundColor = .clear
        scrollView.isPagingEnabled = true
        scrollView.clipsToBounds = false
        scrollView.showsHorizontalScrollIndicator = false
    }

    func buildPageIfValid() {
        guard numberOfPages > 0 else { return }

        build()
        currentPage = .zero
        pageControl.numberOfPages = numberOfPages
    }

    func loadPages(at index: Int) {
        loadPage(at: index - 1)
        loadPage(at: index)
        loadPage(at: index + 1)
    }

    func unloadPages() {
        for index in 0..<numberOfPages {
            unloadPage(at: index)
        }
    }

    func constrain(page: UIView, at index: Int) {
        page.constrain(.leadingAnchor, to: contentView.leadingAnchor, constant: CGFloat(index) * pageWidth)
        page.constrainEdges(.vertical)
        page.constrain(.widthAnchor, to: scrollView.widthAnchor)
    }

    func gotoPage(at index: Int) {
        // First load the pages at our destination
        loadPages(at: index)
        // then scroll
        let point = CGPoint(x: scrollView.bounds.width * CGFloat(index), y: 0)
        scrollView.setContentOffset(point, animated: true)
    }

    @objc
    func pageControlValueChanged(_ sender: UIPageControl) {
        gotoPage(at: sender.currentPage)
    }

    func updateScrollView(using pageNumber: Int) {
        scrollView.contentOffset = CGPoint(x: CGFloat(pageNumber) * pageWidth, y: .zero)
    }

    func clampToPageSize(pageNumber: Int) -> Int {
        min(max(pageNumber, 0), pageControl.numberOfPages - 1)
    }

    func updateCurrentPage(from scrollView: UIScrollView) {
        let pageNumber = Int(scrollView.contentOffset.x / pageWidth)
        currentPage = clampToPageSize(pageNumber: pageNumber)
    }
}

extension CarouselView: UIScrollViewDelegate {
    /// :nodoc:
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !pageWidth.isNaN else { return }

        // Load next/previous page, when more than 50% of the previous/next page is visible.
        let pageNumber = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)

        guard pageNumber != currentPage else { return }
        loadPages(at: clampToPageSize(pageNumber: pageNumber))
    }

    /// :nodoc:
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateCurrentPage(from: scrollView)
    }

    /// :nodoc:
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return }

        updateCurrentPage(from: scrollView)
    }
}
