//
//  RoutableNavigationController.swift
//  Router
//
//  Created by agies on 7/5/18.
//  Copyright © 2018 agies. All rights reserved.
//

open class RoutableNavigationController: UINavigationController {
    open func getRouter() -> NavigationRouter {
        fatalError("You must override getRouter")
    }
    
    @objc func back() {
        getRouter().back()
    }
    
    open func createBackButton() -> UIBarButtonItem {
        return UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
    }
    
    override open func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        if getRouter().canBack {
            viewControllers.last?.navigationItem.leftBarButtonItem = createBackButton()
        } else {
            viewControllers.last?.navigationItem.leftBarButtonItem = nil
        }
        super.setViewControllers(viewControllers, animated: animated)
    }
}
