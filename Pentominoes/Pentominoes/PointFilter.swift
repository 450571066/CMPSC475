//
//  PointFilter.swift
//  Pentominoes
//
//  Created by Tianqi Liu on 9/22/19.
//  Copyright © 2019 Tianqi Liu. All rights reserved.
//

import Foundation
import UIKit

func pointFilter(current:CGPoint, height:CGFloat, width: CGFloat) -> CGPoint{
    var final = current
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
    return final
}
