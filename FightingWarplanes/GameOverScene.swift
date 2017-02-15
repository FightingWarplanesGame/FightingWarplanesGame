//
//  GameOverScene.swift
//  FightingWarplanes
//
//  Created by Rachel Liu on 2017/2/3.
//  Copyright © 2017年 Rachel Liu. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    init(size: CGSize, won:Bool, score: Int) {
        
        super.init(size: size)
        
        backgroundColor = SKColor.cyan
        
        //result label: won or lose
        let msgResult = won ? "You Won!" : "Game Over!"
        let resultLabel = SKLabelNode(fontNamed: "Chalkduster")
        resultLabel.text = msgResult
        resultLabel.fontSize = 40
        resultLabel.fontColor = SKColor.white
        resultLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(resultLabel)
        
        //score label
        let msgScore = "Your score: " + String(score)
        let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = msgScore
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height/2 - resultLabel.frame.height/2 - scoreLabel.frame.height/2)
        addChild(scoreLabel)
        
        //after 3 sec, go back to game scene
        run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run() {
                // 5
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition:reveal)
            }
            ]))
        
    }
    
    //error
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
