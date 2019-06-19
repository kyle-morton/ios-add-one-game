//
//  MainViewController.swift
//  Add1
//
//  Created by Kyle Morton on 6/17/19.
//  Copyright © 2019 LearnAppMaking. All rights reserved.
//

import UIKit
import MBProgressHUD

class MainViewController: UIViewController {

    @IBOutlet weak var numbersLabel:UILabel?
    @IBOutlet weak var scoreLabel:UILabel?
    @IBOutlet weak var inputField:UITextField?
    @IBOutlet weak var timeLabel:UILabel?
    
    var score = 0
    
    var hud:MBProgressHUD?
    var timer:Timer?
    var seconds = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hud = MBProgressHUD(view:self.view)
        if hud != nil {
            self.view.addSubview(hud!)
        }
        
        setRandomNumberLabel()
        updateScoreLabel()

        // add text-change eventhandler to input field
        inputField?.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
    }
    
    func updateScoreLabel()
    {
        scoreLabel?.text = "\(score)"
    }
    
    func setRandomNumberLabel() {
        numbersLabel?.text = generateRandomString()
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        
        if (inputField?.text?.count ?? 0 < 4) {
            return;
        }
        
        // validate answer when text >= 4 characters
        if let numbers_text = numbersLabel?.text,
           let input_text = inputField?.text,
           let numbers = Int(numbers_text),
           let input = Int(input_text) {
           
            print("Comparing: \(input_text) minus \(numbers_text) == \(input - numbers)")
            
            if (input - numbers == 1111){
                print("Correct!")
                score += 1
                showHUDWithAnswer(isRight: true)
            } else {
                print("Incorrect!")
                score -= 1
                showHUDWithAnswer(isRight: false)
            }
            
        }
        
        setRandomNumberLabel()
        updateScoreLabel()
        
        // start the timer upon initial answer
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onUpdateTimer), userInfo: nil, repeats: true)
        }
    }
    
    func showHUDWithAnswer(isRight: Bool) {
        var imageView:UIImageView?
        
        if isRight {
            imageView = UIImageView(image: UIImage(named: "thumbs-up"))
        } else {
            imageView = UIImageView(image: UIImage(named: "thumbs-down"))
        }
        
        if imageView != nil {
            hud?.mode = MBProgressHUDMode.customView
            hud?.customView = imageView
            
            hud?.show(animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.hud?.hide(animated:true)
                self.inputField?.text = ""
            })
        }
    }
    
    @objc func onUpdateTimer() {
        if (seconds > 0 && seconds <= 60) {
            seconds -= 1
            updateTimeLabel()
        }
        else if (seconds == 0) {
            if (timer != nil) {
                timer!.invalidate()
                timer = nil
                
                let alertController = UIAlertController(title: "Time's Up!", message: "You got a score of \(score)", preferredStyle:.alert)
                
                let restartAction = UIAlertAction(title: "Restart", style: .default, handler: nil)
                alertController.addAction(restartAction)
                
                self.present(alertController, animated: true, completion: nil)
                
                score = 0
                seconds = 60
                
                updateTimeLabel()
                updateScoreLabel()
                setRandomNumberLabel()
                
            }
        }
    }
    
    func updateTimeLabel() {
        if timeLabel == nil {
            return
        }
        
        let min = (seconds / 60) % 60
        let sec = seconds % 60
        
        let min_p = String(format: "%02d", min)
        let sec_p = String(format: "%02d", sec)
        
        timeLabel?.text = "\(min_p):\(sec_p)"
    }
    
    func generateRandomString() -> String
    {
        var result:String = ""
        
        for _ in 1...4 {
            let digit = Int(arc4random_uniform(8) + 1)
    
            result += "\(digit)"
        }
    
        return result
    }

}
