//
//  CarouselViewController+StringsTests.swift
//  YCarousel
//
//  Created by Sahil Saini on 07/04/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YCarousel

final class CarouselViewControllerStringsTests: XCTestCase {
    func testLoadStrings() {
        CarouselViewController.Strings.allCases.forEach {
            // Given a localized string constant
            let string = $0.localized
            // should not be empty
            XCTAssertFalse(string.isEmpty)
            // should not equal its key
            XCTAssertNotEqual($0.rawValue, string)
        }
    }
}
