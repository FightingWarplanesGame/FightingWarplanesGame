//
//  ScatterBombs.swift
//  FightingWarplanes
//
//  Created by Rachel Liu on 2017-03-07.
//  Copyright © 2017 Rachel Liu. All rights reserved.
//

import SpriteKit

class ScatterBombs : SKNode{
    private let π : CGFloat = CGFloat(M_PI)
    private var _enemy: Enemy?
    private var _enemyDuration: CGFloat?
    
    private var bomb1 : Bomb?
    private var bomb2 : Bomb?
    private var bomb3 : Bomb?
    private var bomb4 : Bomb?
    private var bomb5 : Bomb?
    
    // ctor
    init(imageNamed: String, enemy: Enemy, enemyDuration: CGFloat, viewSize: CGSize) {
        super.init()
        
        _enemy = enemy
        _enemyDuration = enemyDuration
        
        bomb1 = Bomb(imageNamed: imageNamed, enemy: enemy, enemyDuration: enemyDuration, viewSize: viewSize)
        self.addChild(bomb1!)
        
        bomb2 = Bomb(imageNamed: imageNamed, enemy: enemy, enemyDuration: enemyDuration, viewSize: viewSize)
        self.addChild(bomb2!)
        
        bomb3 = Bomb(imageNamed: imageNamed, enemy: enemy, enemyDuration: enemyDuration, viewSize: viewSize)
        self.addChild(bomb3!)
        
        bomb4 = Bomb(imageNamed: imageNamed, enemy: enemy, enemyDuration: enemyDuration, viewSize: viewSize)
        self.addChild(bomb4!)
        
        bomb5 = Bomb(imageNamed: imageNamed, enemy: enemy, enemyDuration: enemyDuration, viewSize: viewSize)
        self.addChild(bomb5!)
    }
    
    //multiple bomb nodes moving in diff shooting degree
    func runScatterBombsShooting(){
    
        let radinOf60 = π/3
        let radinOf30 = π/6
        
        //shooting at left 60 degree
        let bomb1ActionRun = SKAction.run{
            self.bomb1?.createMoveAnimation(radin: radinOf60, isLeftDegree: true)
            self.bomb1?.runAnimation()
        }
        
        //shooting at left 30 degree
        let bomb2ActionRun = SKAction.run{
            self.bomb2?.createMoveAnimation(radin: radinOf30, isLeftDegree: true)
            self.bomb2?.runAnimation()
        }
        
        //shooting at 90 degree
        let bomb3ActionRun = SKAction.run{
            self.bomb3?.createMoveAnimation()
            self.bomb3?.runAnimation()
        }
        
        //shooting at right 30 degree
        let bomb4ActionRun = SKAction.run{
            self.bomb4?.createMoveAnimation(radin: radinOf30, isLeftDegree: false)
            self.bomb4?.runAnimation()
        }

        //shooting at right 60 degree
        let bomb5ActionRun = SKAction.run{
            self.bomb5?.createMoveAnimation(radin: radinOf60, isLeftDegree: false)
            self.bomb5?.runAnimation()
        }

        self.run(SKAction.group([bomb1ActionRun, bomb2ActionRun, bomb3ActionRun, bomb4ActionRun,bomb5ActionRun]))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
