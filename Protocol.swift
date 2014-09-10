//
//  Protocol.swift
//  Wolf&Sheep
//
//  Created by 张宏台 on 14-9-4.
//  Copyright (c) 2014年 张宏台. All rights reserved.
//
import SpriteKit


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
    func selectAnimal(sprite:SKSpriteNode,spriteType:WSPointState,index:Int);
    func selectBlank(cubeNumber:Int);
    func switchTurn();

}

protocol WSGameDelegate{
    func gameDisplay(text:String);
}

class WolfSheepGame:WSGame {
    var delegate:WSGameDelegate?;
    var board:[WSPoint];
    var sheep:[WSSheep];
    var wolf:[WSWolf];
    var gameStage:WSGameStage;
    var selectedAnimal:Int;
    init(){
        var initPoint = WSPoint(pointState:.None,count:0);
        board = [WSPoint](count:BOARD_COLUMNS*BOARD_ROWS,repeatedValue:initPoint);
        var initSheep = WSSheep(cubeNumber:0,sprite:SKSpriteNode());
        sheep = [WSSheep](count:SHEEP_GROUP*3,repeatedValue:initSheep);
        var  initWolf = WSWolf(cubeNumber:BOARD_COLUMNS*BOARD_ROWS-1,sprite:SKSpriteNode());
        wolf = [WSWolf](count:WOLF_NUMBER,repeatedValue:initWolf);
        gameStage = .Ready
        selectedAnimal = -1;
    }

    func play(){
        //开始游戏，标题标签显示“游戏开始”,游戏进入初始化状态。
        delegate.gameDisplay("游戏开始，请小羊移动");
        gameStage = .SheepTurn;
        selectedAnimal = -1;

    }
    //选中了羊或者狼，设置状态和显示选中状态
    //如果已经选中了狼，本次选中了一只羊，则进行判断是否能吃掉该羊
    //如果已经选中了羊，本次选中了一只狼，则进行提示：羊无法吃狼
    func selectAnimal(sprite:SKSpriteNode,spriteType:WSPointState,index:Int){
        switch gameStage{
            case .SheepTurn:
                if(spriteType == .Sheep){
                    delegate.selectSprite(sprite);
                    selectedAnimal = index;
                    gameStage = .SheepSelect;
                }
            case .SheepSelect:
                if(spriteType == .Sheep){
                    if(index == selectedAnimal){
                        delegate.unselectSprite(sprite);
                    }
                    else{
                        delegate.selectSprite(sprite);
                    }
                }else if(spriteType == .Wolf){
                    delegate.gameDisplay("小羊是吃不了大灰狼的哦!");
                }else{
                    println("sprite类型异常")
                }
            case .WolfTurn:
                if(spriteType == .Wolf){
                    delegate.selectSprite(sprite);
                    selectedAnimal = index;
                    gameStage = .WolfSelect;
                }
            case .WolfSelect:
                if(spriteType == .Sheep){
                    if(validMove(wolf[selectedAnimal].cubeNumber,sheep[index].cubeNumber)){
                        //开始移动sprite的动画
                    }
                }else if(spriteType == .Wolf){
                    if(index == selectedAnimal){
                        delegate.unselectSprite(sprite);
                    }
                    else{
                        delegate.selectSprite(sprite);
                    }
                }else{
                    println("sprite类型异常")
                }
            default:
                    println("stage异常，当前状态为\(gameStage)");

        }
    }
    //点击的是背景图片，根据当前状态决定动物移动，或给出提示信息
    func selectBlank(cubeNumber:Int){

    }
    //在动物移动完毕后，调用该方法，判断游戏是否结束。
    func switchTurn(){

    }
    //内部方法
    function validMove(start:Int,end:Int) -> Bool{
        var up:Int;
        if(start <25){
            up = start+5;
            if(end == up){
                if(board[start].pointState == .Wolf){
                    if(board[end].pointState == .Sheep){
                        if(up < 25){
                            var upup = up + 5;
                            if(board[upup].pointState == .Sheep)
                            {
                                delegate.gameDisplay("大灰狼不能一口吃掉两只小羊!");
                            }else if(board[upup].pointState == .None){
                                return true;
                            }else{
                                delegate.gameDisplay("落脚地已经被另一头狼占据!");
                            }
                        }else{
                            delegate.gameDisplay("场地空间不允许狼吃小羊");
                        }
                    }else if(board[end].pointState == .None){
                        return true;
                    }else{
                            delegate.gameDisplay("前面是一头狼");
                    }
                }else if(board[start].pointState == .Sheep){
                    if(board[end].pointState == .Sheep){
                         delegate.gameDisplay("前面是另一只小羊");
                    }else if(board[end].pointState == .None){
                        return true;
                    }else{
                        delegate.gameDisplay("小羊不能吃掉一头狼");
                    }
                }else{
                    println("start point have no animal");
                }
            }
        }
        var bottom:Int;
        
        var left:Int;
        
        var right:Int;
        
        return false;
    }
}