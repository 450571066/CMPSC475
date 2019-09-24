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

    let newPiece = Piece()
    let model = PieceModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        HintImage.image = UIImage(named: "Board" + String(board!))
        var count = 0
        let newSolution = model.allSolutions[board! - 1]
        for i in model.allPiece{
            if count == number{
                break
            }
            let newPieceView = pentominoView(piece : i)
            let xPosition = newSolution[i]!.x * 30
            let yPosition = newSolution[i]!.y * 30
            let width = Int(newPieceView.image!.size.width)
            let height = Int(newPieceView.image!.size.height)
            //let setRotate = newSolution[i]!.rotations
            newPieceView.frame = CGRect(x:xPosition, y: yPosition, width:width, height: height)
            HintImage.addSubview(newPieceView)
            HintImage.bringSubviewToFront(newPieceView)
            
            var transformer = newPieceView.transform;
            let setRotate = newSolution[i]!.rotations
            let setFlip = newSolution[i]!.isFlipped
            transformer = transformer.rotated(by: (CGFloat.pi / 2) * CGFloat(setRotate))
            var newCenter = CGPoint(x: Double(xPosition) + Double(width)/2.0, y: Double(yPosition) + Double(height)/2.0)
            if Int(setRotate)%2 == 1{
                newCenter = CGPoint(x: Double(xPosition) + Double(height)/2.0, y: Double(yPosition) + Double(width)/2.0)
            }
            if setFlip{
                transformer = transformer.scaledBy(x: -1.0, y: 1.0)
            }
            newPieceView.transform = transformer
            newPieceView.center = newCenter
            
            count = count + 1
            
        }
    }
    var board: Int?
    var number: Int?
    var delegate: HintDelegate!
    
    func configure(with board: Int, number: Int){
        self.board = board
        self.number = number
        
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
