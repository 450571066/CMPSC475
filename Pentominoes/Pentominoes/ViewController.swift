//
//  ViewController.swift
//  Pentominoes
//
//  Created by Tianqi Liu on 9/13/19.
//  Copyright © 2019 Tianqi Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var mainBoard: UIImageView!
    @IBAction func Button_1(_ sender: Any) {
        mainBoard.image = UIImage(named: "Board0")
    }
    
    @IBAction func Button_2(_ sender: Any) {
        mainBoard.image = UIImage(named: "Board1")
    }
    
    @IBAction func Button_3(_ sender: Any) {
        mainBoard.image = UIImage(named: "Board2")
    }
    
    @IBAction func Button_4(_ sender: Any) {
        mainBoard.image = UIImage(named: "Board3")
    }
    
    @IBAction func Button_5(_ sender: Any) {
        mainBoard.image = UIImage(named: "Board4")
    }
    
    @IBAction func Button_6(_ sender: Any) {
        mainBoard.image = UIImage(named: "Board5")
    }
}

