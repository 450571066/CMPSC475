//
//  ViewController.swift
//  Pentominoes
//
//  Created by Tianqi Liu on 9/13/19.
//  Copyright © 2019 Tianqi Liu. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let newPiece = Piece()
    let model = PieceModel()
    var pieceList : [pentominoView] = []
    var piecePosition : [Piece] = []
    var currentBoard: Int = 0
    
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
            
            //Gesture
            newPieceView.isUserInteractionEnabled = true
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.MovePiece(_:)))
            newPieceView.addGestureRecognizer(panGesture)
            
            let rotateGesture = UITapGestureRecognizer(target: self, action: #selector(RotatePiece(_:)))
            newPieceView.addGestureRecognizer(rotateGesture)
            
             let flipGesture = UITapGestureRecognizer(target: self, action: #selector(FlipPiece(_:)))
            flipGesture.numberOfTapsRequired = 2
            newPieceView.addGestureRecognizer(flipGesture)
            rotateGesture.require(toFail: flipGesture)
            
            waitingBoard.addSubview(newPieceView)
            pieceList.append(newPieceView)
            piecePosition.append(newPiece)
            count = count + 1
        
        }
        resetButton.isEnabled = false
        solveButton.isEnabled = false
        
        solveButton.setTitleColor(#colorLiteral(red: 0, green: 0.4797514677, blue: 0.9984372258, alpha: 1), for: .normal)
        resetButton.setTitleColor(#colorLiteral(red: 0, green: 0.4797514677, blue: 0.9984372258, alpha: 1), for: .normal)
        resetButton.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .disabled)
        solveButton.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .disabled)
    }
    
    @objc func RotatePiece(_ sender: UITapGestureRecognizer){
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
    
    @objc func FlipPiece(_ sender: UITapGestureRecognizer){
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
    
    @objc func MovePiece(_ sender: UIGestureRecognizer) {
        let piece = sender.view as! pentominoView
        let superview = piece.superview
        let height = piece.frame.height
        let width = piece.frame.width
        totalView.bringSubviewToFront(waitingBoard)
        switch sender.state {
        case .began:
            piece.transform = piece.transform.scaledBy(x: kMoveScaleFactor, y: kMoveScaleFactor)
            self.view.bringSubviewToFront(piece)
        case .changed:
            let location = sender.location(in: superview)
            piece.center = location
        case .ended:
            piece.transform = piece.transform.scaledBy(x: (1/kMoveScaleFactor), y: (1/kMoveScaleFactor))
            var final = sender.location(in: self.MainView)
            final = pointFilter(current: final, height: height, width: width)
            if (mainBoard.frame.contains(final)){
                
                self.MoveView(piece, toSuperview: MainView!)
                MainView.bringSubviewToFront(piece)
                UIView.animate(withDuration: 0.3,animations: { () -> Void in
                    piece.center = final
                }, completion: {_ in})
                
                
            }
            else{
                self.MoveView(piece, toSuperview: waitingBoard!)
                waitingBoard.bringSubviewToFront(piece)
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
            }
        default:
            break
        }
    }
    
    @IBAction func changeboard(_ sender: UIButton) {
        mainBoard.image = UIImage(named: "Board" + String(sender.tag))
        currentBoard = sender.tag
        if currentBoard == 0{
            solveButton.isEnabled = false
        }
        if currentBoard != 0{
            solveButton.isEnabled = true
        }
    }
    
    @IBAction func SolveButton(_ sender: UIButton) {
        let newSolution = model.allSolutions[currentBoard - 1]
        var delay = 0
        for pieceView in pieceList{
            let rotateTimes = pieceView.getRotate()
            let flipTimes = pieceView.getFlip()

            let xPosition = newSolution[pieceView.PieceName]!.x * 30
            let yPosition = newSolution[pieceView.PieceName]!.y * 30
            let width = Int(pieceView.frame.size.width)
            let height = Int(pieceView.frame.size.height)
            
            
            pieceView.resetFLip()
            pieceView.resetRotate()
           
            
            let superView = self.MainView
            
            self.MoveView(pieceView, toSuperview: superView!)
            
            var transformer = pieceView.transform;
            let setRotate = newSolution[pieceView.PieceName]!.rotations
            var realRotate: Int
            if flipTimes{
                realRotate = (4 - (rotateTimes%4) + setRotate) * 3
            }
            else{
                realRotate = 4 - (rotateTimes%4) + setRotate
            }
            
            transformer = transformer.rotated(by: (CGFloat.pi / 2) * CGFloat(realRotate))
            
            var newCenter = CGPoint(x: Double(xPosition) + Double(width)/2.0, y: Double(yPosition) + Double(height)/2.0)
            if Int(realRotate)%2 == 1{
                newCenter = CGPoint(x: Double(xPosition) + Double(height)/2.0, y: Double(yPosition) + Double(width)/2.0)
            }
            let realFlip = (newSolution[pieceView.PieceName]!.isFlipped != flipTimes)
            if realFlip{
                transformer = transformer.scaledBy(x: -1.0, y: 1.0)
            }
            
            UIView.animate(withDuration: 1, delay: TimeInterval(delay)/10,animations: { () -> Void in
                pieceView.transform = transformer
            }, completion: {_ in})
            UIView.animate(withDuration: 1,delay: TimeInterval(delay)/10, animations: {
                pieceView.center = newCenter
            })
            delay = delay + 1
        }
        
            for i in Buttons{
                i.isEnabled = false
            }
            solveButton.isEnabled = false
            resetButton.isEnabled = true
        
    }
    
    
    @IBAction func ResetButton(_ sender: UIButton) {
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
        
            
            let superView = self.waitingBoard
            self.MoveView(pieceView, toSuperview: superView!)
            var transformer = pieceView.transform
            let newCenter = originalPieceCenter
            transformer = CGAffineTransform.identity
            
            UIView.animate(withDuration: 1, delay: TimeInterval(delay)/10,animations: { () -> Void in
                pieceView.transform = transformer
            }, completion: {_ in})
            UIView.animate(withDuration: 1,delay: TimeInterval(delay)/10, animations: {
                pieceView.center = newCenter
            })
            delay = delay + 1
        }

        for i in Buttons{
            i.isEnabled = true
        }
        resetButton.isEnabled = false
        solveButton.isEnabled = true
    }
    
    func MoveView(_ view:UIView, toSuperview superView: UIView) {
        let newCenter = superView.convert(view.center, from: view.superview)
        superView.superview?.bringSubviewToFront(superView)
        view.center = newCenter
        superView.addSubview(view)
    }
    
    @IBAction func dismissHintView(_ segue: UIStoryboardSegue){
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "HintSegue":
            let hintViewController = segue.destination as! HintViewController
            hintViewController.configure(with: currentBoard)
            hintViewController.delegate = self as? HintDelegate
        default:
            break
        }
    }
    
    func dismissHint(){
        self.dismiss(animated: true, completion: nil)
    }
}
