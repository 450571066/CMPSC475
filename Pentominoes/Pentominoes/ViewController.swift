//
//  ViewController.swift
//  Pentominoes
//
//  Created by Tianqi Liu on 9/13/19.
//  Copyright © 2019 Tianqi Liu. All rights reserved.
//

import UIKit

let newPiece = Piece()
let model = Model()
var pieceList : [pentominoView] = []
var piecePosition : [Piece] = []
var currentBoard: Int = 0


class pentominoView : UIImageView {
    let PieceImageView : UIImageView
    var PieceName : String
    
    convenience init(piece:String) {
        self.init(frame: CGRect.zero)
        let image = UIImage(named: "Piece" + piece)
        PieceImageView.image = image
        PieceName = piece
    }
    
    override init(frame: CGRect) {
        PieceImageView = UIImageView(frame:frame)
        PieceName = ""
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder:NSCoder) {
        PieceImageView = UIImageView(frame:CGRect.zero)
        PieceName = ""
        super.init(coder: aDecoder)
    }
    
}



extension UIImage {
    
    
    func rotate(_ radians: CGFloat) -> UIImage {
        let cgImage = self.cgImage!
        let LARGEST_SIZE = CGFloat(max(self.size.width, self.size.height))
        let context = CGContext.init(data: nil, width:Int(LARGEST_SIZE), height:Int(LARGEST_SIZE), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: cgImage.colorSpace!, bitmapInfo: cgImage.bitmapInfo.rawValue)!
        
        var drawRect = CGRect.zero
        drawRect.size = self.size
        let drawOrigin = CGPoint(x: (LARGEST_SIZE - self.size.width) * 0.5,y: (LARGEST_SIZE - self.size.height) * 0.5)
        drawRect.origin = drawOrigin
        var tf = CGAffineTransform.identity
        tf = tf.translatedBy(x: LARGEST_SIZE * 0.5, y: LARGEST_SIZE * 0.5)
        tf = tf.rotated(by: CGFloat(radians))
        tf = tf.translatedBy(x: LARGEST_SIZE * -0.5, y: LARGEST_SIZE * -0.5)
        context.concatenate(tf)
        context.draw(cgImage, in: drawRect)
        var rotatedImage = context.makeImage()!
        
        drawRect = drawRect.applying(tf)
        
        rotatedImage = rotatedImage.cropping(to: drawRect)!
        let resultImage = UIImage(cgImage: rotatedImage)
        return resultImage
    }
}

class ViewController: UIViewController {
    

    @IBOutlet weak var solveButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var mainBoard: UIImageView!
    @IBOutlet weak var waitingBoard: UIView!
    @IBOutlet var Buttons: [UIButton]!
    @IBOutlet weak var MainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var count = 0
        
        for i in model.allPiece{
            let newPiece = Piece()
            newPiece.setPiece(piece: i, count: count)
            let newPieceView = pentominoView(piece : i)
            newPieceView.PieceImageView.frame = CGRect(x: newPiece.newX, y: newPiece.newY, width: newPiece.newWidth, height: newPiece.newHeight)
            waitingBoard.addSubview(newPieceView.PieceImageView)
            pieceList.append(newPieceView)
            piecePosition.append(newPiece)
            count = count + 1
        }
        resetButton.isEnabled = false
        resetButton.setTitleColor(#colorLiteral(red: 0.4862745098, green: 0.4862745098, blue: 0.4862745098, alpha: 1), for: .normal)
        solveButton.isEnabled = false
        solveButton.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
        
    }
    
    

    @IBAction func changeboard(_ sender: UIButton) {
        mainBoard.image = UIImage(named: "Board" + String(sender.tag))
        currentBoard = sender.tag
        if currentBoard == 0{
            solveButton.isEnabled = false
            solveButton.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
        }
        if currentBoard != 0{
            solveButton.isEnabled = true
            solveButton.setTitleColor(#colorLiteral(red: 0, green: 0.4797514677, blue: 0.9984372258, alpha: 1), for: .normal)
        }
    }
    
  
    @IBAction func solveResetButton(_ sender: UIButton) {
    
        
        if currentBoard == 0{
            return
        }
        let newSolution = model.allSolutions[currentBoard - 1]
        var delay = 0
        for pieceView in pieceList{
            
            var newPiecePosition : Piece = piecePosition[0]
            for i in piecePosition{
                if i.pieceName == pieceView.PieceName{
                    newPiecePosition = i
                    break;
                }
            }
            let originalPieceCenter = CGPoint.init(x: Double(newPiecePosition.newX) + Double(newPiecePosition.newWidth)/2.0, y: Double(newPiecePosition.newY) + Double(newPiecePosition.newHeight)/2.0)
            let xPosition = newSolution[pieceView.PieceName]!.x * 30
            let yPosition = newSolution[pieceView.PieceName]!.y * 30
            let width = Int(pieceView.PieceImageView.frame.size.width)
            let height = Int(pieceView.PieceImageView.frame.size.height)
                
            let isMovingToMainBoard = pieceView.PieceImageView.superview == self.waitingBoard
            let superView = isMovingToMainBoard ? self.MainView : self.waitingBoard
            
            self.moveView(pieceView.PieceImageView, toSuperview: superView!)
        
            var transgender = pieceView.PieceImageView.transform;
            transgender = transgender.rotated(by: (CGFloat.pi / 2) * CGFloat(newSolution[pieceView.PieceName]!.rotations))
            
            var newCenter = isMovingToMainBoard ? CGPoint(x: Double(xPosition) + Double(width)/2.0, y: Double(yPosition) + Double(height)/2.0) : originalPieceCenter
            if Int(newSolution[pieceView.PieceName]!.rotations)%2 == 1{
                newCenter = isMovingToMainBoard ? CGPoint(x: Double(xPosition) + Double(height)/2.0, y: Double(yPosition) + Double(width)/2.0) : originalPieceCenter
            }
        
            if newSolution[pieceView.PieceName]!.isFlipped{
                transgender = transgender.scaledBy(x: -1.0, y: 1.0)
            }
            
            if !isMovingToMainBoard
            {
                transgender = CGAffineTransform.identity
            }
            UIView.animate(withDuration: 1, delay: TimeInterval(delay)/10,animations: { () -> Void in
                pieceView.PieceImageView.transform = transgender
            }, completion: {_ in})
            UIView.animate(withDuration: 1,delay: TimeInterval(delay)/10, animations: {
                pieceView.PieceImageView.center = newCenter
            })
            delay = delay + 1
        }
        if sender.tag == 0{
            for i in Buttons{
                i.isEnabled = false
            }
            solveButton.isEnabled = false
            solveButton.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
            resetButton.isEnabled = true
            resetButton.setTitleColor(#colorLiteral(red: 0, green: 0.4797514677, blue: 0.9984372258, alpha: 1), for: .normal)
        }
        else{
            for i in Buttons{
                i.isEnabled = true
            }
            resetButton.isEnabled = false
            resetButton.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
            solveButton.isEnabled = true
            solveButton.setTitleColor(#colorLiteral(red: 0, green: 0.4797514677, blue: 0.9984372258, alpha: 1), for: .normal)
        }
 
        
    }
    func moveView(_ view:UIView, toSuperview superView: UIView) {
        let newCenter = superView.convert(view.center, from: view.superview)
        superView.superview?.bringSubviewToFront(superView)
        view.center = newCenter
        superView.addSubview(view)
    }
    
}
    
    


