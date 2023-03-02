//
//  CarouselPageTests.swift
//  YCarousel
//
//  Created by Mark Pospesel on 8/19/22.
//

import XCTest
@testable import YCarousel

class CarouselPageTests: XCTestCase {
    func test_uiview_conformance() {
        // Any UIView should return itself in response to `CarouselPage.view`
        [UIView(), UIStackView(), UITextView()].forEach {
            XCTAssertEqual($0, $0.view)
        }
    }
}
