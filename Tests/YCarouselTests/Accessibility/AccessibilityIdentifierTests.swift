//
//  AccessibilityIdentifierTests.swift
//  YCarousel
//
//  Created by Mark Pospesel on 3/2/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YCarousel

final class AccessibilityIdentifierTests: XCTestCase {
    func test_identifiers_haveCorrectPrefix() {
        let sut = makeSUT()
        sut.forEach {
            XCTAssertFalse($0.contains(where: { $0 == " " }))
            XCTAssertTrue($0.hasPrefix("carousel."))
        }
    }
}

private extension AccessibilityIdentifierTests {
    func makeSUT() -> [String] {
        [
            AccessibilityIdentifier.scrollView,
            AccessibilityIdentifier.pageControl,
            AccessibilityIdentifier.previousButton,
            AccessibilityIdentifier.nextButton
        ]
    }
}
