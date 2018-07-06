//
//  Displayer.swift
//  router
//
//  Created by agies on 7/3/18.
//  Copyright © 2018 agies. All rights reserved.
//

import UIKit

public protocol Displayer: NSObjectProtocol {
    func show(_ names: [String], animate: Bool, completion: Action?)
}

public class StandardDisplayer<TNavController: NavigationController>: NSObject, Displayer {
    let nav: TNavController
    let controllerProvider: ControllerProvider
    public init(nav: TNavController, controllerProvider: ControllerProvider = StoryboardControllerProvider.shared) {
        self.nav = nav
        self.controllerProvider = controllerProvider
    }
    public func show(_ names: [String], animate: Bool, completion: Action?) {
        var controllers = names.map { (name) in
            return controllerProvider.get(byName: name)
        }
        if let root = nav.rootViewController, !controllers.contains(root) {
            controllers.insert(root, at: 0)
        }
        
        nav.show(controllers, animate: animate, completion: completion)
    }
    deinit {
        print("\(String(describing: self)) was deinitted")
    }
}

public class NavigationDisplayer: StandardDisplayer<UINavigationControllerAdapter> {
    public init(nav: UINavigationController, controllerProvider: ControllerProvider = StoryboardControllerProvider.shared) {
        super.init(nav: UINavigationControllerAdapter(wrapped: nav), controllerProvider: controllerProvider)
    }
}

public class ModalDisplayer: StandardDisplayer<UIViewControllerAdapter> {
    public init(nav: UIViewController, controllerProvider: ControllerProvider = StoryboardControllerProvider.shared) {
        super.init(nav: UIViewControllerAdapter(wrapped: nav), controllerProvider: controllerProvider)
    }
}
