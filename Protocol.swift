//
//  Protocol.swift
//  Wolf&Sheep
//
//  Created by 张宏台 on 14-9-4.
//  Copyright (c) 2014年 张宏台. All rights reserved.
//



struct WSPoint {
    var pointState:WSPointState;
    var count:Int;
}

struct WSSheep {
    var cubeNumber:Int;
    var sprite:SKSpriteNode;
}

struct WSWolf {
    var cubeNumber:Int;
    var sprite:SKSpriteNode;
}

protocol WSGame{
    func play();
}

protocol WSGameDelegate{
    func gameStart(game:WSGame);
}

class WolfSheepGame:WSGame {
    var delegate:WSGameDelegate?;
    var board:[WSPoint];
    var sheep:[WSSheep];
    var wolf:[WSWolf];

    init(){
        var initPoint = WSPoint(pointState:.None,count:0);
        board = [WSPoint](count:BOARD_COLUMNS*BOARD_ROWS,repeatedValue:initPoint);
        var initSheep = WSSheep(cubeNumber:0,sprite:SKSpriteNode());
        sheep = [WSSheep](count:SHEEP_GROUP*3,repeatedValue:initSheep);
        var  initWolf = WSWolf(cubeNumber:BOARD_COLUMNS*BOARD_ROWS-1,sprite:SKSpriteNode()));
        wolf = [WSWolf](count:WOLF_NUMBER,repeatedValue:initWolf);
    }

    func play(){
    }
}