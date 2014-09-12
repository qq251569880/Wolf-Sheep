//
//  Protocol.swift
//  Wolf&Sheep
//
//  Created by 张宏台 on 14-9-4.
//  Copyright (c) 2014年 张宏台. All rights reserved.
//
import SpriteKit


struct WSPoint {
    var pointState:WSPointState{
        didSet {
            if pointState == .None {
                count = 0;
            }
        }
    }
    var count:Int{
        didSet {
            if count == 0 {
                pointState = .None;
                
            }
        }
    }
    var position:CGPoint;
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

    func initSprite();
    func gameDisplay(text:String);
    func selectSprite(sprite:SKSpriteNode);
    func unselectSprite(sprite:SKSpriteNode);
    func moveSprite(sprite:SKSpriteNode,start:Int,end:Int,eatenSheep:SKSpriteNode?);
    func gameOver(winner:String);
}

class WolfSheepGame:WSGame {
    var delegate:WSGameDelegate?;
    var board:[WSPoint];
    var sheep:[WSSheep];
    var wolf:[WSWolf];
    var gameStage:WSGameStage;
    var selectedAnimal:Int;
    init(){
        var initPoint = WSPoint(pointState:.None,count:0,position:CGPointMake(0,0));
        board = [WSPoint](count:BOARD_COLUMNS*BOARD_ROWS,repeatedValue:initPoint);
        var initSheep = WSSheep(cubeNumber:0,sprite:SKSpriteNode());
        sheep = [WSSheep](count:SHEEP_GROUP*3,repeatedValue:initSheep);
        var  initWolf = WSWolf(cubeNumber:BOARD_COLUMNS*BOARD_ROWS-1,sprite:SKSpriteNode());
        wolf = [WSWolf](count:WOLF_NUMBER,repeatedValue:initWolf);
        gameStage = .Ready
        selectedAnimal = -1;
    }
    func setPointPosition(origin:CGPoint,size:CGSize){
        println(origin)
        for(var i:Int = 0;i < BOARD_COLUMNS*BOARD_ROWS;i++){
            var x = i % 5 ;
            var y = i / 5 ;
            var px:CGFloat = origin.x + (size.width/CGFloat(BOARD_COLUMNS))*CGFloat(x);
            var py:CGFloat = origin.y + (size.height/CGFloat(BOARD_ROWS))*CGFloat(y);
            board[i].position = CGPointMake(px,py);
        }
    }
    func play(){
        //开始游戏，标题标签显示“游戏开始”,游戏进入初始化状态。
        delegate!.initSprite();
        delegate!.gameDisplay("游戏开始，请小羊移动");
        gameStage = .SheepTurn;
        selectedAnimal = -1;
        
    }
    //选中了羊或者狼，设置状态和显示选中状态
    //如果已经选中了狼，本次选中了一只羊，则进行判断是否能吃掉该羊
    //如果已经选中了羊，本次选中了一只狼，则进行提示：羊无法吃狼
    func selectAnimal(sprite:SKSpriteNode,spriteType:WSPointState,index:Int){
        switch gameStage{
            case .SheepTurn:
                if(spriteType == WSPointState.Sheep){
                    delegate!.selectSprite(sprite);
                    selectedAnimal = index;
                    println("select sheep:\(index)")
                    gameStage = .SheepSelect;
                }
            case .SheepSelect:
                if(spriteType == .Sheep){
                    if(index == selectedAnimal){
                        delegate!.unselectSprite(sprite);
                        selectedAnimal = index;
                        gameStage = .SheepTurn;
                    }else{
                        delegate!.selectSprite(sprite);
                        selectedAnimal = index;
                        gameStage = .SheepSelect;
                    }
                }else if(spriteType == .Wolf){
                    delegate!.gameDisplay("小羊是吃不了大灰狼的哦!");
                }else{
                    println("sprite类型异常")
                }
            case .WolfTurn:
                if(spriteType == .Wolf){
                    delegate!.selectSprite(sprite);
                    selectedAnimal = index;
                    gameStage = .WolfSelect;
                }
            case .WolfSelect:
                if(spriteType == .Sheep){
                    var (num,_) = validMove(wolf[selectedAnimal].cubeNumber,end: sheep[index].cubeNumber);
                    if( num != nil){
                        //开始移动sprite的动画
                        gameStage = .WolfMove;
                        delegate!.moveSprite(wolf[selectedAnimal].sprite,start: wolf[selectedAnimal].cubeNumber,end: num!,eatenSheep: sheep[index].sprite);
                        board[sheep[index].cubeNumber].count--
                        board[wolf[selectedAnimal].cubeNumber].pointState = .None;
                        wolf[selectedAnimal].cubeNumber = num!;
                        board[num!].pointState = .Wolf;
                        board[num!].count++;
                        //羊被吃掉的标志
                        sheep[index].cubeNumber = -1;

                    }
                }else if(spriteType == .Wolf){
                    if(index == selectedAnimal){
                        delegate!.unselectSprite(sprite);
                        selectedAnimal = index;
                        gameStage = .WolfTurn;
                    }else{
                        delegate!.selectSprite(sprite);
                        selectedAnimal = index;
                        gameStage = .WolfSelect;
                    }
                }else{
                    println("sprite类型异常")
                }
            case .WolfMove, .SheepMove:
                    delegate!.gameDisplay("动物正在移动，请稍等!");
            default:
                    println("stage异常，当前状态为\(gameStage)");

        }
    }
    //点击的是背景图片，根据当前状态决定动物移动，或给出提示信息
    func selectBlank(cubeNumber:Int){
        switch gameStage{
            case .SheepSelect:
                println("current animal \(selectedAnimal) cube is \(sheep[selectedAnimal].cubeNumber)")
                var (num,_) = validMove(sheep[selectedAnimal].cubeNumber,end: cubeNumber);
                if(num != nil){
                    //开始移动sprite的动画
                    gameStage = .SheepMove;
                    delegate!.moveSprite(sheep[selectedAnimal].sprite,start: sheep[selectedAnimal].cubeNumber,end: num!,eatenSheep: nil);
                    board[sheep[selectedAnimal].cubeNumber].count--;
                    sheep[selectedAnimal].cubeNumber = num!;
                    board[num!].pointState = .Sheep;
                    board[num!].count++;
                }
            case .WolfSelect:
                let (num,eat) = validMove(wolf[selectedAnimal].cubeNumber,end: cubeNumber)
                if(num != nil){
                    //开始移动sprite的动画
                    var eatSheep:SKSpriteNode? = nil;
                    if(eat != nil){
                        for(var i:Int = 0;i < SHEEP_GROUP*3;i++){
                            if(sheep[i].cubeNumber == eat){
                                eatSheep = sheep[i].sprite;
                            }
                        }
                        if(eatSheep == nil){
                            println("error:there should be a sheep at position[\(eat)]");
                        }
                    }
                    gameStage = .WolfMove;
                    delegate!.moveSprite(wolf[selectedAnimal].sprite,start: wolf[selectedAnimal].cubeNumber,end: num!,eatenSheep: eatSheep);
                    board[wolf[selectedAnimal].cubeNumber].pointState = .None;
                    wolf[selectedAnimal].cubeNumber = num!;
                    board[num!].pointState = .Wolf;
                    board[num!].count++;

                }
            case .SheepTurn,.WolfTurn:
                delegate!.gameDisplay("请选择要移动的动物!");
            case .SheepMove,.WolfMove:
                delegate!.gameDisplay("动物正在移动，请稍等!");
            default:
                println("stage异常，当前状态为\(gameStage)");
        }

    }
    //在动物移动完毕后，调用该方法，判断游戏是否结束。
    func switchTurn(){
        switch gameStage{
            case .SheepMove:
                gameStage = .WolfTurn;
                
            case .WolfMove:
                gameStage = .SheepTurn;

            default:
                println("stage异常，当前状态为\(gameStage)");
        }
    }
    //内部方法
    func wolfGameEnd()->Bool{
        for(var i:Int = 0;i < WOLF_NUMBER;i++){
            var cpos = wolf[i].cubeNumber;
            if(judgeUp(cpos)){
                let (ret,_) = validMove(cpos,end: stepUp(cpos))
                if(ret != nil){
                    return false;
                }
            }
            if(judgeBottom(cpos)){
                let (ret,_) = validMove(cpos,end: stepBottom(cpos))
                if(ret != nil){
                    return false;
                }
            }
            if(judgeLeft(cpos)){
                let (ret,_) = validMove(cpos,end: stepLeft(cpos))
                if(ret != nil){
                    return false;
                }
            }
            if(judgeRight(cpos)){
                let (ret,_) = validMove(cpos,end: stepRight(cpos))
                if(ret != nil){
                    return false;
                }
            }
        }
        return true;
    }
    func sheepGameEnd() -> Bool{
        var liveCount:Int = 0;
        for(var i:Int = 0;i < SHEEP_GROUP*3;i++){
            if(sheep[i].cubeNumber != -1){
                liveCount++;
            }
        }
        if(liveCount>5){
            return false;
        }
        return true;
    }
    func validMove(start:Int,end:Int) -> (Int?,Int?) {
        //上
        let (retUp,eat) = directionJudge(start,end: end,judgeUp,stepUp)
        if(retUp != nil){
            return (retUp,eat);
        }
        //下
        let (retB,eat) = directionJudge(start,end: end,judgeBottom,stepBottom)
        if(retB != nil){
            return retB,eat);
        }
        //左
        let (retL,eat) = directionJudge(start,end: end,judgeLeft,stepLeft)
        if(retL != nil){
            return retL,eat);
        }
        //右
        let (retR,eat) = directionJudge(start,end: end,judgeRight,stepRight)
        if(retR != nil){
            return (retR,eat);
        }

        return nil;
    }
    func directionJudge(start:Int,end:Int,judge:(Int) -> Bool,stepNext:(Int) -> Int )->(Int?,Int){
        if(judge(start)){
            var nextStep = stepNext(start);
            if(end == nextStep){
                if(board[start].pointState == .Wolf){
                    if(board[end].pointState == .Sheep){
                        if(judge(nextStep)){
                            var nextNextStep = stepNext(nextStep);
                            if(board[nextNextStep].pointState == .Sheep)
                            {
                                delegate!.gameDisplay("狼不能一口吃掉两只小羊!");
                            }else if(board[nextNextStep].pointState == .None){
                                return (nextNextStep,nextStep);
                            }else{
                                delegate!.gameDisplay("落脚地已经被另一头狼占据!");
                            }
                        }else{
                            delegate!.gameDisplay("场地空间不允许狼吃小羊");
                        }
                    }else if(board[end].pointState == .None){
                        return (end,nil);
                    }else{
                        delegate!.gameDisplay("前面是一头狼");
                    }
                }else if(board[start].pointState == .Sheep){
                    if(board[end].pointState == .Sheep){
                         delegate!.gameDisplay("前面是另一只小羊");
                    }else if(board[end].pointState == .None){
                        return (end,nil);
                    }else{
                        delegate!.gameDisplay("小羊不能吃掉一头狼");
                    }
                }else{
                    println("start point have no animal");
                }
            }else{
                if(board[start].pointState == .Wolf && board[nextStep].pointState == .Sheep){
                    if(judge(nextStep)){
                        var nextNextStep = stepNext(nextStep);
                        if(end == nextNextStep && board[end].pointState == .None){
                            return (end,nextStep);
                        }else{
                            delegate!.gameDisplay("狼不能一口吃掉两只小羊或者目的地是狼");
                        }
                    }else{
                        //理论上不能发生
                        delegate!.gameDisplay("error:场地空间不允许狼吃小羊");
                    }
                }
            }
        }
        return (nil,nil);
    }
}