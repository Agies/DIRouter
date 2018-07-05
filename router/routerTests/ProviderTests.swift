//
//  ProviderTests.swift
//  routerTests
//
//  Created by agies on 7/3/18.
//  Copyright © 2018 agies. All rights reserved.
//

import XCTest
import Router

class ProviderTests: MockTest {
    var sut: StoryboardControllerProvider!
    
    override func setUp() {
        super.setUp()
        self.sut = StoryboardControllerProvider(bundle: Bundle(for: ProviderTests.self))
    }
    
    func testGetController_will_draw_from_a_storyboard_by_default() {
        let controller = self.sut.get(byName: "Foo") as? UINavigationController
        XCTAssertNotNil(controller)
    }
    
    func testGetController_with_dot_will_draw_from_named_controller() {
        let controller = self.sut.get(byName: "Foo.Test") as? MockController
        XCTAssertNotNil(controller)
    }
    
    func testGetController_will_return_the_same_controller_if_still_in_memory() {
        let controller = self.sut.get(byName: "Foo")
        let controller2 = self.sut.get(byName: "Foo")
        XCTAssertEqual(controller, controller2)
    }
}
