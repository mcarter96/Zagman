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
    }
    
    @IBOutlet weak var image: UIImageView!
    
    @IBAction func instructionsButton(_ sender: UIButton) {
        let instruct = """
        Move Spike around the maze trying to collect as many basketballs as you can.
        Be careful though, other teams are out to get you. If they touch you, the
        game is over. Good luck!
        """
        let alertController = UIAlertController(title: "Instructions", message: instruct, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
            print("User just pressed okay")
        }))
        present(alertController, animated: true, completion: { () -> Void in
            print("Just finished showing the alert dialog to the user")
        })
    }
    
    @IBAction func highScoresButton(_ sender: UIButton) {
        var scores = ""
        for x in 0..<scoreArray.count {
            if x < 10 {
                scores.append("\n\(scoreArray[x])")
                print("\(scoreArray[x])")
            }
        }
        let alertController = UIAlertController(title: "High Scores", message: scores, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
            print("User just hit okay")
        }))
        present(alertController, animated: true, completion: { () -> Void in
            print("just showd the alert to user")
        })
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
