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
    
    var maze : SKTileMapNode!
    var Spike : SKSpriteNode!
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    
    override func sceneDidLoad() {
        backgroundColor = SKColor.lightGray
        
        guard let maze = childNode(withName: "ZagManMaze") as? SKTileMapNode else {
            print("Maze not loaded")
            return
        }
        self.maze = maze
        
        let Spike = SKSpriteNode(imageNamed: "Spike")
        Spike.position = CGPoint(x: 25, y: 90)
        addChild(Spike)
        self.Spike = Spike
    
        self.lastUpdateTime = 0

    }
    
    func moveLocation(xMove: CGFloat, yMove: CGFloat) {
        let move = SKAction.moveBy(x: xMove*15, y: yMove*15, duration: 1.0)
        Spike.run(move)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
