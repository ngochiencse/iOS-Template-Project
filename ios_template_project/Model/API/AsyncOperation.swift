//
//  AsyncOperation.swift
//  ios_template_project
//
//  Created by Hien Pham on 8/22/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import UIKit

/**
 Implementation for an operation the perform asynchronously.
 */
public class AsyncOperation: Operation {
    public enum State: String {
        case isReady, isExecuting, isFinished
    }

    public override var isAsynchronous: Bool {
        return true
    }

    public var state = State.isReady {
        willSet {
            willChangeValue(forKey: state.rawValue)
            willChangeValue(forKey: newValue.rawValue)
        }
        didSet {
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: state.rawValue)
        }
    }

    public override var isExecuting: Bool {
        return state == .isExecuting
    }

    public override var isFinished: Bool {
        return state == .isFinished
    }

    public override func start() {
        guard !self.isCancelled else {
            state = .isFinished
            return
        }

        state = .isExecuting
        main()
    }

    // MARK: - Public
    /// Subclasses must implement this to perform their work and they must not call `super`.
    /// The default implementation of this function traps.
    open override func main() {
        preconditionFailure("Subclasses must implement `main`.")
    }
}
