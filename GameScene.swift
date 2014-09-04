//
//  GameScene.swift
//  Wolf&Sheep
//
//  Created by 张宏台 on 14-9-2.
//  Copyright (c) 2014年 张宏台. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var game = WolfSheepGame();
    
    var boardPosition:CGPoint = CGPointMake(0,0);
    var boardSize:CGSize = CGSize(width: 0,height: 0);
    var backgroundBoard = SKSpriteNode();
       
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        ////设置背景颜色
        var skyColor = SKColor();
        skyColor = SKColor(red: 81.0/255.0, green: 192.0/255.0, blue: 201.0/255.0, alpha: 1.0);
        self.backgroundColor = skyColor;
        //添加背景图片，草地，小河，山
        var bgTexture = SKTexture(imageNamed: "background");
        
        //设置大小和位置
        backgroundBoard = SKSpriteNode(texture:bgTexture)
        //在模拟器中我使用screen的大小为参考，否则很难控制这个图片的显示。
        var screen = UIScreen.mainScreen()
        println("screen width:\(screen.bounds.size.width),height:\(screen.bounds.size.height)")
        println("board width:\(backgroundBoard.size.width),height:\(backgroundBoard.size.height)")
        
        backgroundBoard.setScale(screen.bounds.size.width/backgroundBoard.size.width*1.3)
        boardSize = backgroundBoard.size
        
        //它的位置是左右居中。Scene的Y轴是由下至上的，所以是屏幕高度除以2+100，即中间靠上的位置
        backgroundBoard.position = CGPointMake(self.frame.size.width/2,backgroundBoard.size.height/2+150)
        boardPosition = backgroundBoard.position
        self.addChild(backgroundBoard)
        
        game.delegate = self;

        //添加小羊3*3
        for i:Int in 0..<SHEEP_GROUP {
            var imageName:String = "sheep\(i+1)";
            for j:Int in 0..<3 {
                var sheepTexture = SKTexture(imageNamed: imageName);

                game.sheep[3*i+j].sprite = SKSpriteNode(texture:sheepTexture);
                println("sheep width:\(game.sheep[3*i+j].sprite.size.width),height:\(game.sheep[3*i+j].sprite.size.height)")
                game.sheep[3*i+j].sprite.setScale(screen.bounds.size.width/boardSize.width*0.8);
                //它的初始位置是25格的最左最下的方格。计算方法是以25格图中心点为参考
                //羊占下方234格，每个格3只羊。

                game.sheep[3*i+j].sprite.position = CGPointMake(boardPosition.x-boardSize.width/5*(3-ANIMAL_POSITION_ARRAY[i]),boardPosition.y-boardSize.height/6*2.5)
                self.addChild(game.sheep[3*i+j].sprite);
                game.board[ANIMAL_POSITION_ARRAY[i]].pointState = .Sheep;
                game.board[ANIMAL_POSITION_ARRAY[i]].count++;
                game.sheep[3*1+j].cubeNumber = ANIMAL_POSITION_ARRAY[i];
            }
            
        }
        //添加狼*2
        for i:Int in 0..<WOLF_NUMBER {
            var imageName:String = "wolf\(i+1)";
            var wolfTexture = SKTexture(imageNamed: imageName);
            
            game.wolf[i].sprite = SKSpriteNode(texture:wolfTexture);
            println("wolf width:\(game.wolf[i].sprite.size.width),height:\(game.wolf[i].sprite.size.height)")
            game.wolf[i].sprite.setScale(screen.bounds.size.width/boardSize.width*0.8)
            //狼占上方2、4格
            game.wolf[i].sprite.position = CGPointMake(boardPosition.x-boardSize.width/5*(3-ANIMAL_POSITION_ARRAY[i]),boardPosition.y+boardSize.height/6*2.5)
            self.addChild(game.wolf[i].sprite);
            game.board[ANIMAL_POSITION_ARRAY[i]].pointState = .Wolf;
            game.board[ANIMAL_POSITION_ARRAY[i]].count++;
            game.wolf[i].cubeNumber = ANIMAL_POSITION_ARRAY[i];
        }

    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
