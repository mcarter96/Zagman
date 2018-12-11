//
//  WelcomeViewController.swift
//  ZagMan
//
//  Created by Tibbetts, Lucille Rose on 12/8/18.
//  Copyright © 2018 Tibbetts, Lucille Rose. All rights reserved.
//

import UIKit
import CoreData

class WelcomeViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var scoreArray = [HighScore]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        image.image = UIImage(named: "Spike")
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print(documentsDirectory)
        
        loadHighScores()
    }
    
    @IBOutlet weak var image: UIImageView!
    
    @IBAction func instructionsButton(_ sender: UIButton) {
        let instruct = """
        Move Spike around the maze trying to collect as many basketballs as you can. 🏀🏀🏀
        Be careful though, other teams are out to get you. If they touch you, the
        game is over. Good luck!
        """
        let alertController = UIAlertController(title: "Instructions", message: instruct, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default))
        present(alertController, animated: true)
    }
    
    @IBAction func highScoresButton(_ sender: UIButton) {
        var scores = ""
        for x in 0..<scoreArray.count {
            if x < 5 {
                scores.append("\(x+1). \(scoreArray[x].name): \(scoreArray[x].score) \n")
            }
        }
        if scores.count == 0 {
            scores = "None"
        }
        let alertController = UIAlertController(title: "High Scores", message: scores, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default))
        present(alertController, animated: true)
        
    }
    
    func loadHighScores() {
        let request: NSFetchRequest<HighScore> = HighScore.fetchRequest()
        let sortDescripter = NSSortDescriptor(key: "score", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        request.sortDescriptors = [sortDescripter]
        do {
            scoreArray = try context.fetch(request)
        } catch {
            print("Error loading items \(error)")
        }
    }
    
}
