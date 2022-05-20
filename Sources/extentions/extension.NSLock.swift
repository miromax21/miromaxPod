//
//  extention.NSLock.swift
//  EventSDK
//
//  Created by Maksim Mironov on 28.04.2022.
//

import Foundation
extension NSRecursiveLock {
    @discardableResult
    func with<T>(_ block: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try block()
    }
}
