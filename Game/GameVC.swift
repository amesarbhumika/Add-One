//
//  GameVC.swift
//  Game
//
//  Created by Bhumika Amesar on 13/04/20.
//  Copyright © 2020 Bhumika Amesar. All rights reserved.
//

import UIKit

class GameVC: UIViewController, UITextFieldDelegate
{

    	//MARK: - VARIABLES AND OUTLETS
    
    	var score : Int = 0
    	var seconds : Int = 0
    	var timer : Timer?
    	var level: Int = 0
    
    	@IBOutlet weak var lblScore: UILabel!
   	    @IBOutlet weak var lblTime: UILabel!
    	@IBOutlet weak var lblQuestion: UILabel!
    	@IBOutlet weak var txtAnswer: UITextField!
    	@IBOutlet weak var imgCheckAns: UIImageView!
    
        //MARK: - VC LIFE CYCLE

    	override func viewDidLoad()
    	{
        		super.viewDidLoad()
        
        		// Do any additional setup after loading the view.
        
        		setRandomNumberLabel()
        		updateScoreLabel()
        		print(level)
        		txtAnswer.delegate = self
    	}
    
        override func viewWillAppear(_ animated: Bool) 
        {
        		super.viewWillAppear(false)
        		checkLevel()
        }
    
        //MARK: - FUNCTION METHODS

    	func checkLevel()
    	{
        		if(level == 1)
        		{
            		lblTime.text = "Time\n90"
            		seconds = 90
        		}
        		else if(level == 2)
        		{
            		lblTime.text = "Time\n60"
            		seconds = 60
        		}
        		else
        		{
            		lblTime.text = "Time\n30"
            		seconds = 30
        		}

    	}
    	
        func setRandomNumberLabel()
    	{
        		lblQuestion?.text = generateRandomString()
    	}
    
    	func generateRandomString() -> String
    	{
        		var result : String = ""
        
        		for _ in 1...4
        		{
            		let digit : Int = Int(arc4random_uniform(8) + 1)
            		result += "\(digit)"
        		}
        		return result
    	}
    
    	func updateScoreLabel()
    	{
        		lblScore?.text = "Score\n\(score)"
    	}
    
        //MARK: - ACTION METHODS

    	@IBAction private func textFieldDidChange(textField: UITextField)
    	{
        		if txtAnswer.text?.characters.count != 4
        		{
            		return
        		}
        
       		if let numbers_text = lblQuestion?.text,
            	let input_text = txtAnswer?.text,
            	let numbers = Int(numbers_text),
            	let input = Int(input_text)
        		{
            		if(input - numbers == 1111)
            		{
                			imgCheckAns.image = UIImage(named: "right")
                                		score += 1
            		}
            	else
            	{
                		if(score == 0)
                		{
                    			score = 0
                		}
                		else if(level == 2)
                		{
                    			score -= 1
                		}
                		else if(level == 3 && score >= 2)
                		{
                    			score -= 2
                		}
                		imgCheckAns.image = UIImage(named: "wrong")
            	}
        	}
        	

/* This deletes the previous answer entered by the player after the question is changed, so that the player can enter another answer to the new question that appears. 
   Why are we adding it to the queue? Because if we will delete the answer as soon as the question changes, we won’t be able to see the fourth digit entered by us on the screen. 
   So, we are deleting the answer after 3 seconds of delay. */

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3)
        	{
            	self.txtAnswer.text = ""
            	self.imgCheckAns.image = nil
        	}
        
        	setRandomNumberLabel()
        	updateScoreLabel()
        
        	if(timer == nil)
        	{
            	timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onUpdateTimer), userInfo: nil, repeats: true)
        	}
    }
    
//This method will restrict player from entering the alphabets.

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let aSet = NSCharacterSet(charactersIn : "23456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
        
    }
    
    func onUpdateTimer() -> Void
    {
        if(seconds > 0)
        {
            seconds -= 1
            updateTimeLabel()
        }
        else if(seconds == 0)
        {
            if(timer != nil)
            {
                timer!.invalidate()
                timer = nil
                
                let alert = UIAlertController(title: "Time Up!", message: "", preferredStyle: .alert)
                let messageFont = [NSFontAttributeName : UIFont.systemFont(ofSize: 18.0)]
                let messageAttrString = NSMutableAttributedString(string : "Score:\(score)" , attributes : messageFont)
                alert.setValue(messageAttrString, forKey: "attributedMessage")
                alert.addAction(UIAlertAction(title:"Restart", style: .default, handler: { _ in
                    self.checkLevel()
                    self.score = 0
                    self.imgCheckAns.image = nil
                    self.txtAnswer.text = ""
                    self.updateScoreLabel()
                    self.setRandomNumberLabel()
                }))     
                self.present(alert , animated: true , completion: nil)
            }
        }
    }
    
    func updateTimeLabel()
    {
        if(lblTime != nil)
        {
            var sec : Int
            if(level == 1)
            {
                sec = seconds % 90
            }
            else if(level == 2)
            {
                sec = seconds % 60
            }
            else
            {
                sec = seconds % 30
            }
            
            lblTime.text = "Time\n\(sec)"
        }
    }
}
