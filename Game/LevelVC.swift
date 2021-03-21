//
//  LevelVC.swift
//  Game
//
//  Created by Bhumika Amesar on 20/05/20.
//  Copyright © 2020 Bhumika Amesar. All rights reserved.
//

import UIKit

class LevelVC: UIViewController {

    var tagNumber : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func onClick_btnLevel(_ sender: UIButton)
    {
        //let gameVC = GameVC()
        //let gameVC = storyboard?.instantiateViewController(withIdentifier: "GameVC") as! GameVC
        //gameVC.level = sender.tag
        //performSegue(withIdentifier: "goToGame", sender: self)
        //navigationController?.pushViewController(gameVC, animated: true)
        tagNumber = sender.tag
        self.performSegue(withIdentifier: "goToGame", sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let gameVC : GameVC = segue.destination as! GameVC
        gameVC.level = tagNumber
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
