//
//  CarouselViewControllerTests.swift
//  YCarousel
//
//  Created by Visakh Tharakan on 01/08/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YCarousel

final class CarouselViewControllerTests: XCTestCase {
    func test_initWithCoder() throws {
        let coder = try makeCoder(for: UIView())
        XCTAssertNil(CarouselViewController(coder: coder))
    }

    func test_init_doesNotAddViewsToCarouselView() {
        let sut = makeSUT(withViews: [])
        XCTAssertTrue(sut.carouselView.pages.isEmpty)
    }

    func test_init_doesNotAddViewsFromViewControllersToCarouselView() {
        let sut = makeSUT(withViewControllers: [])
        XCTAssertTrue(sut.carouselView.pages.isEmpty)
    }

    func test_init_views_deliversSingleViewOnSingleView() {
        let sut = makeSUT(withViews: [UIView()])
        XCTAssertEqual(sut.carouselView.pages.count, 1)
    }

    func test_init_deliversSingleViewOnSingleviewController() {
        let sut = makeSUT(withViewControllers: [UIViewController()])
        XCTAssertEqual(sut.carouselView.pages.count, 1)
    }

    func test_init_noOfPagesIsTwoOnTwoViews() {
        let sut = makeSUT(withViews: [UIView(), UIView()])
        XCTAssertEqual(sut.carouselView.pages.count, 2)
    }

    func test_init_noOfPagesIsTwoOnTwoViewControllers() {
        let sut = makeSUT(withViewControllers: [UIViewController(), UIViewController()])
        XCTAssertEqual(sut.carouselView.pages.count, 2)
    }

    func test_init_noOfPagesIsTwoOnThreeViews() {
        let sut = makeSUT(withViews: [UIView(), UIView(), UIView()])
        XCTAssertEqual(sut.carouselView.pages.count, 2)
    }

    func test_init_noOfPagesIsTwoOnThreeViewControllers() {
        let sut = makeSUT(
            withViewControllers: [
                UIViewController(),
                UIViewController(),
                UIViewController()
            ]
        )
        XCTAssertEqual(sut.carouselView.pages.count, 2)
    }

    func test_delegate_load_unload() {
        let sut = MockCarouselViewController(viewControllers: [UIViewController()])
        sut.carouselView.layoutIfNeeded()
        sut.carouselView.removePages()

        sut.clear()
        sut.carouselView.loadPage(at: 0)

        XCTAssertTrue(sut.pageWillLoad)
        XCTAssertTrue(sut.pageDidLoad)
        XCTAssertFalse(sut.pageWillUnload)
        XCTAssertFalse(sut.pageWillUnload)

        sut.clear()
        sut.carouselView.unloadPage(at: 0)

        XCTAssertFalse(sut.pageWillLoad)
        XCTAssertFalse(sut.pageDidLoad)
        XCTAssertTrue(sut.pageWillUnload)
        XCTAssertTrue(sut.pageWillUnload)
    }

    func test_pressKeyboardLeft_deliversPreviousPage() {
        // Given
        let sut = makeSUT(withViews: [UIView(), UIView()])
        sut.carouselView.loadPage(at: 1)
        // When
        sut.leftArrowKeyPressed()
        // Then
        XCTAssertEqual(sut.carouselView.currentPage, 0)
    }

    func test_pressKeyboardLeftOnFirstPage_deliversNothing() {
        // Given
        let sut = makeSUT(withViews: [UIView(), UIView()])
        XCTAssertEqual(sut.carouselView.currentPage, 0)
        // When
        sut.leftArrowKeyPressed()
        // Then
        XCTAssertEqual(sut.carouselView.currentPage, 0)
    }

    func test_pressKeyboardRight_deliversNextPage() {
        // Given
        let sut = makeSUT(withViews: [UIView(), UIView()])
        XCTAssertEqual(sut.carouselView.currentPage, 0)
        // When
        sut.rightArrowKeyPressed()
        // Then
        XCTAssertEqual(sut.carouselView.currentPage, 1)
    }

    func test_pressKeyboardRightFromLastPage_deliversNothing() {
        // Given
        let sut = makeSUT(withViews: [UIView(), UIView()])
        sut.carouselView.loadView(at: 1)
        // When
        sut.rightArrowKeyPressed()
        // Then
        XCTAssertEqual(sut.carouselView.currentPage, 1)
    }

    func test_pressKeyboardLeftWhenDisabled_DeliversNothing() {
        // Given
        let sut = makeSUT(withViews: [UIView(), UIView()])
        sut.carouselView.loadView(at: 1)
        sut.isKeyboardNavigationEnabled = false
        // When
        sut.leftArrowKeyPressed()
        // Then
        XCTAssertEqual(sut.carouselView.currentPage, 1)
    }

    func test_pressKeyboardRightWhenDisabled_DeliversNothing() {
        // Given
        let sut = makeSUT(withViews: [UIView(), UIView()])
        sut.isKeyboardNavigationEnabled = false
        // When
        sut.rightArrowKeyPressed()
        // Then
        XCTAssertEqual(sut.carouselView.currentPage, 0)
    }
}

private extension CarouselViewControllerTests {
    func makeSUT(
        withViews views: [UIView],
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> CarouselViewController {
        let sut = CarouselViewController(views: views)
        XCTAssertNil(sut.viewIfLoaded)
        sut.carouselView.layoutIfNeeded()
        trackForMemoryLeaks(sut)
        return sut
    }

    func makeSUT(
        withViewControllers viewControllers: [UIViewController],
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> CarouselViewController {
        let sut = CarouselViewController(viewControllers: viewControllers)
        XCTAssertNil(sut.viewIfLoaded)
        sut.carouselView.layoutIfNeeded()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    func makeCoder(for view: UIView) throws -> NSCoder {
        let data = try NSKeyedArchiver.archivedData(withRootObject: view, requiringSecureCoding: false)
        return try NSKeyedUnarchiver(forReadingFrom: data)
    }
}

private extension CarouselView {
    func removePages() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
    }
}

private final class MockCarouselViewController: CarouselViewController {
    var pageWillLoad = false
    var pageDidLoad = false
    var pageWillUnload = false
    var pageDidUnload = false

    func clear() {
        pageWillLoad = false
        pageDidLoad = false
        pageWillUnload = false
        pageDidUnload = false
    }

    // MARK: - CarouselViewDelegate

    override func carouselView(_ carouselView: CarouselView, pageWillLoad page: UIView, at index: Int) {
        super.carouselView(carouselView, pageWillLoad: page, at: index)
        pageWillLoad = true
    }

    override func carouselView(_ carouselView: CarouselView, pageDidLoad page: UIView, at index: Int) {
        super.carouselView(carouselView, pageDidLoad: page, at: index)
        pageDidLoad = true
    }

    override func carouselView(_ carouselView: CarouselView, pageWillUnload page: UIView, at index: Int) {
        super.carouselView(carouselView, pageWillUnload: page, at: index)
        pageWillUnload = true
    }

    override func carouselView(_ carouselView: CarouselView, pageDidUnload page: UIView, at index: Int) {
        super.carouselView(carouselView, pageDidUnload: page, at: index)
        pageDidUnload = true
    }
}
