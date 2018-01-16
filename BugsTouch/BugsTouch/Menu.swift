//
//  Menu.swift
//  BugsTouch
//
//  Created by sdev on 11/10/17.
//  Copyright © 2017 sdev. All rights reserved.
//
import UIKit
import Foundation
class Menu : UIViewController
{
    @IBOutlet var Highscore: UITextView!
    
    @IBOutlet var startGameButton: UIButton!
    @IBOutlet var highscoreButton: UIButton!
    
    @IBOutlet var top3label: UILabel!
    @IBAction func highscoreButton(_ sender: AnyObject, forEvent event: UIEvent)
    {
        if(Highscore.isHidden == true)
        {
            Highscore.isHidden = false
            top3label.isHidden = false
        }
        else
        {
            Highscore.isHidden = true
            top3label.isHidden = true
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Highscore.textColor = UIColor.red
        Highscore.isHidden = true
        top3label.isHidden = true
        
        startGameButton.layer.cornerRadius = 50
        highscoreButton.layer.cornerRadius = 50
        top3label.layer.cornerRadius = 50
        
        
        let highscore1 = UserDefaults.standard.array(forKey: "highscore1")
        let highscore2 = UserDefaults.standard.array(forKey: "highscore2")
        let highscore3 = UserDefaults.standard.array(forKey: "highscore3")
        
        
        if(highscore3 != nil)
        {
            Highscore.text = "1. " + String(describing: highscore1![0]) + " - " + String(describing: highscore1![1]) + "\n2. " +
                String(describing: highscore2![0]) + " - " + String(describing: highscore2![1]) + "\n3. " +
                String(describing: highscore3![0]) + " - " + String(describing: highscore3![1])
        }
        
  

        // Do any additional setup after loading the view, typically from a nib.
    }

}
