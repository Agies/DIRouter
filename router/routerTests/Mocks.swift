//
//  MockProvider.swift
//  routerTests
//
//  Created by agies on 7/3/18.
//  Copyright © 2018 agies. All rights reserved.
//

import XCTest
import Router

class MockProvider: ControllerProvider, HasMocker, PropertyStoring, New {
    required init() {}
    func get<TController: UIViewController>(byName name: String) -> TController {
        mocker.addCall("get", data: ["name": name])
        return mocker.getExpectation("get")!
    }
}

class MockDisplayer: Displayer, HasMocker, PropertyStoring, New {
    func back(_ name: String, animate: Bool, completion: @escaping (Bool) -> Void) {
        
    }
    
    required init() {}
    func show(_ names: [String], animate: Bool, completion: Action?) {
        mocker.addCall("show", data: ["names": names, "animate": animate, "completion": completion as Any])
        completion?()
    }
}

class MockNavigationController: NavigationController, HasMocker, PropertyStoring, New {
    func back(_ controller: UIViewController, animate: Bool, completion: Action?) {
        
    }
    
    required init() {}
    func show(_ controllers: [UIViewController], animate: Bool, completion: Action?) {
        mocker.addCall("show", data: ["controllers": controllers, "animate": animate, "completion": completion as Any])
        completion?()
    }
}

protocol HasMocker {
    var mocker: Mocker { get }
}

protocol New {
    init()
}

struct MockeryKeys {
    static var mocker: UInt8 = 0
}

extension HasMocker where Self: PropertyStoring {
    var mocker: Mocker {
        get {
            return self.getAssociatedObject(&MockeryKeys.mocker, defaultValue: Mocker())
        }
    }
    func getCall(_ name: String, index: Int = 0) -> [String: Any]? {
        return mocker.getCall(name, index: index)
    }
}

class Mocker {
    var called = [String:[[String: Any]]]()
    var expectation = [String:[Any]]()
    func addCall(_ name: String, data: [String: Any]) {
        if called[name] == nil {
            called[name] = [[String:Any]]()
        }
        called[name]?.append(data)
    }
    func getCall(_ name: String, index: Int = 0) -> [String: Any]? {
        if ((called[name]?.count ?? 0) - 1) < index {
            return nil
        }
        return called[name]?[index]
    }
    func setExpectation(_ name: String, value: Any) {
        if expectation[name] == nil {
            expectation[name] = [Any]()
        }
        expectation[name]?.append(value)
    }
    func getExpectation<T>(_ name: String) -> T? {
        if var exp = expectation[name], exp.count > 0 {
            return exp.removeFirst() as? T
        }
        return nil
    }
}

class MockTest: XCTestCase {
    var mocks: [String: HasMocker]!
    
    override func setUp() {
        super.setUp()
        mocks = [String: HasMocker]()
    }
    
    func getMock<T: HasMocker & New>(_ type: T.Type) -> T {
        let key = String(describing: type);
        if let mock = mocks[key] {
            return mock as! T
        }
        let mock = T.init()
        mocks[key] = mock
        return mock
    }
}
