//
//  DisplayerTests.swift
//  routerTests
//
//  Created by agies on 7/3/18.
//  Copyright © 2018 agies. All rights reserved.
//

import XCTest
import Router

class DisplayerTests: MockTest {
    var sut: StandardDisplayer<MockNavigationController>!
    override func setUp() {
        super.setUp()
        self.sut = StandardDisplayer(nav: getMock(MockNavigationController.self), controllerProvider: getMock(MockProvider.self))
    }
    
    func testShow_calls_provider_get() {
        let action = {}
        getMock(MockProvider.self).mocker.setExpectation("get", value: UIViewController())
        sut.show(["foo"], animate: true, completion: action)
        XCTAssertEqual("foo", getMock(MockProvider.self).getCall("get")?["name"] as? String)
    }
    
    func testShow_calls_nav_show() {
        let action = {}
        let controller = UIViewController()
        getMock(MockProvider.self).mocker.setExpectation("get", value: controller)
        sut.show(["foo"], animate: true, completion: action)
        let data = getMock(MockNavigationController.self).getCall("show")
        XCTAssertEqual(controller, (data?["controllers"] as? [UIViewController])?.first)
        XCTAssertEqual(true, data?["animate"] as? Bool)
    }
}
