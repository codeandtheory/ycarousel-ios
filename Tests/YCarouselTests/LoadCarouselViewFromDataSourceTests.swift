//
//  LoadCarouselViewFromDataSourceTests.swift
//  YCarousel
//
//  Created by Karthik K Manoj on 07/31/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YCarousel

final class LoadCarouselViewFromDataSourceTests: XCTestCase {
    func test_init_doesNotLoadSubviewsOnEmptyView() {
        XCTAssertTrue(makeSUT().subviews.isEmpty)
    }

    func test_init_deliversSinglePageOnSingleView() {
        let view1 = UIView()
        let sut = makeSUT()
        let dataSource = makeCarouselViewDataSource(with: [view1])
        sut.dataSource = dataSource
        sut.layoutIfNeeded()

        XCTAssertEqual(sut.pages.count, 1)
        XCTAssertTrue(sut.pages.contains(view1))
    }

    func test_init_deliverTwoPagesOnTwoViews() {
        let view1 = UIView()
        let view2 = UIView()
        let sut = makeSUT()
        let dataSource = makeCarouselViewDataSource(with: [view1, view2])
        sut.dataSource = dataSource
        sut.layoutIfNeeded()

        XCTAssertEqual(sut.pages.count, 2)
        XCTAssertTrue(sut.pages.contains(view1))
        XCTAssertTrue(sut.pages.contains(view2))
    }

    func test_init_numberOfPagesOnSingleView() {
        let sut = makeSUT()
        sut.dataSource = makeCarouselViewDataSource(with: [UIView()])

        XCTAssertEqual(sut.numberOfPagesInPageIndicator, 1)
    }

    func test_init_numberOfPagesOnTwoViews() {
        let sut = makeSUT()
        sut.dataSource = makeCarouselViewDataSource(with: [UIView(), UIView()])

        XCTAssertEqual(sut.numberOfPagesInPageIndicator, 2)
    }

    func test_init_currentPageNumber() {
        let sut = makeSUT()
        sut.dataSource = makeCarouselViewDataSource(with: [UIView(), UIView()])

        XCTAssertEqual(sut.currentPageNumber, .zero)
    }

    func test_scrollView_properties() {
        let sut = makeSUT()
        sut.dataSource = makeCarouselViewDataSource(with: [UIView()])
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

        let sut = makeSUT(frame: frame)
        sut.dataSource = makeCarouselViewDataSource(with: [UIView()])
        sut.layoutIfNeeded()
        XCTAssertEqual(sut.contentSize, CGSize(width: 400, height: 400))
    }

    func test_contentSize_isCarouselSizeWidthForSingleViewWithHorizontalPadding() {
        let size = CGSize(width: 400, height: 400)
        let frame = CGRect(origin: .zero, size: size)

        let sut = makeSUT(frame: frame, horizontalPadding: 16.0)
        sut.dataSource = makeCarouselViewDataSource(with: [UIView()])
        sut.layoutIfNeeded()
        XCTAssertEqual(sut.contentSize, CGSize(width: 368, height: 400))
    }

    func test_contentSizeWidth_isTwiceCarouselSizeWidthForTwoViews() {
        let size = CGSize(width: 400, height: 400)
        let frame = CGRect(origin: .zero, size: size)

        let sut = makeSUT(frame: frame)
        sut.dataSource = makeCarouselViewDataSource(with: [UIView(), UIView()])
        sut.layoutIfNeeded()
        XCTAssertEqual(sut.contentSize, CGSize(width: 800, height: 400))
    }

    func test_contentSizeWidth_isTwiceCarouselSizeWidthForTwoViewsWithHorizontalPadding() {
        let size = CGSize(width: 400, height: 400)
        let frame = CGRect(origin: .zero, size: size)

        let sut = makeSUT(frame: frame, horizontalPadding: 16.0)
        sut.dataSource = makeCarouselViewDataSource(with: [UIView(), UIView()])
        sut.layoutIfNeeded()
        XCTAssertEqual(sut.contentSize, CGSize(width: 736, height: 400))
    }

    func test_scrollView_performsPagingOnScrollViewDidEndDecelerating() {
        let view1 = UIView()
        let view2 = UIView()
        let view3 = UIView()

        let size = CGSize(width: 400, height: 400)
        let frame = CGRect(origin: .zero, size: size)
        let sut = makeSUT(frame: frame)
        let viewProvider = CarouselViewProvider(views: [view1, view2, view3])
        sut.dataSource = viewProvider
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
        let sut = makeSUT(frame: frame)
        let viewProvider = CarouselViewProvider(views: [view1, view2, view3])
        sut.dataSource = viewProvider
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
        let sut = makeSUT(frame: frame)
        sut.dataSource = makeCarouselViewDataSource(with: [view1, view2, view3])
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

private extension LoadCarouselViewFromDataSourceTests {
    func makeSUT(
        frame: CGRect = .zero,
        horizontalPadding: CGFloat = 0,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> CarouselView {
        let sut = CarouselView(frame: frame, horizontalPadding: horizontalPadding)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    func makeCarouselViewDataSource(
        with views: [UIView],
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> CarouselViewDataSource {
        let viewProvider = CarouselViewProvider(views: views)
        trackForMemoryLeaks(viewProvider)
        return viewProvider
    }
}

private final class CarouselViewProvider {
    private let views: [UIView]

    internal init(views: [UIView]) {
        self.views = views
    }
}

extension CarouselViewProvider: CarouselViewDataSource {
    func carouselView(pageAt index: Int) -> UIView { views[index] }

    var numberOfPages: Int { views.count }
}
