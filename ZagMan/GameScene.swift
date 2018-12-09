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
    var scoreLabel = SKLabelNode()
    var score = 0
    
    enum NodeCategory: UInt32 {
        case spike = 1
        case basketball = 2
    }
    
    
    // didMove is like viewDidLoad
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        // Load maze from GameScene.sks
        maze = self.childNode(withName: "maze") as! SKTileMapNode
        
        Spike = SKSpriteNode(imageNamed: "Spike")
        Spike.size = CGSize(width: 55, height: 45)
        Spike.position = CGPoint(x: 30, y: 110)
        Spike.physicsBody = SKPhysicsBody(circleOfRadius: Spike.size.height / 2)
        Spike.physicsBody?.affectedByGravity = false
        Spike.physicsBody?.categoryBitMask = NodeCategory.spike.rawValue
        Spike.physicsBody?.contactTestBitMask = NodeCategory.basketball.rawValue
        Spike.physicsBody?.collisionBitMask = 0
        addChild(Spike)
        
        scoreLabel = SKLabelNode(text: "Basketballs: 0")
        scoreLabel.fontName = "System"
        scoreLabel.fontSize = 50
        scoreLabel.fontColor = UIColor.white
        print(self.frame.minY)
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 50)
        addChild(scoreLabel)
        
        addBasketballs()

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == NodeCategory.basketball.rawValue {
            contact.bodyA.node?.removeFromParent()
        } else if contact.bodyB.categoryBitMask == NodeCategory.basketball.rawValue {
            contact.bodyB.node?.removeFromParent()
        }
        score += 1
        scoreLabel.text = "Basketballs: \(score)"
        
        if self.children.count == 3 {
            // All basketballs retrieved (only Spike, maze, and label nodes are left)
            print("You won!")
        }
    }
    
    func addBasketballs() {
        var y = 470
        while y > -300 {
            var x = -270
            while x < 280 {
                let position = CGPoint(x: x, y: y)
                let column = maze.tileColumnIndex(fromPosition: position)
                let row = maze.tileRowIndex(fromPosition: position) - 2
                let tile = maze.tileDefinition(atColumn: column, row: row)
                if tile == nil {
                    let ball = SKSpriteNode(imageNamed: "basketball")
                    ball.size = CGSize(width: 30, height: 30)
                    ball.position = position
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.height / 2)
                    ball.physicsBody?.affectedByGravity = false
                    ball.physicsBody?.categoryBitMask = NodeCategory.basketball.rawValue
                    ball.physicsBody?.contactTestBitMask = NodeCategory.spike.rawValue
                    ball.physicsBody?.collisionBitMask = 0
                    addChild(ball)
                }
                x += 180
            }
            y -= 120
        }
        
    }
    
    func moveLocation(xMove: CGFloat, yMove: CGFloat) {
        let currentX = Spike.position.x
        let currentY = Spike.position.y
        let newPosition = CGPoint(x: currentX + xMove*60, y: currentY + yMove*60)
        let column = maze.tileColumnIndex(fromPosition: newPosition)
        let row = maze.tileRowIndex(fromPosition: newPosition) - 2 // For some reason the row count needs to be adjusted by 2
        let tile = maze.tileDefinition(atColumn: column, row: row)
        if tile == nil {
            let move = SKAction.moveBy(x: xMove*60, y: yMove*60, duration: 0.3) // Chose 60 to match tile size
            Spike.run(move) {
                // Closure that executes after Spike stops moving
                self.moveLocation(xMove: xMove, yMove: yMove)
            }
        } 
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
