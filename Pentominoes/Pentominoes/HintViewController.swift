//
//  HintViewController.swift
//  Pentominoes
//
//  Created by Tianqi Liu on 9/24/19.
//  Copyright © 2019 Tianqi Liu. All rights reserved.
//

import UIKit

protocol HintDelegate {
    func dismissHint()
}

class HintViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        HintImage.image = UIImage(named: "Board" + String(board!))
    }
    var board: Int?
    var num: Int?
    var delegate: HintDelegate!
    
    func configure(with board: Int){
        self.board = board
        //self.num = num
        
    }
    
    @IBOutlet weak var HintImage: UIImageView!

    @IBAction func OKButton(_ sender: UIButton) {
        if let _delegate = delegate{
            _delegate.dismissHint()
        }
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
