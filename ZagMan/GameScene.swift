//
//  GameScene.swift
//  ZagMan
//
//  Created by Tibbetts, Lucille Rose on 11/26/18.
//  Copyright © 2018 Tibbetts, Lucille Rose. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var maze = SKTileMapNode()
    var Spike = SKSpriteNode()
    var BYU = SKSpriteNode()
    var scoreLabel = SKLabelNode()
    var score = 0
    
    enum NodeCategory: UInt32 {
        case spike = 1
        case basketball = 2
        case wall = 4
    }
    
    // didMove is like viewDidLoad
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        Spike = SKSpriteNode(imageNamed: "Spike")
        Spike.size = CGSize(width: 90, height: 80)
        Spike.position = CGPoint(x: self.frame.midX, y: 80)
        Spike.physicsBody = SKPhysicsBody(circleOfRadius: Spike.size.height / 2)
        Spike.physicsBody?.affectedByGravity = false
        Spike.physicsBody?.categoryBitMask = NodeCategory.spike.rawValue
        Spike.physicsBody?.contactTestBitMask = NodeCategory.basketball.rawValue | NodeCategory.wall.rawValue
        addChild(Spike)
        
        BYU = SKSpriteNode(imageNamed: "BYU")
        BYU.size = CGSize(width: 80, height: 90)
        BYU.position = CGPoint(x: -80, y: 400)
        BYU.physicsBody = SKPhysicsBody(circleOfRadius: BYU.size.height / 2)
        BYU.physicsBody?.affectedByGravity = false
        addChild(BYU)
        
        scoreLabel = SKLabelNode(text: "Basketballs: 0/8")
        scoreLabel.fontName = "System"
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 50)
        addChild(scoreLabel)
        
        for node in children {
            if node.name == "Wall" {
                // Add physics bodies to walls
                let sprite = node as! SKSpriteNode
                sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sprite.size.width, height: sprite.size.height))
                sprite.physicsBody?.affectedByGravity = false
                sprite.physicsBody?.categoryBitMask = NodeCategory.wall.rawValue
                sprite.physicsBody?.contactTestBitMask = NodeCategory.spike.rawValue
                sprite.physicsBody?.collisionBitMask = 0
                node.removeFromParent()
                addChild(sprite)
            } else if node.name == "Ball" {
                // Add physics bodies to basketballs
                let sprite = node as! SKSpriteNode
                sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.height / 2)
                sprite.physicsBody?.affectedByGravity = false
                sprite.physicsBody?.categoryBitMask = NodeCategory.basketball.rawValue
                sprite.physicsBody?.contactTestBitMask = NodeCategory.spike.rawValue
                sprite.physicsBody?.collisionBitMask = 0
                node.removeFromParent()
                addChild(sprite)
            }
        }

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == NodeCategory.basketball.rawValue {
            contact.bodyA.node?.removeFromParent()
            score += 1
            scoreLabel.text = "Basketballs: \(score)/8"
        } else if contact.bodyB.categoryBitMask == NodeCategory.basketball.rawValue {
            contact.bodyB.node?.removeFromParent()
            score += 1
            scoreLabel.text = "Basketballs: \(score)/8"
        } else if contact.bodyA.categoryBitMask == NodeCategory.wall.rawValue {
            contact.bodyB.node?.removeAllActions() // Stop Spike
        } else if contact.bodyB.categoryBitMask == NodeCategory.wall.rawValue {
            contact.bodyA.node?.removeAllActions()
        }
    }
    
    func moveLocation(xMove: CGFloat, yMove: CGFloat) {
        let move = SKAction.moveBy(x: xMove*60, y: yMove*60, duration: 0.25)
        let moveForever = SKAction.repeatForever(move)
        Spike.run(moveForever)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
