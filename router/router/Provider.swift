//
//  Provider.swift
//  router
//
//  Created by agies on 7/3/18.
//  Copyright © 2018 agies. All rights reserved.
//

import UIKit

public protocol ControllerProvider {
    func get<TController: UIViewController>(byName name: String) -> TController
}

public class StoryboardControllerProvider: ControllerProvider {
    static public var shared = StoryboardControllerProvider()
    var controllers = [String: WeakWrapper]()
    let bundle: Bundle
    public init(bundle: Bundle = Bundle.main) {
       self.bundle = bundle
    }
    public func get<TController: UIViewController>(byName name: String) -> TController {
        let finder = name.components(separatedBy: ".")
        if bundle.path(forResource: finder[0], ofType: "storyboardc") == nil {
            fatalError("Cannot find Storyboard \(finder[0])")
        }
        let strategy = finder.count > 1 ? ViewControllerFactoryStrategy.withIdentifier(finder[1]) : ViewControllerFactoryStrategy.initialViewController
        return get(from: UIStoryboard(name: finder[0], bundle: bundle), strategy: strategy)
    }
    public func get<TController: UIViewController>(from storyboard: UIStoryboard, strategy: ViewControllerFactoryStrategy) -> TController {
        let name: String
        let instantiate: () -> UIViewController?
        switch strategy {
        case .initialViewController:
            name = storyboard.value(forKey: "name") as! String
            instantiate = { storyboard.instantiateInitialViewController() }
            break
        case .withIdentifier(let identifier):
            name = identifier
            instantiate = { storyboard.instantiateViewController(withIdentifier: identifier) }
            break
        }
        if let c = controllers[name] {
            return c.getObj(TController.self)
        } else {
            let wrapper = WeakWrapper(factory: {
                guard let controller = instantiate() else {
                    fatalError("Cannot find controller \(name)")
                }
                return controller
            })
            controllers[name] = wrapper
            return wrapper.getObj(TController.self)
        }
    }
}

public enum ViewControllerFactoryStrategy {
    case initialViewController
    case withIdentifier(String)
}

public class WeakWrapper {
    let factory: () throws -> AnyObject
    weak var _obj: AnyObject?
    func getObj<T: AnyObject>(_ class: AnyObject.Type) -> T {
        if _obj == nil {
            _obj = try! factory()
        }
        return _obj as! T
    }
    var exists: Bool {
        get { return _obj != nil }
    }
    init(factory: @escaping () throws -> AnyObject) {
        self.factory = factory
    }
}
