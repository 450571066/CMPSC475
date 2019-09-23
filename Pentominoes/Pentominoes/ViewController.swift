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
    var PieceName : String
    var rotateTimes: Int
    var isFlip: Bool
    
    convenience init(piece:String) {
        self.init(frame: CGRect.zero)
        let image = UIImage(named: "Piece" + piece)
        self.image = image
        PieceName = piece
        rotateTimes = 0
        isFlip = false
    }
    
    override init(frame: CGRect) {
        PieceName = ""
        rotateTimes = 0
        isFlip = false
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder:NSCoder) {
        PieceName = ""
        rotateTimes = 0
        isFlip = false
        super.init(coder: aDecoder)
    }
    
    func getRotate() -> Int{
        return rotateTimes
    }
    
    func getFlip() -> Bool{
        return isFlip
    }
    
    func RotatePlus(){
        if isFlip == false{
            self.rotateTimes = self.rotateTimes + 1
        }
        else{
            self.rotateTimes = self.rotateTimes + 3
        }
    }
    
    func flipNow(){
        self.isFlip = !self.isFlip
    }
    
    func resetRotate(){
        self.rotateTimes = 0
    }
    
    func resetFLip(){
        self.isFlip = false
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

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let kMoveScaleFactor : CGFloat = 1.2

    @IBOutlet var totalView: UIView!
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
            newPieceView.frame = CGRect(x: newPiece.newX, y: newPiece.newY, width: newPiece.newWidth, height: newPiece.newHeight)
            
            newPieceView.isUserInteractionEnabled = true
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.movePiece(_:)))
            newPieceView.addGestureRecognizer(panGesture)
            
            let rotateGesture = UITapGestureRecognizer(target: self, action: #selector(rotatePiece(_:)))
            newPieceView.addGestureRecognizer(rotateGesture)
            
             let flipGesture = UITapGestureRecognizer(target: self, action: #selector(flipPiece(_:)))
            flipGesture.numberOfTapsRequired = 2
            newPieceView.addGestureRecognizer(flipGesture)
            rotateGesture.require(toFail: flipGesture)
            
            waitingBoard.addSubview(newPieceView)
            pieceList.append(newPieceView)
            piecePosition.append(newPiece)
            count = count + 1
        
        }
        
        resetButton.isEnabled = false
        resetButton.setTitleColor(#colorLiteral(red: 0.4862745098, green: 0.4862745098, blue: 0.4862745098, alpha: 1), for: .normal)
        solveButton.isEnabled = false
        solveButton.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
        
        
    }
    
    @objc func rotatePiece(_ sender: UITapGestureRecognizer){
        let piece = sender.view as! pentominoView
        if piece.superview != waitingBoard{
            piece.RotatePlus()
            var transgender = piece.transform;
            transgender = transgender.rotated(by: (CGFloat.pi / 2))
            UIView.animate(withDuration: 1,animations: { () -> Void in
                piece.transform = transgender
            }, completion: {_ in})
        }
    }
    
    @objc func flipPiece(_ sender: UITapGestureRecognizer){
        let piece = sender.view as! pentominoView
        if piece.superview != waitingBoard{
            piece.flipNow()
            var transgender = piece.transform;
            transgender = transgender.scaledBy(x: -1.0, y: 1.0)
            UIView.animate(withDuration: 1,animations: { () -> Void in
                piece.transform = transgender
            }, completion: {_ in})
        }
        
    }
    
    @objc func movePiece(_ sender: UIGestureRecognizer) {
        let piece = sender.view as! pentominoView
        let height = piece.frame.height
        let width = piece.frame.width
        //let iniLocation = sender.location(in: waitingBoard)
        let iniLocationMain = sender.location(in: MainView)
        if (MainView.frame.contains(iniLocationMain)){
            switch sender.state {
            case .began:
                piece.transform.scaledBy(x: kMoveScaleFactor, y: kMoveScaleFactor)
                self.view.bringSubviewToFront(piece)
            case .changed:
                let location = sender.location(in: MainView)
                piece.center = location
            case .ended:
                piece.transform.scaledBy(x: 1, y: 1)
                var final = sender.location(in: self.MainView)
                let modX = Int(final.x)%30
                let modY = Int(final.y)%30
                var biasX: Int
                var biasY: Int
                if Int(width/30)%2 == 1{
                    biasX = 15
                }
                else{
                    biasX = 0
                }
                if Int(height/30)%2 == 1{
                    biasY = 15
                }
                else{
                    biasY = 0
                }
                if(modX >= 15){
                    final.x = final.x + 30 - CGFloat(modX) + CGFloat(biasX)
                }
                else{
                    final.x = final.x - CGFloat(modX) + CGFloat(biasX)
                }
                if(modY >= 15){
                    final.y = final.y + 30 - CGFloat(modY) + CGFloat(biasY)
                }
                else{
                    final.y = final.y - CGFloat(modY) + CGFloat(biasY)
                }
                if (mainBoard.frame.contains(final)){
                    piece.removeFromSuperview()
                    piece.center = final
                    MainView.addSubview(piece)
                    MainView.bringSubviewToFront(piece)
                }
                else{
                    var newPiecePosition : Piece = piecePosition[0]
                    for i in piecePosition{
                        if i.pieceName == piece.PieceName{
                            newPiecePosition = i
                            break;
                        }
                    }
                    let originalPieceCenter = CGPoint.init(x: Double(newPiecePosition.newX) + Double(newPiecePosition.newWidth)/2.0, y: Double(newPiecePosition.newY) + Double(newPiecePosition.newHeight)/2.0)
                    UIView.animate(withDuration: 1,animations: { () -> Void in
                        piece.center = originalPieceCenter
                    }, completion: {_ in})
                    
                    piece.removeFromSuperview()
                    waitingBoard.addSubview(piece)
                }
                
            default:
                break
            }
        }
        else{
            switch sender.state {
            case .began:
                piece.transform.scaledBy(x: kMoveScaleFactor, y: kMoveScaleFactor)
        
                self.view.bringSubviewToFront(piece)
            case .changed:
                if(mainBoard.frame.contains(sender.location(in: mainBoard))){
                    let location = sender.location(in: mainBoard)
                    piece.center = location
                }
                else{
                    let location = sender.location(in: waitingBoard)
                    piece.center = location
                }
                
            case .ended:
                piece.transform.scaledBy(x: 1, y: 1)
                var final = sender.location(in: self.MainView)
                let modX = Int(final.x)%30
                let modY = Int(final.y)%30
                var biasX: Int
                var biasY: Int
                if Int(width/30)%2 == 1{
                    biasX = 15
                }
                else{
                    biasX = 0
                }
                if Int(height/30)%2 == 1{
                    biasY = 15
                }
                else{
                    biasY = 0
                }
                if(modX >= 15){
                    final.x = final.x + 30 - CGFloat(modX) + CGFloat(biasX)
                }
                else{
                    final.x = final.x - CGFloat(modX) + CGFloat(biasX)
                }
                if(modY >= 15){
                    final.y = final.y + 30 - CGFloat(modY) + CGFloat(biasY)
                }
                else{
                    final.y = final.y - CGFloat(modY) + CGFloat(biasY)
                }
                if (mainBoard.frame.contains(final)){
                    piece.removeFromSuperview()
                    piece.center = final
                    MainView.addSubview(piece)
                    MainView.bringSubviewToFront(piece)
                }
                else{
                    var newPiecePosition : Piece = piecePosition[0]
                    for i in piecePosition{
                        if i.pieceName == piece.PieceName{
                            newPiecePosition = i
                            break;
                        }
                    }
                    let originalPieceCenter = CGPoint.init(x: Double(newPiecePosition.newX) + Double(newPiecePosition.newWidth)/2.0, y: Double(newPiecePosition.newY) + Double(newPiecePosition.newHeight)/2.0)
                    UIView.animate(withDuration: 1,animations: { () -> Void in
                        piece.center = originalPieceCenter
                    }, completion: {_ in})
                    piece.removeFromSuperview()
                    waitingBoard.addSubview(piece)
                }
                
            default:
                break
            }
        }
        
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
            let rotateTimes = pieceView.getRotate()
            let flipTimes = pieceView.getFlip()
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
            let width = Int(pieceView.frame.size.width)
            let height = Int(pieceView.frame.size.height)
            
            let isMovingToMainBoard = sender.tag == 0
            if isMovingToMainBoard {
                pieceView.resetFLip()
                pieceView.resetRotate()
            }
            
            let superView = isMovingToMainBoard ? self.MainView : self.waitingBoard
            
            self.moveView(pieceView, toSuperview: superView!)
        
            var transgender = pieceView.transform;
            let setRotate = newSolution[pieceView.PieceName]!.rotations
            var realRotate: Int
            if flipTimes{
                 realRotate = (4 - (rotateTimes%4) + setRotate) * 3
            }
            else{
                 realRotate = 4 - (rotateTimes%4) + setRotate
            }
            
            transgender = transgender.rotated(by: (CGFloat.pi / 2) * CGFloat(realRotate))
            
            var newCenter = isMovingToMainBoard ? CGPoint(x: Double(xPosition) + Double(width)/2.0, y: Double(yPosition) + Double(height)/2.0) : originalPieceCenter
            if Int(realRotate)%2 == 1{
                newCenter = isMovingToMainBoard ? CGPoint(x: Double(xPosition) + Double(height)/2.0, y: Double(yPosition) + Double(width)/2.0) : originalPieceCenter
            }
            let realFlip = (newSolution[pieceView.PieceName]!.isFlipped != flipTimes)
            if realFlip{
                transgender = transgender.scaledBy(x: -1.0, y: 1.0)
            }
            
            if !isMovingToMainBoard
            {
                transgender = CGAffineTransform.identity
            }
            UIView.animate(withDuration: 1, delay: TimeInterval(delay)/10,animations: { () -> Void in
                pieceView.transform = transgender
            }, completion: {_ in})
            UIView.animate(withDuration: 1,delay: TimeInterval(delay)/10, animations: {
                pieceView.center = newCenter
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
    
    


