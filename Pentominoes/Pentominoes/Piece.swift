//
//  Piece.swift
//  Pentominoes
//
//  Created by Tianqi Liu on 9/14/19.
//  Copyright © 2019 Tianqi Liu. All rights reserved.
//

import Foundation
import UIKit

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
        let image = UIImage(named: "Piece" + piece)
        newHeight = Int(image!.size.height)
        newWidth = Int(image!.size.width)
        
        self.newX = 30 + (count%6) * 120
        self.newY = 30 + (count/6) * 180
        self.imageName = "Piece" + piece
        self.pieceName = piece
    }
}

