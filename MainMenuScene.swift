//
//  MainMenuScene.swift
//  FightingWarplanes
//
//  Created by 裴雷 on 09/02/2017.
//  Copyright © 2017 Rachel Liu. All rights reserved.
//

import SpriteKit

class MainMenuScene : SKScene {
    
    
    override func didMove(to view: SKView) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self);
            
            let touchedNode = self.scene?.nodes(at: location)
            
            guard let nodes = touchedNode else {
                return
            }
            
            if nodes.first?.name == "start Game" {
                
                 let scene = GameScene(size: (view?.bounds.size)!)
                 //let scene = GameplayScene(fileNamed: "GameplayScene")
                 
                 
                 
                 
                 let skView = self.view!
                 skView.showsFPS = true
                 skView.showsNodeCount = true
                 skView.ignoresSiblingOrder = true
                 scene.scaleMode = .resizeFill
                 skView.presentScene(scene, transition: SKTransition.doorsCloseVertical(withDuration: 1))
                

            }
        }
    }
}
