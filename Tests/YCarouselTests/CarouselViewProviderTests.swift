//
//  CarouselViewProviderTests.swift
//  YCarousel
//
//  Created by Karthik K Manoj on 07/31/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YCarousel

final class CarouselViewProviderTests: XCTestCase {
    func test_init_deliversEmptyView() {
        XCTAssertTrue(makeSUT(with: []).views.isEmpty)
    }

    func test_init_deliversSingleView() {
        let view1 = UIView()
        XCTAssertEqual(makeSUT(with: [view1]).views, [view1])
    }

    func test_init_deliverTwoViews() {
        let view1 = UIView()
        let view2 = UIView()
        XCTAssertEqual(makeSUT(with: [view1, view2]).views, [view1, view2])
    }

    func test_numberOfPages_isZeroForEmptyView() {
        XCTAssertEqual(makeSUT(with: []).numberOfPages, .zero)
    }

    func test_numberOfPages_isOneForSingleView() {
        XCTAssertEqual(makeSUT(with: [UIView()]).numberOfPages, 1)
    }

    func test_numberOfPages_isTwoForTwoViews() {
        XCTAssertEqual(makeSUT(with: [UIView(), UIView()]).numberOfPages, 2)
    }

    func test_carouselViewPageAt_deliversFirstView() {
        let view1 = UIView()
        let view2 = UIView()
        let view3 = UIView()
        let sut = makeSUT(with: [view1, view2, view3])
        XCTAssertEqual(sut.carouselView(pageAt: 0), view1)
    }

    func test_carouselViewPageAt_deliversMiddleView() {
        let view1 = UIView()
        let view2 = UIView()
        let view3 = UIView()
        let sut = makeSUT(with: [view1, view2, view3])
        XCTAssertEqual(sut.carouselView(pageAt: 1), view2)
    }

    func test_carouselViewPageAt_deliversLastView() {
        let view1 = UIView()
        let view2 = UIView()
        let view3 = UIView()
        let sut = makeSUT(with: [view1, view2, view3])
        XCTAssertEqual(sut.carouselView(pageAt: 2), view3)
    }
}

private extension CarouselViewProviderTests {
    func makeSUT(
        with views: [UIView],
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> CarouselViewProvider {
        let sut = CarouselViewProvider(views: views)
        trackForMemoryLeaks(sut)
        return sut
    }
}
