//
//  Public.swift
//  Wolf&Sheep
//
//  Created by 张宏台 on 14-9-2.
//  Copyright (c) 2014年 张宏台. All rights reserved.
//

import Foundation
import UIKit
let BOARD_COLUMNS = 5;
let BOARD_ROWS = 6;
let SHEEP_GROUP:Int = 3;
let WOLF_NUMBER:Int = 2;
let ANIMAL_POSITION_ARRAY:[CGFloat] = [2,4,3,1,5];


enum WSPointState{
    case None
    case Sheep
    case Wolf
}
