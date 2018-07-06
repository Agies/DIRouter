//
//  UIViewController+NavigationController.swift
//  router
//
//  Created by agies on 7/3/18.
//  Copyright © 2018 agies. All rights reserved.
//

@objc public protocol NavigationController {
    func show(_ controllers: [UIViewController], animate: Bool, completion: Action?)
    var rootViewController: UIViewController? { get }
}

public class UIViewControllerAdapter: NavigationController {
    public var rootViewController: UIViewController? {
        get { return nil }
    }
    
    weak var wrapped: UIViewController?
    public init(wrapped: UIViewController) {
        self.wrapped = wrapped
    }
    public func show(_ controllers: [UIViewController], animate: Bool, completion: Action?) {
        if let controller = controllers.last {
            if wrapped?.presentedViewController != controller {
                if wrapped?.presentedViewController != nil {
                    wrapped?.dismiss(animated: false)
                    wrapped?.present(controller, animated: animate, completion: completion)
                } else {
                    wrapped?.present(controller, animated: animate, completion: completion)
                }
            } else {
                completion?()
                return
            }
        } else {
            wrapped?.dismiss(animated: animate, completion: completion)
        }
        if !animate {
            completion?()
        }
    }
    
    deinit {
        print("\(String(describing: self)) was deinitted")
    }
}

public class UITabBarControllerAdapter: NavigationController {
    public var rootViewController: UIViewController? {
        get { return wrapped?.viewControllers?.first }
    }
    
    weak var wrapped: UITabBarController?
    public init(wrapped: UITabBarController) {
        self.wrapped = wrapped
    }
    public func show(_ controllers: [UIViewController], animate: Bool, completion: Action?) {
        wrapped?.selectedViewController = controllers.last
        completion?()
    }
    
    deinit {
        print("\(String(describing: self)) was deinitted")
    }
}

public class UINavigationControllerAdapter: NavigationController {
    weak var wrapped: UINavigationController?
    public init(wrapped: UINavigationController) {
        self.wrapped = wrapped
    }
    public func show(_ controllers: [UIViewController], animate: Bool, completion: Action?) {
        if controllers.count == 0 {
            wrapped?.popToRootViewController(animated: animate, completion: completion)
            return
        }
        wrapped?.setViewControllers(controllers, animated: animate, completion: completion)
    }
    public var rootViewController: UIViewController? {
        get { return wrapped?.viewControllers.first }
    }
    
    deinit {
        print("\(String(describing: self)) was deinitted")
    }
}
