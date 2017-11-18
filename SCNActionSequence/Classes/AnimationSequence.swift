//
//  AppDelegate.swift
//  SCNActionSequence
//
//  Created by Michael-Vorontsov on 11/18/2017.
//  Copyright (c) 2017 Michael-Vorontsov. All rights reserved.
//
import SceneKit

public final class AnimatonSequence {
    
    //MARK: - Privat
    private(set) var serial: Bool = true
    private var prevSequence: AnimatonSequence? = nil
    
    private init(target: SCNNode, action: SCNAction, predecessor: AnimatonSequence) {
        self.action = action
        self.target = target
        self.prevSequence = predecessor
    }
    
    //MARK: - Public
    public let action: SCNAction
    public let target: SCNNode
    
    /// Create new sequence, with node and animation
    ///
    /// - Parameters:
    ///   - target: target node
    ///   - action: animation
    public  init(target: SCNNode, action: SCNAction) {
        self.action = action
        self.target = target
    }
    
    /// Create new sequence, with transaction
    ///
    /// Although target not needed to transaction animation, it is required to compose sequence.
    /// Any node suiatble.
    ///
    /// - Parameters:
    ///   - target: Node to run animation with.
    ///   - transactionDuration: Animation duration
    ///   - transactionBlock: transaction block to execute(within SCNTransaction.begin() - .commit() range
    public convenience init(target: SCNNode, transactionDuration: TimeInterval, transactionBlock: @escaping (()->()) )  {
        let action = SCNAction.run({_ in
            SCNTransaction.begin()
            SCNTransaction.animationDuration = transactionDuration
            transactionBlock()
            SCNTransaction.commit()
        }, queue: DispatchQueue.main)
        let waitAction = SCNAction.wait(duration: transactionDuration)
        let sequence = SCNAction.sequence([action, waitAction])
        self.init(target: target, action: sequence)
    }
    
    /// Launch sequence
    ///
    /// - Parameter completion: optional complition block
    public func run(completion: (()->())? = nil ) {
        let completionAction = SCNAction.run({ (_) in completion?()}, queue: DispatchQueue.main)
        let sequence = serial ? SCNAction.sequence([action, completionAction]) : SCNAction.group([action, completionAction])
        
        if  let prevSequence = prevSequence {
            prevSequence.run{ [weak target] in target?.runAction(sequence) }
        } else {
            target.runAction(sequence)
        }
    }
    
    ///  Add subsequent transaction
    ///
    /// - Parameters:
    ///   - target: target node
    ///   - action: action to perform
    /// - Returns: Sequence
    public func then(target: SCNNode?, action: SCNAction) -> AnimatonSequence {
        // If target not exist - skip it
        guard let target = target else { return self }
        let result = AnimatonSequence(target: target, action: action, predecessor: self)
        return result
    }
    
    /// Add subsequent action with current target
    ///
    /// - Parameter action: action to perform
    /// - Returns:  Sequence
    public func then(action: SCNAction) -> AnimatonSequence {
        let result = AnimatonSequence(target: target, action: action, predecessor: self)
        return result
    }
    
    ///  Add subseqent handler block
    ///
    /// - Parameter handler: block to run
    /// - Returns: nil
    public func then(handler: @escaping (SCNNode)->()) -> AnimatonSequence  {
        let action = SCNAction.run {  handler($0) }
        let result = AnimatonSequence(target: target, action: action, predecessor: self)
        return result
    }
    
    /// Add subsequent animation tansaction
    ///
    /// - Parameters:
    ///   - duration: duration
    ///   - transactionBlock: transaction body bloc
    /// - Returns: sequence
    public func then(transactionDuration duration: TimeInterval, transactionBlock: @escaping (()->()) ) -> AnimatonSequence {
        
        let result = AnimatonSequence(target: target, transactionDuration: duration, transactionBlock: transactionBlock)
        result.prevSequence = self
        return result
    }
    
    /// Add subsequent sequence. Sequence execution will be wrapped inside block
    ///
    /// - Parameter sequence: seqeucne to add
    /// - Returns: sequence wrapper
    public func then(sequence: AnimatonSequence) -> AnimatonSequence {
        return then { _ in sequence.run() }
    }
    
    /// Wait for delay
    ///
    /// - Parameter duration: duration to wait
    /// - Returns: sequence
    public func then(wait duration: TimeInterval) -> AnimatonSequence  {
        let action = SCNAction.wait(duration: duration)
        let result = AnimatonSequence(target: target, action: action, predecessor: self)
        return result
    }
    
    /// Switch last sequence to parallele mode (will affect only las sequence)
    ///
    /// - Returns: parallele sequence
    public func runSimultaneouslyWith() -> AnimatonSequence {
        serial = false
        return self
    }
}

public extension SCNNode {
    
    /// Prepare sequence with recepient node
    ///
    /// - Parameter action: action to run
    /// - Returns: sequence
    public func begin(action: SCNAction) -> AnimatonSequence {
        return AnimatonSequence(target: self, action: action)
    }
}

