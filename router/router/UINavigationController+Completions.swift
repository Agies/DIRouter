//
//  UINavigationController+Completions.swift
//  router
//
//  Created by agies on 7/3/18.
//  Copyright © 2018 agies. All rights reserved.
//

extension UINavigationController {
    func pushViewController(_ viewController: UIViewController, animated: Bool, completion: Action?) {
        pushViewController(viewController, animated: animated)
        if let coord = transitionCoordinator {
            coord.animate(alongsideTransition: nil) {
                _ in
                completion?()
            }
            return
        }
        completion?()
    }
    
    func popViewController(animated: Bool, completion: Action?) {
        popViewController(animated: animated)
        if let coord = transitionCoordinator {
            coord.animate(alongsideTransition: nil) {
                _ in
                completion?()
            }
            return
        }
        completion?()
    }
    
    func popToRootViewController(animated: Bool, completion: Action?) {
        popToRootViewController(animated: animated)
        if let coord = transitionCoordinator {
            coord.animate(alongsideTransition: nil) {
                _ in
                completion?()
            }
            return
        }
        completion?()
    }
    
    func popToViewController(_ viewController: UIViewController, animated: Bool, completion: Action?) {
        popToViewController(viewController, animated: animated)
        if let coord = transitionCoordinator {
            coord.animate(alongsideTransition: nil) {
                _ in
                completion?()
            }
            return
        }
        completion?()
    }
    
    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool, completion: Action?) {
        setViewControllers(viewControllers, animated: animated)
        if let coord = transitionCoordinator {
            coord.animate(alongsideTransition: nil) {
                _ in
                completion?()
            }
            return
        }
        completion?()
    }
}
