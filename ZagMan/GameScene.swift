//
//  GameScene.swift
//  ZagMan
//
//  Created by Tibbetts, Lucille Rose on 11/26/18.
//  Copyright © 2018 Tibbetts, Lucille Rose. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var maze = SKTileMapNode()
    var Spike = SKSpriteNode()
    
    // didMove is like viewDidLoad
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.lightGray
        
        // Load maze from GameScene.sks
        maze = self.childNode(withName: "maze") as! SKTileMapNode
        
        let Spike = SKSpriteNode(imageNamed: "Spike")
        Spike.size = CGSize(width: 55, height: 45)
        Spike.position = CGPoint(x: 30, y: 110)
        addChild(Spike)
        self.Spike = Spike

    }
    
    func moveLocation(xMove: CGFloat, yMove: CGFloat) {
        let currentX = Spike.position.x
        let currentY = Spike.position.y
        let newPosition = CGPoint(x: currentX + xMove*60, y: currentY + yMove*60)
        let column = maze.tileColumnIndex(fromPosition: newPosition)
        let row = maze.tileRowIndex(fromPosition: newPosition) - 2 // For some reason the row count needs to be adjusted by 2
        let tile = maze.tileDefinition(atColumn: column, row: row)
        if tile == nil && !Spike.hasActions() {
            let move = SKAction.moveBy(x: xMove*60, y: yMove*60, duration: 0.3) // Chose 60 to match tile size
            Spike.run(move)
        } else {
            print("wall!")
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
