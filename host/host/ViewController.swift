//
//  ViewController.swift
//  host
//
//  Created by agies on 7/3/18.
//  Copyright © 2018 agies. All rights reserved.
//

import UIKit
import Router

class PrimaryNavController: UIViewController {
    @IBOutlet weak var secondPage: UIButton!
    @IBOutlet weak var subNav: UIButton!
    @IBOutlet weak var storyTab: UIButton!
    @IBOutlet weak var modalButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondPage.addTarget(self, action: #selector(goToSecondPage), for: .touchUpInside)
        subNav.addTarget(self, action: #selector(goToSubnav), for: .touchUpInside)
        modalButton.addTarget(self, action: #selector(goToModal), for: .touchUpInside)
    }

    @objc func goToSecondPage() {
        getDelegate().router.navigateTo(path: [Path("root", "Main.Page1"), Path("root", "Main.Page2")])
    }
    
    @objc func goToSubnav() {
        getDelegate().router.navigateTo(path: [Path("root", "Main.Page1"), Path("root", "Main.Subnavigation", false), Path("subnav", "Main.SubRoot"), Path("subnav", "Main.Page2")])
    }
    
    @objc func goToModal() {
        getDelegate().router.navigateTo(path: [Path("root", "Main.Page1"), Path("modal", "Main.Subnavigation", false), Path("subnav", "Main.SubRoot"), Path("subnav", "Main.Page2")])
    }
}

class RoutingNavController: UINavigationController {
    @objc func back() {
        getDelegate().router.back()
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        if getDelegate().router.canBack {
            let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
            viewControllers.last?.navigationItem.leftBarButtonItem = backButton
        } else {
            viewControllers.last?.navigationItem.leftBarButtonItem = nil
        }
        super.setViewControllers(viewControllers, animated: animated)
    }
}

class SubRoutingController: RoutingNavController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDelegate().router.addDisplayer(StandardDisplayer(nav: UINavigationControllerAdapter(wrapped: self)), named: "subnav")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDelegate().router.removeDisplayer(named: "subnav")
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
    }
}

class SubPageOneController: UIViewController {
    @IBOutlet weak var pageTwoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageTwoButton.addTarget(self, action: #selector(pageTwo), for: .touchUpInside)
    }
    
    @objc func pageTwo() {
        var path = getDelegate().router.currentPath
        path.append(Path("subnav", "Main.Page2"))
        getDelegate().router.navigateTo(path: path)
    }
}
