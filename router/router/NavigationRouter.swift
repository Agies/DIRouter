//
//  Router.swift
//  router
//
//  Created by agies on 7/3/18.
//  Copyright © 2018 agies. All rights reserved.
//

import Foundation

public class NavigationRouter {
    var displayers = [String: Displayer]()
    var held = [String: [String]]()
    var _currentPath = [Path]()
    
    public var canBack: Bool {
        get {
            return _currentPath.count > 1
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
    
    private func groupPath() -> [(String, [String])] {
        var grouped = [(String, [String])]()
        var displayerIndex = [String: Int]()
        _currentPath.forEach { (p) in
            var i = displayerIndex[p.displayerName] ?? grouped.index(where: { t in
                return t.0 == p.displayerName
            })
            if i == nil {
                grouped.append((p.displayerName, [String]()))
                i = grouped.count - 1
            }
            displayerIndex[p.displayerName] = i
            grouped[i!].1.append(p.segment)
        }
        return grouped
    }
    
    private func navigateTo(_ grouped: [(String, [String])], displayerSet: [String]) {
        var ds = displayerSet
        var g = grouped
        if displayerSet.count == 0 && g.count == 0 { return }
        let p: (String, [String])
        if (g.count != 0) {
            if displayerSet.count > 0 {
                ds.removeFirst()
            }
            p = g.removeFirst()
        } else {
            let d = ds.removeFirst()
            p = (d, [String]())
        }
        if let displayer = displayers[p.0] {
            print("Displaying on \(p.0) with \(p.1)")
            displayer.show(p.1, animate: g.count == 0, completion: {
                [weak self] in
                self?.navigateTo(g, displayerSet: ds)
            })
        } else {
            if held[p.0] == nil {
                held[p.0] = [String]()
            }
            held[p.0]?.append(contentsOf: p.1)
            print("Displayer \(p.0) missed holding \(p.1)")
        }
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
    }
    
    public func addDisplayer(_ displayer: Displayer, named: String) {
        displayers[named] = displayer
        if let h = held[named] {
            held[named] = nil
            print("Displayer \(named) added with held \(h)")
            displayer.show(h, animate: true, completion: nil)
        }
    }
}

public struct Path {
    public let displayerName: String
    public let segment: String
    public let includeInBackstack: Bool
    
    public init(_ displayerName: String, _ segment: String, _ includeInBackstack: Bool = true) {
        self.displayerName = displayerName
        self.segment = segment
        self.includeInBackstack = includeInBackstack
    }
}
