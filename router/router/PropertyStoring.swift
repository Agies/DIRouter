//
//  PropertyStoring.swift
//  router
//
//  Created by agies on 7/3/18.
//  Copyright © 2018 agies. All rights reserved.
//

public protocol PropertyStoring {
    func getAssociatedObject<T>(_ key: UnsafeRawPointer!, defaultValue: T) -> T
}

public extension PropertyStoring {
    func getAssociatedObject<T>(_ key: UnsafeRawPointer!, defaultValue: T) -> T {
        guard let value = objc_getAssociatedObject(self, key) as? T else {
            objc_setAssociatedObject(self, key, defaultValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return defaultValue
        }
        return value
    }
    func setAssociatedObject<T>(_ key: UnsafeRawPointer!, value: T) {
        objc_setAssociatedObject(self, key, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
