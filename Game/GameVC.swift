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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setRandomNumberLabel()
        updateScoreLabel()
        print(level)
        txtAnswer.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        checkLevel()
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkLevel()
    {
        if(level == 1)
        {
            lblTime.text = "Time\n120"
            seconds = 120
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
                txtAnswer.text = ""
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
                txtAnswer.text = ""
            }
        }
        setRandomNumberLabel()
        updateScoreLabel()
        
        if(timer == nil)
        {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onUpdateTimer), userInfo: nil, repeats: true)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let aSet = NSCharacterSet(charactersIn : "23456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
        
    }
    
    func onUpdateTimer() -> Void
    {
        //if(seconds > 0 && seconds <= 60)
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
                
                /*score = 0
                //seconds = 60
                imgCheckAns.image = nil
                txtAnswer.text = ""
                updateScoreLabel()
                setRandomNumberLabel()*/
            }
        }
    }
    
    func updateTimeLabel()
    {
        if(lblTime != nil)
        {
            let sec : Int = seconds % 30
            lblTime.text = "Time\n\(sec)"
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
