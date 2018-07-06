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
        getDelegate().router.navigateTo(relative: [Path("root", "Main.Page2")])
    }
    
    @objc func goToSubnav() {
        getDelegate().router.navigateTo(relative: [Path("root", "Main.Subnavigation"), Path("subnav", "Main.Page2")])
    }
    
    @objc func goToModal() {
        getDelegate().router.navigateTo(relative: [Path("modal", "Main.Subnavigation", true), Path("subnav", "Main.Page2", false)])
    }
}

class RoutingNavController: RoutableNavigationController {
    lazy var displayer = { return ModalDisplayer(nav: self) }()
    override func getRouter() -> NavigationRouter {
        return getDelegate().router
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getDelegate().router.addDisplayer(displayer, named: "modal")
    }
}

class SubRoutingController: RoutableNavigationController {
    lazy var displayer = { return NavigationDisplayer(nav: self) }()
    override func getRouter() -> NavigationRouter {
        return getDelegate().router
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDelegate().router.addDisplayer(displayer, named: "subnav")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDelegate().router.removeDisplayer(named: "subnav")
    }
}

class SubPageOneController: UIViewController {
    @IBOutlet weak var pageTwoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageTwoButton.addTarget(self, action: #selector(pageTwo), for: .touchUpInside)
    }
    
    @objc func pageTwo() {
        getDelegate().router.navigateTo(relative: [Path("subnav", "Main.Page2")])
    }
}
