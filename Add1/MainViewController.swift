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
    
    var score = 0
    
    var hud:MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hud = MBProgressHUD(view:self.view)
        if hud != nil {
            self.view.addSubview(hud!)
        }
        
        setRandomNumberLabel()
        updateScoreLabel()

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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.hud?.hide(animated:true)
                self.inputField?.text = ""
            })
        }
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
