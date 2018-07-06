//
//  routerTests.swift
//  routerTests
//
//  Created by agies on 7/3/18.
//  Copyright © 2018 agies. All rights reserved.
//

import XCTest
@testable import Router

class RouterTests: XCTestCase {
    
    var sut: NavigationRouter!
    
    override func setUp() {
        super.setUp()
        self.sut = NavigationRouter()
    }
    
    func testNavigation_will_store_the_previous_routes() {
        
    }
    
    func testAddDisplayer_will_add_the_displayer_to_the_router_by_name() {
        let displayer = StandardDisplayer(nav: UINavigationControllerAdapter(wrapped: UINavigationController()), controllerProvider: MockProvider())
        sut.addDisplayer(displayer, named: "nav")
        XCTAssertEqual(displayer, sut.displayers["nav"] as? StandardDisplayer)
    }
    
    func testNavigateTo_will_call_display_on_the_specified_nav() {
        let mock = MockDisplayer();
        sut.addDisplayer(mock, named: "nav")
        sut.navigateTo(path: [Path("nav", "foo")])
        XCTAssertEqual("foo", (mock.getCall("show")?["names"] as? [String])?.first)
    }
    
    func testNavigateTo_will_call_display_on_the_specified_nav_with_multi() {
        let mock = MockDisplayer();
        sut.addDisplayer(mock, named: "nav")
        sut.navigateTo(path: [Path("nav", "foo"), Path("nav", "bar")])
        XCTAssertEqual(["foo", "bar"], mock.getCall("show")?["names"] as? [String])
        
        XCTAssertEqual(true, mock.getCall("show")?["animate"] as? Bool)
    }
    
    func testNavigateTo_will_call_display_on_multi_nav_with_multi_path() {
        let mock = MockDisplayer();
        let mock2 = MockDisplayer();
        sut.addDisplayer(mock, named: "nav")
        sut.addDisplayer(mock2, named: "other")
        sut.navigateTo(path: [Path("nav", "foo"), Path("nav", "bar"), Path("other", "zed")])
        XCTAssertEqual(["foo", "bar"], mock.getCall("show")?["names"] as? [String])
        XCTAssertEqual(["zed"], mock2.getCall("show")?["names"] as? [String])
        
        XCTAssertEqual(false, mock.getCall("show")?["animate"] as? Bool)
        XCTAssertEqual(true, mock2.getCall("show")?["animate"] as? Bool)
    }
    
    func testNavigateTo_will_call_display_on_all_displayers_evem_if_not_on_path() {
        let mock = MockDisplayer();
        let mock2 = MockDisplayer();
        sut.addDisplayer(mock, named: "nav")
        sut.addDisplayer(mock2, named: "other")
        sut.navigateTo(path: [Path("nav", "foo"), Path("nav", "bar")])
        XCTAssertEqual(["foo", "bar"], mock.getCall("show")?["names"] as? [String])
        XCTAssertEqual([], mock2.getCall("show")?["names"] as? [String])
        
        XCTAssertEqual(true, mock.getCall("show")?["animate"] as? Bool)
        XCTAssertEqual(true, mock2.getCall("show")?["animate"] as? Bool)
    }
    
    func testBack_will_go_back_one_path() {
        let mock = MockDisplayer();
        let mock2 = MockDisplayer();
        sut.addDisplayer(mock, named: "nav")
        sut.addDisplayer(mock2, named: "other")
        sut.navigateTo(path: [Path("nav", "foo"), Path("nav", "bar"), Path("other", "zed")])
        sut.back()
        XCTAssertEqual(["foo", "bar"], mock.getCall("show", index: 1)?["names"] as? [String])
        XCTAssertEqual([], mock2.getCall("show", index: 1)?["names"] as? [String])
        
        XCTAssertEqual(true, mock.getCall("show", index: 1)?["animate"] as? Bool)
        XCTAssertEqual(true, mock2.getCall("show", index: 1)?["animate"] as? Bool)
    }
    
    func testBackToRoot_will_rollback_to_the_first_element_in_the_nav() {
        let mock = MockDisplayer();
        let mock2 = MockDisplayer();
        sut.addDisplayer(mock, named: "nav")
        sut.addDisplayer(mock2, named: "other")
        sut.navigateTo(path: [Path("nav", "foo"), Path("nav", "bar"), Path("other", "zed")])
        sut.backToRoot(ofDisplayer: "nav")
        XCTAssertEqual(["foo"], mock.getCall("show", index: 1)?["names"] as? [String])
        XCTAssertEqual([], mock2.getCall("show", index: 1)?["names"] as? [String])
        
        XCTAssertEqual(true, mock.getCall("show", index: 1)?["animate"] as? Bool)
        XCTAssertEqual(true, mock2.getCall("show", index: 1)?["animate"] as? Bool)
    }
    
    func testNavigateTo_will_store_a_path_if_a_Displayer_is_missing() {
        let mock = MockDisplayer();
        let mock2 = MockDisplayer();
        sut.addDisplayer(mock, named: "nav")
        
        sut.navigateTo(path: [Path("nav", "foo"), Path("nav", "bar"), Path("other", "zed")])
        XCTAssertEqual(["foo", "bar"], mock.getCall("show")?["names"] as? [String])
        XCTAssertNil(mock2.getCall("show")?["names"] as? [String])
        XCTAssertEqual(false, mock.getCall("show")?["animate"] as? Bool)
        
        sut.addDisplayer(mock2, named: "other")
        XCTAssertEqual(["zed"], mock2.getCall("show")?["names"] as? [String])
        XCTAssertEqual(true, mock2.getCall("show")?["animate"] as? Bool)
    }
}
