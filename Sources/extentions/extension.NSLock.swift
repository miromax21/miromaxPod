//
//  extention.NSLock.swift
//  EventSDK
//
//  Created by Sergey Zhidkov on 28.04.2022.
//

import Foundation
extension NSLock {
    @discardableResult
    func with<T>(_ block: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try block()
    }
}
