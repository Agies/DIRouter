//
//  Displayer.swift
//  router
//
//  Created by agies on 7/3/18.
//  Copyright © 2018 agies. All rights reserved.
//

import UIKit

public protocol Displayer {
    func show(_ names: [String], animate: Bool, completion: Action?)
}

public class StandardDisplayer<TNavController: NavigationController>: NSObject, Displayer {
    let nav: TNavController
    let controllerProvider: ControllerProvider
    public init(nav: TNavController, controllerProvider: ControllerProvider = StoryboardControllerProvider()) {
        self.nav = nav
        self.controllerProvider = controllerProvider
    }
    public func show(_ names: [String], animate: Bool, completion: Action?) {
        let controllers = names.map { (name) in
            return controllerProvider.get(byName: name)
        }
        nav.show(controllers, animate: animate, completion: completion)
    }
}
