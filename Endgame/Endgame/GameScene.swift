//
//  GameScene.swift
//  Endgame
//
//  Created by Bo Yan on 12/2/19.
//  Copyright © 2019 Bo Yan. All rights reserved.
//

import SpriteKit
import GameplayKit

struct Collision {
    static let Naruto: UInt32 = 0x00
    static let Block: UInt32 = 0x01
}

enum BlockType: Int {
    case Short = 0
    case Medium = 1
    case Long = 2
}

enum RowType: Int {
    case oneShort = 0
    case oneMedium = 1
    case oneLong = 2
    case twoShort = 3
    case twoMedium = 4
    case threeShort = 5
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var naruto : SKSpriteNode!
    var doppelgänger : SKSpriteNode!
    var startPosition : CGPoint!
    
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        addPlayer()
        
    }
    
    var lastUpdateTimeInterval = TimeInterval()
    var lastYieldTimeInterval = TimeInterval()
    
    func updateWithTimeSinceLastUpdate(timeSinceLastUpdate: CFTimeInterval) {
        lastYieldTimeInterval += timeSinceLastUpdate
        if lastYieldTimeInterval > 0.6 {
            lastYieldTimeInterval = 0
            addRandomRow()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        var timeSinceLastUpdate = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        if timeSinceLastUpdate > 1 {
            timeSinceLastUpdate = 1 / 60
            lastUpdateTimeInterval = currentTime
        }
        
        updateWithTimeSinceLastUpdate(timeSinceLastUpdate: timeSinceLastUpdate)
    }
    
    func addPlayer() {
        naruto = SKSpriteNode(color: UIColor.yellow, size: CGSize(width: 50, height: 50))
        naruto.position = CGPoint(x: 0, y: -self.size.height / 2 + naruto.size.height)
        naruto.name = "Naruto"
        naruto.physicsBody?.isDynamic = false
        naruto.physicsBody = SKPhysicsBody(rectangleOf: naruto.size)
        naruto.physicsBody?.categoryBitMask = Collision.Naruto
        naruto.physicsBody?.collisionBitMask = 0
        naruto.physicsBody?.contactTestBitMask = Collision.Block
        
        doppelgänger = SKSpriteNode(color: UIColor.yellow, size: CGSize(width: 50, height: 50))
        doppelgänger.position = naruto.position
        doppelgänger.name = "Doppelgänger"
        doppelgänger.physicsBody?.isDynamic = false
        doppelgänger.physicsBody = SKPhysicsBody(rectangleOf: doppelgänger.size)
        doppelgänger.physicsBody?.categoryBitMask = Collision.Naruto
        doppelgänger.physicsBody?.collisionBitMask = 0
        doppelgänger.physicsBody?.contactTestBitMask = Collision.Block
        
        addChild(naruto)
        addChild(doppelgänger)
        
        startPosition = naruto.position
    }
    
    func addBlock(type: BlockType) -> SKSpriteNode {
        let block = SKSpriteNode(color: UIColor.red, size: CGSize(width: 0, height: 30))
        block.name = "Block"
        block.physicsBody?.isDynamic = true
        
        switch type {
        case .Short:
            block.size.width = self.size.width * 0.15
            break
        case .Medium:
            block.size.width = self.size.width * 0.3
            break
        case .Long:
            block.size.width = self.size.width * 0.75
            break
        }
        
        block.position = CGPoint(x: 0, y: self.size.height / 2 + block.size.height)
        block.physicsBody = SKPhysicsBody(rectangleOf: block.size)
        block.physicsBody?.categoryBitMask = Collision.Block
        block.physicsBody?.collisionBitMask = 0
        
        return block
    }
    
    func addRow(type: RowType) {
        switch type {
        case .oneShort:
            let block = addBlock(type: .Short)
            block.position = CGPoint(x: 0, y: block.position.y)
            addMovement(block: block)
            addChild(block)
            break
        case .oneMedium:
            let block = addBlock(type: .Medium)
            block.position = CGPoint(x: 0, y: block.position.y)
            addMovement(block: block)
            addChild(block)
            break
        case .oneLong:
            let block = addBlock(type: .Long)
            block.position = CGPoint(x: 0, y: block.position.y)
            addMovement(block: block)
            addChild(block)
            break
        case .twoShort:
            let block1 = addBlock(type: .Short)
            let block2 = addBlock(type: .Short)
            block1.position = CGPoint(x: -self.size.width / 5, y: block1.position.y)
            block2.position = CGPoint(x: self.size.width / 5, y: block2.position.y)
            addMovement(block: block1)
            addMovement(block: block2)
            addChild(block1)
            addChild(block2)
            break
        case .twoMedium:
            let block1 = addBlock(type: .Medium)
            let block2 = addBlock(type: .Medium)
            block1.position = CGPoint(x: -self.size.width / 24 * 7, y: block1.position.y)
            block2.position = CGPoint(x: self.size.width / 24 * 7, y: block2.position.y)
            addMovement(block: block1)
            addMovement(block: block2)
            addChild(block1)
            addChild(block2)
            break
        case .threeShort:
            let block1 = addBlock(type: .Short)
            let block2 = addBlock(type: .Short)
            let block3 = addBlock(type: .Short)
            block1.position = CGPoint(x: -self.size.width * 0.2875, y: block1.position.y)
            block2.position = CGPoint(x: self.size.width * 0.2875, y: block2.position.y)
            block3.position = CGPoint(x: 0, y: block3.position.y)
            addMovement(block: block1)
            addMovement(block: block2)
            addMovement(block: block3)
            addChild(block1)
            addChild(block2)
            addChild(block3)
            break
        }
    }
    
    func addMovement(block: SKSpriteNode) {
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: block.position.x, y: -self.size.height / 2), duration: TimeInterval(3)))
        actionArray.append(SKAction.removeFromParent())
        
        block.run(SKAction.sequence(actionArray))
    }
    
    func addRandomRow() {
        let randomNumber = Int(arc4random_uniform(6))
        switch randomNumber {
        case 0:
            addRow(type: RowType(rawValue: 0)!)
            break
        case 1:
            addRow(type: RowType(rawValue: 1)!)
            break
        case 2:
            addRow(type: RowType(rawValue: 2)!)
            break
        case 3:
            addRow(type: RowType(rawValue: 3)!)
            break
        case 4:
            addRow(type: RowType(rawValue: 4)!)
            break
        case 5:
            addRow(type: RowType(rawValue: 5)!)
            break
        default:
            break
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "Naruto" {
            let transition = SKTransition.fade(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size)
            gameOverScene.scaleMode = .aspectFit
            self.view?.presentScene(gameOverScene, transition: transition)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let maximumPossibleForce = touch.maximumPossibleForce
            let force = touch.force
            let normalizedForce = force / maximumPossibleForce
            
            naruto.position.x =  normalizedForce * (self.size.width / 2 - 25)
            doppelgänger.position.x = -normalizedForce * (self.size.width / 2 - 25)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetPosition()
    }
    
    func resetPosition() {
        naruto.position = startPosition
        doppelgänger.position = startPosition
    }
}
