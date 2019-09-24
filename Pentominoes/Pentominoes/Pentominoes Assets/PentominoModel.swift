//
//  Model.swift
//  Pentominoes
//
//  Created by John Hannan on 8/28/18.
//  Copyright (c) 2018 John Hannan. All rights reserved.
//

import Foundation
import UIKit

// identifies placement of a single pentomino on a board
struct Position : Codable {
    var x : Int
    var y : Int
    var isFlipped : Bool
    var rotations : Int
}

// A solution is a dictionary mapping piece names ("T", "F", etc) to positions
// All solutions are read in and maintained in an array
typealias Solution = [String:Position]
typealias Solutions = [Solution]

class PieceModel {
    let allPiece = ["X","V","N","T","U","Y","L","I","F","P","W","Z"]

    let allSolutions : Solutions //[[String:[String:Int]]]
    init () {
        let mainBundle = Bundle.main
        let solutionURL = mainBundle.url(forResource: "Solutions", withExtension: "plist")
        
        do {
            let data = try Data(contentsOf: solutionURL!)
            let decoder = PropertyListDecoder()
            allSolutions = try decoder.decode(Solutions.self, from: data)
        } catch {
            print(error)
            allSolutions = []
        }
    }
    

}


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


