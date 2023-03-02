//
//  LoadCarouselViewFromViewListTests.swift
//  YCarousel
//
//  Created by Karthik K Manoj on 07/31/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YCarousel

final class LoadCarouselViewFromViewListTests: XCTestCase {
    func test_initWithCoder() throws {
        let sut = CarouselView(coder: try makeCoder(for: makeSUT(with: [])))
        XCTAssertNil(sut)
    }

    func test_initWithView_doesNotLoadSubviewsOnEmptyView() {
        XCTAssertTrue(makeSUT(with: []).subviews.isEmpty)
    }

    func test_initWithView_deliversSinglePageOnSingleView() {
        let view1 = UIView()
        let sut = makeSUT(with: [view1])
        sut.layoutIfNeeded()

        XCTAssertEqual(sut.pages.count, 1)
        XCTAssertTrue(sut.pages.contains(view1))
    }

    func test_initWithView_deliverTwoPagesOnTwoViews() {
        let view1 = UIView()
        let view2 = UIView()
        let sut = makeSUT(with: [view1, view2])
        sut.layoutIfNeeded()

        XCTAssertEqual(sut.pages.count, 2)
        XCTAssertTrue(sut.pages.contains(view1))
        XCTAssertTrue(sut.pages.contains(view2))
    }

    func test_initWithView_numberOfPagesOnSingleView() {
        XCTAssertEqual(makeSUT(with: [UIView()]).numberOfPagesInPageIndicator, 1)
    }

    func test_initWithView_numberOfPagesOnTwoViews() {
        let view1 = UIView()
        let view2 = UIView()
        let sut = makeSUT(with: [view1, view2])

        XCTAssertEqual(sut.numberOfPagesInPageIndicator, 2)
    }

    func test_initWithView_pageControlBackgroundStyleIsProminent() {
        XCTAssertEqual(makeSUT(with: [UIView()]).pageControl.backgroundStyle, .prominent)
    }

    func test_initWithView_currentPageNumber() {
        let view1 = UIView()
        let view2 = UIView()
        let sut = makeSUT(with: [view1, view2])

        XCTAssertEqual(sut.currentPageNumber, .zero)
    }

    func test_scrollView_properties() {
        let sut = makeSUT(with: [UIView()])
        let scrollView = sut.scrollingView

        XCTAssertTrue(scrollView.isPagingEnabled)
        XCTAssertFalse(scrollView.clipsToBounds)
        XCTAssertTrue(sut.clipsToBounds)
        XCTAssertFalse(scrollView.showsHorizontalScrollIndicator)
        XCTAssertNotNil(scrollView.delegate)
        XCTAssertEqual(scrollView.backgroundColor, .clear)
    }

    func test_contentSize_isCarouselSizeWidthForSingleView() {
        let size = CGSize(width: 400, height: 400)
        let frame = CGRect(origin: .zero, size: size)

        let sut = makeSUT(with: [UIView()], frame: frame)
        sut.layoutIfNeeded()
        XCTAssertEqual(sut.contentSize, CGSize(width: 400, height: 400))
    }

    func test_contentSize_isCarouselSizeWidthForSingleViewWithHorizontalPadding() {
        let size = CGSize(width: 400, height: 400)
        let frame = CGRect(origin: .zero, size: size)

        let sut = makeSUT(with: [UIView()], frame: frame, horizontalPadding: 16.0)
        sut.layoutIfNeeded()
        XCTAssertEqual(sut.contentSize, CGSize(width: 368, height: 400))
    }

    func test_contentSizeWidth_isTwiceCarouselSizeWidthForTwoViews() {
        let size = CGSize(width: 400, height: 400)
        let frame = CGRect(origin: .zero, size: size)

        let sut = makeSUT(with: [UIView(), UIView()], frame: frame)
        sut.layoutIfNeeded()
        XCTAssertEqual(sut.contentSize, CGSize(width: 800, height: 400))
    }

