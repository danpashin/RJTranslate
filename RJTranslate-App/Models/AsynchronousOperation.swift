//
//  AsynchronousOperation.swift
//  RJTranslate-App
//
//  Created by Даниил on 23/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class AsynchronousOperation: Operation {
    
    enum State: String {
        case ready
        case executing
        case finished
        
        fileprivate var kvcKeyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    var state: State = .ready {
        willSet {
            willChangeValue(forKey: newValue.kvcKeyPath)
            willChangeValue(forKey: self.state.kvcKeyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.kvcKeyPath)
            didChangeValue(forKey: self.state.kvcKeyPath)
        }
    }
    
    override var isReady: Bool {
        return super.isReady && self.state == .ready
    }
    
    override var isExecuting: Bool {
        return self.state == .executing
    }
    
    override var isFinished: Bool {
        return self.state == .finished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override func main() {
        super.main()
        self.state = .executing
    }
    
    override func cancel() {
        super.cancel()
        self.state = .finished
    }
}
