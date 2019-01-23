//
//  AsynchronousOperation.swift
//  RJTranslate-App
//
//  Created by Даниил on 23/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class AsynchronousOperation: Operation {
    
    public enum State: String {
        case ready
        case executing
        case finished
        
        fileprivate var kvcKeyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    public var state: State = .ready {
        willSet {
            willChangeValue(forKey: newValue.kvcKeyPath)
            willChangeValue(forKey: self.state.kvcKeyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.kvcKeyPath)
            didChangeValue(forKey: self.state.kvcKeyPath)
        }
    }
    
    override public var isReady: Bool {
        return super.isReady && self.state == .ready
    }
    
    override public var isExecuting: Bool {
        return self.state == .executing
    }
    
    override public var isFinished: Bool {
        return self.state == .finished
    }
    
    override public var isAsynchronous: Bool {
        return true
    }
    
    override public func main() {
        super.main()
        self.state = .executing
    }
    
    override public func cancel() {
        super.cancel()
        self.state = .finished
    }
}