    func test_contentSizeWidth_isTwiceCarouselSizeWidthForTwoViewsWithHorizontalPadding() {
        let size = CGSize(width: 400, height: 400)
        let frame = CGRect(origin: .zero, size: size)

        let sut = makeSUT(with: [UIView(), UIView()], frame: frame, horizontalPadding: 16.0)
        sut.layoutIfNeeded()
        XCTAssertEqual(sut.contentSize, CGSize(width: 736, height: 400))
    }

    func test_hitTest_fromPageControlReturnsPageControl() {
        let size = CGSize(width: 400, height: 400)
        let frame = CGRect(origin: .zero, size: size)

        let sut = makeSUT(with: [UIView()], frame: frame, horizontalPadding: 16.0)
        sut.layoutIfNeeded()
        let point = sut.pageControl.center
        XCTAssertEqual(sut.hitTest(point, with: nil), sut.pageControl)
    }

    func test_hitTest_fromEdgeReturnsScrollview() {
        let size = CGSize(width: 400, height: 400)
        let frame = CGRect(origin: .zero, size: size)
        let padding: CGFloat = 16

        let sut = makeSUT(with: [UIView()], frame: frame, horizontalPadding: padding)
        sut.layoutIfNeeded()
        let leftPoint = CGPoint(x: padding / 2, y: sut.bounds.midY)
        let rightPoint = CGPoint(x: sut.bounds.maxX - (padding / 2), y: sut.bounds.midY)
        XCTAssertEqual(sut.hitTest(leftPoint, with: nil), sut.scrollView)
        XCTAssertEqual(sut.hitTest(rightPoint, with: nil), sut.scrollView)
    }

    func test_hitTest_fromOutsideReturnsNil() {
        let size = CGSize(width: 400, height: 400)
        let frame = CGRect(origin: .zero, size: size)
        let padding: CGFloat = 16

        let sut = makeSUT(with: [UIView()], frame: frame, horizontalPadding: padding)
        sut.layoutIfNeeded()
        let leftPoint = CGPoint(x: -(padding / 2), y: sut.bounds.midY)
        let rightPoint = CGPoint(x: sut.bounds.maxX + (padding / 2), y: sut.bounds.midY)
        XCTAssertNil(sut.hitTest(leftPoint, with: nil))
        XCTAssertNil(sut.hitTest(rightPoint, with: nil))
    }

    func test_scrollView_performsPagingOnScrollViewDidEndDecelerating() {
        let view1 = UIView()
        let view2 = UIView()
        let view3 = UIView()

        let size = CGSize(width: 400, height: 400)
        let frame = CGRect(origin: .zero, size: size)
        let sut = makeSUT(with: [view1, view2, view3], frame: frame)
        sut.layoutIfNeeded()
        let scrollView = sut.scrollingView

        XCTAssertEqual(view1.frame.origin, scrollView.contentOffset)
        XCTAssertEqual(sut.currentPageNumber, .zero)

        scrollView.contentOffset = CGPoint(x: 400, y: .zero)
        sut.scrollView.layoutIfNeeded()
        sut.scrollViewDidEndDecelerating(scrollView)
        
        XCTAssertEqual(view2.frame.origin, scrollView.contentOffset)
        XCTAssertEqual(sut.currentPageNumber, 1)

        scrollView.contentOffset = CGPoint(x: 800, y: .zero)
        sut.scrollViewDidEndDecelerating(scrollView)

        XCTAssertEqual(view3.frame.origin, scrollView.contentOffset)
        XCTAssertEqual(sut.currentPageNumber, 2)

        scrollView.contentOffset = CGPoint(x: 400, y: .zero)
        sut.scrollViewDidEndDecelerating(scrollView)

        XCTAssertEqual(view2.frame.origin, scrollView.contentOffset)
        XCTAssertEqual(sut.currentPageNumber, 1)

        scrollView.contentOffset = .zero
        sut.scrollViewDidEndDecelerating(scrollView)

        XCTAssertEqual(view1.frame.origin, scrollView.contentOffset)
        XCTAssertEqual(sut.currentPageNumber, .zero)
    }

