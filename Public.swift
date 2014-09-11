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
let ANIMAL_POSITION_ARRAY:[Int] = [1,3,2,0,4];


enum WSPointState{
    case None
    case Sheep
    case Wolf
}
enum WSGameStage{
    case Ready
    case SheepTurn
    case SheepSelect
    case SheepMove
    case WolfTurn
    case WolfSelect
    case WolfMove
    case Suspend
    case End
}

//上
func judgeUp(number:Int) -> Bool {
    return number < 25;
}
func stepUp(number:Int) -> Int {
    return number+5;
}
//下
func judgeBottom(number:Int) -> Bool {
    return number > 4;
}
func stepBottom(number:Int) -> Int {
    return number-5;
}
//左
func judgeLeft(number:Int) -> Bool {
    return (number % 5 != 0);
}
func stepLeft(number:Int) -> Int {
    return number-1;
}
//右
func judgeRight(number:Int) -> Bool {
    return ((number+1) % 5 != 0);
}
func stepRight(number:Int) -> Int {
    return number + 1;
}
