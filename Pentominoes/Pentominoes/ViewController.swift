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


extension UIView {
    
    /// Flip view horizontally.
    func flipX() {
        transform = CGAffineTransform(scaleX: -transform.a, y: transform.d)
    }
    
    /// Flip view vertically.
    func flipY() {
        transform = CGAffineTransform(scaleX: transform.a, y: -transform.d)
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
        
    }

    @IBAction func changeboard(_ sender: UIButton) {
        mainBoard.image = UIImage(named: "Board" + String(sender.tag))
        currentBoard = sender.tag
    }
    
  
    
    @IBAction func solveButton(_ sender: Any) {
        if currentBoard == 0{
            return
        }
        let newSolution = model.allSolutions[currentBoard - 1]
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
        
            let newCenter = isMovingToMainBoard ? CGPoint(x: Double(xPosition) + Double(width)/2.0, y: Double(yPosition) + Double(height)/2.0) : originalPieceCenter
            /*
            let image = UIImage(named: "Piece"+pieceView.PieceName)
            let newImage = image?.rotate(CGFloat.pi/2.0)
            let newImageView = UIImageView(image: newImage)
            let newFrame =
            */
            
            
            UIView.animate(withDuration: 1.0, animations: { () -> Void in
                //pieceView.PieceImageView.frame.size.height = CGFloat(width)
                //pieceView.PieceImageView.frame.size.width = CGFloat(height)
                //let newImage = pieceView.PieceImageView.image?.rotate(CGFloat.pi/2.0)
                //pieceView.PieceImageView.image = newImage
//                for i in 0...newSolution[pieceView.PieceName]!.rotations{
//                    pieceView.PieceImageView.transform = CGAffineTransform(rotationAngle: (CGFloat.pi/2))
//                }
                //pieceView.PieceImageView
                
                if newSolution[pieceView.PieceName]!.isFlipped{
                    pieceView.PieceImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
                }
                pieceView.PieceImageView.transform = CGAffineTransform(rotationAngle: (CGFloat.pi / 2) * CGFloat(newSolution[pieceView.PieceName]!.rotations))
                print(pieceView.PieceName, (CGFloat.pi / 2) * CGFloat(newSolution[pieceView.PieceName]!.rotations))
                pieceView.PieceImageView.center = newCenter
            })
            
            
        }
 
        
    }
    func moveView(_ view:UIView, toSuperview superView: UIView) {
        let newCenter = superView.convert(view.center, from: view.superview)
        superView.superview?.bringSubviewToFront(superView)
        view.center = newCenter
        superView.addSubview(view)
    }
    
    @IBAction func resetButton(_ sender: Any) {
        let newSolution = model.allSolutions[currentBoard - 1]
        var newPiecePosition : Piece = piecePosition[0]
        for pieceView in pieceList{
            for i in piecePosition{
                if i.pieceName == pieceView.PieceName{
                    newPiecePosition = i
                    break;
                }
            }
            let xPosition = newPiecePosition.newX
            let yPosition = newPiecePosition.newY
            let width = Int(pieceView.PieceImageView.frame.size.width)
            let height = Int(pieceView.PieceImageView.frame.size.height)
            
            //MainView.bringSubviewToFront(pieceView.PieceImageView)
            
            self.moveView(pieceView.PieceImageView, toSuperview: self.mainBoard!)
            self.moveView(pieceView.PieceImageView, toSuperview: self.waitingBoard!)
            waitingBoard.bringSubviewToFront(pieceView.PieceImageView)
            let newCenter = CGPoint(x: Double(xPosition) + Double(width)/2.0, y: Double(yPosition) + Double(height)/2.0)
            
            UIView.animate(withDuration: 1.0, animations: { () -> Void in
                //pieceView.PieceImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
//                for i in 0...newSolution[pieceView.PieceName]!.rotations{
//                    pieceView.PieceImageView.transform = CGAffineTransform(rotationAngle: (-CGFloat.pi/2))
//                }
                pieceView.PieceImageView.transform = CGAffineTransform(rotationAngle: (CGFloat.pi / 2) * CGFloat(newSolution[pieceView.PieceName]!.rotations)).inverted()

//                if newSolution[pieceView.PieceName]!.isFlipped{
//                    pieceView.PieceImageView.flipX()
//                }
                if newSolution[pieceView.PieceName]!.isFlipped{
                    pieceView.PieceImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
                }
                pieceView.PieceImageView.center = newCenter
            })
            
            
            /*
            UIView.animate(withDuration: 1.0, animations: {
                pieceView.removeFromSuperview()
                self.waitingBoard.addSubview(pieceView.PieceImageView)
                pieceView.PieceImageView.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
            })
 */
        }
    }
    
    
}

