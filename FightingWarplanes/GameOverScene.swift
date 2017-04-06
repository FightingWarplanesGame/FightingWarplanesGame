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
    
    
    var quitButton: SKSpriteNode! = nil
    var playAgainButton : SKSpriteNode! = nil
    let background = SKSpriteNode(imageNamed: "gameover-bg")
    let resultLabel = SKLabelNode(fontNamed: "Chalkduster")
    let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    init(size: CGSize, score: Int, time: String) {
        
        super.init(size: size)
        
        //backgroundColor = SKColor.cyan
        addBackground()
        addButton()
        //self.scaleMode = .resizeFill
        
        
        resultLabel.fontSize = 20
        resultLabel.fontColor = SKColor.white
        resultLabel.position = CGPoint(x: size.width/2, y: size.height/2 + playAgainButton.frame.height + resultLabel.frame.height + scoreLabel.frame.height)
        resultLabel.text = time
        addChild(resultLabel)
        
        //score label
        let msgScore = "Your score: " + String(score)
        scoreLabel.text = msgScore
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height/2 + playAgainButton.frame.height + scoreLabel.frame.height)
        addChild(scoreLabel)
        
        //after 3 sec, go back to game scene
//        run(SKAction.sequence([
//            SKAction.wait(forDuration: 3.0),
//            SKAction.run() {
//                // 5
//                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
//                let scene = GameScene(size: size)
//                self.view?.presentScene(scene, transition:reveal)
//            }
//            ]))
        
    }
    
    func addButton(){
        
        playAgainButton = SKSpriteNode(imageNamed: "playagainBts")
        playAgainButton.size = CGSize(width: 200, height: 50)
        playAgainButton.position = CGPoint(x: size.width/2, y: size.height/2)
        //playAgainButton.zPosition = 15
        
        quitButton = SKSpriteNode(imageNamed: "quitBtn")
        quitButton.size = CGSize(width: 200, height: 50)
        quitButton.position = CGPoint(x: size.width/2, y: size.height/2 - playAgainButton.frame.height-20)
        //quitButton.zPosition = 15
        
        
        self.addChild(quitButton)
        self.addChild(playAgainButton)
    }
    
    func addBackground(){
        background.size = self.frame.size
        background.anchorPoint = CGPoint()
        background.position = CGPoint(x: 0, y:0)
        background.zPosition = -1
        self.addChild(background)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        if playAgainButton.contains(touchLocation) {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let scene = GameScene(size: size)
            self.view?.presentScene(scene, transition:reveal)
            
        }
        else if quitButton.contains(touchLocation){
            let scene = MainMenuScene(fileNamed: "MainMenu")
            self.view?.showsFPS = true
            self.view?.showsNodeCount = true
            self.view?.ignoresSiblingOrder = true
            scene?.scaleMode = .resizeFill
            self.view?.presentScene(scene)
            
        }
    }
    
    //error
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
