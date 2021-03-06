//
//  GameViewController.swift
//  ZagMan
//
//  Created by Tibbetts, Lucille Rose on 11/26/18.
//  Copyright © 2018 Tibbetts, Lucille Rose. All rights reserved.
//

import UIKit
import CoreData
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var sceneNode = GameScene()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var scoreArray = [HighScore]()
    
    @IBAction func MoveUp(_ sender: UIButton) {
        sceneNode.moveLocation(xMove: 0, yMove: 1, sprite: sceneNode.Spike)
    }
    
    @IBAction func MoveLeft(_ sender: UIButton) {
        sceneNode.moveLocation(xMove: -1, yMove: 0, sprite: sceneNode.Spike)
    }
    
    @IBAction func MoveDown(_ sender: UIButton) {
        sceneNode.moveLocation(xMove: 0, yMove: -1, sprite: sceneNode.Spike)
    }
    
    @IBAction func MoveRight(_ sender: UIButton) {
        sceneNode.moveLocation(xMove: 1, yMove: 0, sprite: sceneNode.Spike)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load 'GameScene.sks' as a GKScene. 
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                self.sceneNode = sceneNode
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
