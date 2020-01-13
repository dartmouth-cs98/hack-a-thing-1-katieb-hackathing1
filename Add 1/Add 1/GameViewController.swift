//
//  ViewController.swift
//  Add 1
//
//  Created by Katie Bernardez on 1/13/20.
//  Copyright © 2020 Katie Bernardez. All rights reserved.
//  Adapted from: https://learnappmaking.com/creating-a-simple-ios-game-with-swift-in-xcode/
//  updateScoreLabel() updates the score based on the global variable score
//  updateNumberLabel() updates the number using the random number string generator from the String class
//  updateTimeLabel() updates the timer
//  inputFieldDidChange() checks if the user inputed number is correct and if it is adds 1 to the score, otherwise subtracts 1
//  finishGame() alerts the user of their final score and resets the time, score and number labels

import UIKit

class GameViewController: UIViewController {
    @IBOutlet weak var scoreLabel:UILabel?
    @IBOutlet weak var timeLabel:UILabel?
    @IBOutlet weak var numberLabel:UILabel?
    @IBOutlet weak var inputField:UITextField?
    @IBOutlet weak var image1:UIImageView? // added in thumbs up image when the user is correct
    @IBOutlet weak var image2:UIImageView? // added in thumbs down image when the user is wrong
    
    var score = 0
    
    var timer:Timer?
    var seconds = 120 // changed the timer to start at 2 minutes

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateScoreLabel()
        updateNumberLabel()
        updateTimeLabel()
        
        // Hide both images initially
        image1?.isHidden = true
        image2?.isHidden = true
    }

    func updateScoreLabel() {
        scoreLabel?.text = String(score)
    }
    
    func updateNumberLabel() {
        numberLabel?.text = String.randomNumber(length: 4)
    }
    
    func updateTimeLabel() {

        let min = (seconds / 60) % 60
        let sec = seconds % 60

        timeLabel?.text = String(format: "%02d", min) + ":" + String(format: "%02d", sec)
    }
    
    @IBAction func inputFieldDidChange()
    {
        guard let numberText = numberLabel?.text, let inputText = inputField?.text else {
            return
        }
        
        guard inputText.count == 4 else {
            return
        }
        
        var isCorrect = true
        
        for n in 0..<4
        {
            var input = inputText.integer(at: n)
            let number = numberText.integer(at: n)
            
            if input == 0 {
                input = 10
            }
            
            if input != number + 1 {
                isCorrect = false
                break
            }
        }
        
        if isCorrect {
            score += 1
            
            // Show thumbs up image
            image1?.isHidden = false
            image2?.isHidden = true
        } else {
            score -= 1
            
            // Show thumbs down image
            image1?.isHidden = true
            image2?.isHidden = false
        }

        updateNumberLabel()
        updateScoreLabel()
        inputField?.text = ""
        
        // Added in new logic to make the time decrease twice as fast if the score is < 10
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if self.seconds == 0 {
                    self.finishGame()
                } else if self.seconds <= 120 {
                    if self.score > 10 {
                        self.seconds -= 2
                        self.updateTimeLabel()
                    } else {
                        self.seconds -= 1
                        self.updateTimeLabel()
                    }
                }
            }
        }
    }
    
    func finishGame()
    {
        timer?.invalidate()
        timer = nil
        
        let alert = UIAlertController(title: "Time's Up!", message: "Your time is up! You got a score of \(score) points. Awesome!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK, start new game", style: .default, handler: nil))

        self.present(alert, animated: true, completion: nil)
        
        score = 0
        seconds = 120
        
        updateTimeLabel()
        updateScoreLabel()
        updateNumberLabel()
        
        // Hide both images when the game is over
        image1?.isHidden = true
        image2?.isHidden = true
    }
}