    func test_scrollView_performsPagingOnScrollViewDidEndDragging() {
        let view1 = UIView()
        let view2 = UIView()
        let view3 = UIView()

        let size = CGSize(width: 400, height: 400)
        let frame = CGRect(origin: .zero, size: size)
        let sut = makeSUT(with: [view1, view2, view3], frame: frame)
        sut.layoutIfNeeded()
        let scrollView = sut.scrollingView

        XCTAssertEqual(view1.frame.origin, scrollView.contentOffset)
        XCTAssertEqual(sut.currentPageNumber, .zero)

        scrollView.contentOffset = CGPoint(x: 400, y: .zero)
        sut.scrollView.layoutIfNeeded()
        sut.scrollViewDidEndDragging(scrollView, willDecelerate: false)

        XCTAssertEqual(view2.frame.origin, scrollView.contentOffset)
        XCTAssertEqual(sut.currentPageNumber, 1)

        scrollView.contentOffset = CGPoint(x: 800, y: .zero)
        sut.scrollViewDidEndDragging(scrollView, willDecelerate: false)

        XCTAssertEqual(view3.frame.origin, scrollView.contentOffset)
        XCTAssertEqual(sut.currentPageNumber, 2)

        scrollView.contentOffset = CGPoint(x: 400, y: .zero)
        sut.scrollViewDidEndDragging(scrollView, willDecelerate: false)

        XCTAssertEqual(view2.frame.origin, scrollView.contentOffset)
        XCTAssertEqual(sut.currentPageNumber, 1)

        scrollView.contentOffset = .zero
        sut.scrollViewDidEndDragging(scrollView, willDecelerate: false)

        XCTAssertEqual(view1.frame.origin, scrollView.contentOffset)
        XCTAssertEqual(sut.currentPageNumber, .zero)
    }

    func test_pageControl_updatesScrollViewContentOffset() {
        let view1 = UIView()
        let view2 = UIView()
        let view3 = UIView()

        let size = CGSize(width: 400, height: 400)
        let frame = CGRect(origin: .zero, size: size)
        let sut = makeSUT(with: [view1, view2, view3], frame: frame)
        sut.layoutIfNeeded()

        let scrollView = sut.scrollingView
        let pageControl = sut.pageIndicator

        pageControl.currentPage = 0
        pageControl.simulate(event: .valueChanged)
        XCTAssertEqual(scrollView.contentOffset, .zero)

        pageControl.currentPage = 1
        pageControl.simulate(event: .valueChanged)
        XCTAssertEqual(scrollView.contentOffset, CGPoint(x: 400, y: .zero))

        pageControl.currentPage = 2
        pageControl.simulate(event: .valueChanged)
        XCTAssertEqual(scrollView.contentOffset, CGPoint(x: 800, y: .zero))
    }
}

private extension LoadCarouselViewFromViewListTests {
    func makeSUT(
        with views: [UIView],
        frame: CGRect = .zero,
        horizontalPadding: CGFloat = 0,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> CarouselView {
        let sut = CarouselView(frame: frame, views: views, horizontalPadding: horizontalPadding)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    func makeCoder(for view: UIView) throws -> NSCoder {
        let data = try NSKeyedArchiver.archivedData(withRootObject: view, requiringSecureCoding: false)
        return try NSKeyedUnarchiver(forReadingFrom: data)
    }
}

// Domain Specific Language (DSL) to decouple test from implementation details.
extension CarouselView {
    var pages: [UIView] { contentView.subviews }

    var numberOfPagesInPageIndicator: Int { pageControl.numberOfPages }

    var currentPageNumber: Int { pageControl.currentPage }

    var scrollingView: UIScrollView { scrollView }

    var pageIndicator: UIPageControl { pageControl }

    var contentSize: CGSize { scrollView.contentSize }
}
