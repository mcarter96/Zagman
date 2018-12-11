//
//  GameScene.swift
//  ZagMan
//
//  Created by Tibbetts, Lucille Rose on 11/26/18.
//  Copyright © 2018 Tibbetts, Lucille Rose. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit
import CoreData

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var maze = SKTileMapNode()
    var Spike = SKSpriteNode()
    var BYU = SKSpriteNode()
    var UNC = SKSpriteNode()
    var scoreLabel = SKLabelNode()
    var score = 0
    var mascotActions = [SKAction]()
    var currentBYUActionIndex = 0
    var currentUNCActionIndex = 0
    
    enum NodeCategory: UInt32 {
        case spike = 1
        case basketball = 2
        case wall = 4
        case BYU = 8
        case UNC = 16
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
        Spike.physicsBody?.contactTestBitMask = NodeCategory.basketball.rawValue | NodeCategory.BYU.rawValue | NodeCategory.UNC.rawValue
        Spike.physicsBody?.collisionBitMask = NodeCategory.wall.rawValue
        addChild(Spike)
        
        BYU = SKSpriteNode(imageNamed: "BYU")
        BYU.size = CGSize(width: 80, height: 90)
        BYU.position = CGPoint(x: -240, y: 240)
        BYU.physicsBody = SKPhysicsBody(circleOfRadius: BYU.size.height / 2)
        BYU.physicsBody?.categoryBitMask = NodeCategory.BYU.rawValue
        BYU.physicsBody?.contactTestBitMask = NodeCategory.wall.rawValue | NodeCategory.spike.rawValue
        BYU.physicsBody?.collisionBitMask = 0
        BYU.physicsBody?.affectedByGravity = false
        addChild(BYU)
        
        UNC = SKSpriteNode(imageNamed: "UNC")
        UNC.size = CGSize(width: 90, height: 80)
        UNC.position = CGPoint(x: 240, y: 80)
        UNC.physicsBody = SKPhysicsBody(circleOfRadius: UNC.size.height / 2)
        UNC.physicsBody?.categoryBitMask = NodeCategory.UNC.rawValue
        UNC.physicsBody?.contactTestBitMask = NodeCategory.wall.rawValue | NodeCategory.spike.rawValue
        UNC.physicsBody?.collisionBitMask = 0
        UNC.physicsBody?.affectedByGravity = false
        addChild(UNC)
        
        let moveUp = SKAction.repeatForever(SKAction.moveBy(x: 0, y: 60, duration: 0.3))
        mascotActions.append(moveUp)
        let moveDown = SKAction.repeatForever(SKAction.moveBy(x: 0, y: -60, duration: 0.3))
        mascotActions.append(moveDown)
        
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
                sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sprite.size.width + 20, height: sprite.size.height + 20))
                sprite.physicsBody?.affectedByGravity = false
                sprite.physicsBody?.categoryBitMask = NodeCategory.wall.rawValue
                sprite.physicsBody?.contactTestBitMask = NodeCategory.BYU.rawValue | NodeCategory.UNC.rawValue
                sprite.physicsBody?.collisionBitMask = 0
                sprite.physicsBody?.usesPreciseCollisionDetection = true
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
        if contact.bodyA.categoryBitMask == NodeCategory.BYU.rawValue {
            if contact.bodyB.categoryBitMask == NodeCategory.spike.rawValue {
                gameOver()
            } else {
                // Contact with a wall
                BYU.removeAllActions()
            }
        } else if contact.bodyB.categoryBitMask == NodeCategory.BYU.rawValue {
            if contact.bodyA.categoryBitMask == NodeCategory.spike.rawValue {
                gameOver()
            } else {
                BYU.removeAllActions()
            }
        } else if contact.bodyA.categoryBitMask == NodeCategory.UNC.rawValue {
            if contact.bodyB.categoryBitMask == NodeCategory.spike.rawValue {
                gameOver()
            } else {
                UNC.removeAllActions()
            }
        } else if contact.bodyB.categoryBitMask == NodeCategory.UNC.rawValue {
            if contact.bodyA.categoryBitMask == NodeCategory.spike.rawValue {
                gameOver()
            } else {
                UNC.removeAllActions()
            }
        } else if contact.bodyA.categoryBitMask == NodeCategory.basketball.rawValue {
            contact.bodyA.node?.removeFromParent()
            score += 1
            scoreLabel.text = "Basketballs: \(score)/8"
        } else if contact.bodyB.categoryBitMask == NodeCategory.basketball.rawValue {
            contact.bodyB.node?.removeFromParent()
            score += 1
            scoreLabel.text = "Basketballs: \(score)/8"
        }
        
        if score == 8 {
            gameOver()
        }
    }
    
    func gameOver() {
        isPaused = true
        var alertTextField = UITextField()
        let alertController = UIAlertController(title: "Game Over", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter Name"
            alertTextField = textField
        })
        alertController.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { (action) -> Void in
            let text = alertTextField.text!
            if text != "" {
                let newHighScore = HighScore(context: self.context)
                newHighScore.name = text
                newHighScore.score = Int32(self.score)
                self.saveHighScores()
            }
            // Reset game scene
            
        }))
        alertController.addAction(UIAlertAction(title: "Exit", style: .default, handler: { (action) -> Void in
            let text = alertTextField.text!
            if text != "" {
                let newHighScore = HighScore(context: self.context)
                newHighScore.name = text
                newHighScore.score = Int32(self.score)
                self.saveHighScores()
            }
            // Return to Welcome View Controller
            let navigationController = self.view?.window?.rootViewController as! UINavigationController
            navigationController.popViewController(animated: true)
        }))
        // Reference: https://stackoverflow.com/questions/34367268/displaying-a-uialertcontroller-in-gamescene-spritekit-swift
        self.view?.window?.rootViewController?.present(alertController, animated: true)
    }
    
    func saveHighScores() {
        do {
            try context.save()
        }
        catch {
            print("Error saving items \(error)")
        }
    }
    
    func moveLocation(xMove: CGFloat, yMove: CGFloat, sprite: SKSpriteNode) {
        sprite.removeAllActions()
        let move = SKAction.moveBy(x: xMove*60, y: yMove*60, duration: 0.25)
        let moveForever = SKAction.repeatForever(move)
        sprite.run(moveForever)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if !BYU.hasActions() {
            let index = Int.random(in: 0...1)
            if index != currentBYUActionIndex {
                let action = mascotActions[index]
                currentBYUActionIndex = index
                BYU.run(action)
            }
        }
        if !UNC.hasActions() {
            let index = Int.random(in: 0...1)
            if index != currentUNCActionIndex {
                let action = mascotActions[index]
                currentUNCActionIndex = index
                UNC.run(action)
            }
        }
    }
}
