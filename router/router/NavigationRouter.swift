//
//  Router.swift
//  router
//
//  Created by agies on 7/3/18.
//  Copyright © 2018 agies. All rights reserved.
//

import Foundation

public class NavigationRouter {
    typealias PathMeta = (String, [String], Bool?)
    var displayers = [String: Displayer]()
    var held = [String: PathMeta]()
    var _currentPath = [Path]()
    
    public var canBack: Bool {
        get {
            return _currentPath.filter({ (p) -> Bool in
                return p.includeInBackstack
            }).count > 1
        }
    }
    
    public var currentPath: [Path] {
        get {
            return _currentPath
        }
    }
    
    public init() {}
    
    public func navigateTo(path: [Path]) {
        if path.count == 0 { return }
        _currentPath = path
        let displayerSet = displayers.map { (key, value) in
            return key
        }
        navigateTo(groupPath(), displayerSet: displayerSet)
    }
    
    public func navigateTo(relative path: [Path]) {
        if path.count == 0 { return }
        _currentPath.append(contentsOf: path)
        let displayerSet = displayers.map { (key, value) in
            return key
        }
        navigateTo(groupPath(), displayerSet: displayerSet)
    }
    
    private func groupPath() -> [PathMeta] {
        var grouped = [PathMeta]()
        var displayerIndex = [String: Int]()
        _currentPath.forEach { (p) in
            var i = displayerIndex[p.displayerName] ?? grouped.index(where: { t in
                return t.0 == p.displayerName
            })
            if i == nil {
                grouped.append((p.displayerName, [String](), p.animate))
                i = grouped.count - 1
            }
            displayerIndex[p.displayerName] = i
            grouped[i!].1.append(p.segment)
            grouped[i!].2 = p.animate
        }
        return grouped
    }
    
    private func navigateTo(_ grouped: [PathMeta], displayerSet: [String]) {
        var ds = displayerSet
        var g = grouped
        if displayerSet.count == 0 && g.count == 0 { return }
        let p: PathMeta
        if (g.count != 0) {
            p = g.removeFirst()
            if let index = ds.index(of: p.0) {
                ds.remove(at: index)
            }
        } else {
            let d = ds.removeFirst()
            p = (d, [String](), true)
        }
        if let displayer = displayers[p.0] {
            print("Displaying on \(p.0) with \(p.1)")
            var shouldAnimate = g.count == 0
            if let animate = p.2 {
                shouldAnimate = animate
            }
            displayer.show(p.1, animate: shouldAnimate, completion: nil)
        } else {
            held[p.0] = p
            print("Displayer \(p.0) was missing, holding \(p.1)")
        }
        navigateTo(g, displayerSet: ds)
    }
    
    public func back() {
        if let _ = _currentPath.popLast() {
            while (_currentPath.last?.includeInBackstack == false) {
                let _ = _currentPath.popLast()
            }
            navigateTo(path: _currentPath)
        }
    }
    
    public func backToRoot(ofDisplayer displayer: String) {
        if _currentPath.count == 0 { return }
        var index = 0
        for i in 0...(_currentPath.count - 1) {
            if _currentPath[i].displayerName == displayer {
                index = i
            }
        }
        let mod = _currentPath.dropLast(_currentPath.count - index)
        _currentPath = [Path](mod)
        navigateTo(path: _currentPath)
    }
    
    public func removeDisplayer(named: String) {
        displayers[named] = nil
        print("Displayer \(named) was removed")
    }
    
    public func addDisplayer(_ displayer: Displayer, named: String) {
        displayers[named] = displayer
        if let h = held[named] {
            held[named] = nil
            print("Displayer \(named) added with held path \(h)")
            displayer.show(h.1, animate: h.2 ?? true, completion: nil)
        }
    }
}

public struct Path {
    public let displayerName: String
    public let segment: String
    public let includeInBackstack: Bool
    public let animate: Bool?
    
    public init(_ displayerName: String, _ segment: String, _ animate: Bool? = nil, _ includeInBackstack: Bool = true) {
        self.displayerName = displayerName
        self.segment = segment
        self.includeInBackstack = includeInBackstack
        self.animate = animate
    }
}
