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
        sceneNode.viewController = self
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
    
    func gameOver() {
        var alertTextField = UITextField()
        var alertController = UIAlertController(title: "Game Over", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter Name"
            alertTextField = textField
        })
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
            let text = alertTextField.text!
            let newHighScore = HighScore(context: self.context)
            newHighScore.name = text
            newHighScore.score = Int32(self.sceneNode.score)
            // MARK: lab #8.c.
            self.scoreArray.append(newHighScore)
            self.saveHighScores()
        }))
        present(alertController, animated: true, completion: { () -> Void in
            print("just showd the alert to user")
            
        })
    }
    
    func saveHighScores() {
        
        do {
            try context.save()
        }
        catch {
            print("Error saving items \(error)")
        }
    }
    
    // MARK: lab #6
    func loadHighScores(withPredicate predicate: NSPredicate? = nil) {
        let request: NSFetchRequest<HighScore> = HighScore.fetchRequest()
        // MARK: lab #14
        let sortDescripter = NSSortDescriptor(key: "score", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        request.sortDescriptors = [sortDescripter]
        
        do {
            scoreArray = try context.fetch(request)
        } catch {
            print("Error loading items \(error)")
        }
    }
    
}
