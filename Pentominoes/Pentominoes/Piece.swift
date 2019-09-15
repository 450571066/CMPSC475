//
//  Piece.swift
//  Pentominoes
//
//  Created by Tianqi Liu on 9/14/19.
//  Copyright © 2019 Tianqi Liu. All rights reserved.
//

import Foundation

class Piece{
    //var allPiece: [String]
    var newHeight: Int
    var newWidth: Int
    var newX: Int
    var newY: Int
    var imageName: String
    var pieceName: String
    init(){
        newWidth = 0
        newHeight = 0
        newX = 0
        newY = 0
        imageName = "Piece"
        pieceName = ""

    }
    
    func setPiece(piece:String, count:Int){
        let threeTimesThree = ["F","T","V","W","X","Z"]
        let fourTimesTwo = ["L","N","Y"]
        if threeTimesThree.contains(piece) {
            self.newWidth = 90
            self.newHeight = 90
        }
        if fourTimesTwo.contains(piece) {
            self.newWidth = 60
            self.newHeight = 120
        }
        if piece == "P"{
            self.newWidth = 60
            self.newHeight = 90
        }
        if piece == "U"{
            self.newWidth = 90
            self.newHeight = 60
        }
        if piece == "I"{
            self.newWidth = 30
            self.newHeight = 150
        }
        self.newX = 30 + (count%6) * 120
        self.newY = 30 + (count/6) * 180
        self.imageName = "Piece" + piece
        self.pieceName = piece
    }
}

