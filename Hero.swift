//
//  Player.swift
//  FightingWarplanes
//
//  Created by 裴雷 on 08/02/2017.
//  Copyright © 2017 Rachel Liu. All rights reserved.
//

import SpriteKit

class Hero : SKSpriteNode {
    
    private var _weapon : Weapon?
    // private var _score : Int32?
    private var _hearts : Int32?  // this is regarding to blood
    
    private var _supplement : Supplement?
    
    /*
    var score : Int32 {
        get {
            return _score!
        } set {
            _score = newValue
        }
    }
    */
    
    init(imageNamed : String, viewSize : CGSize) {
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.cyan, size: texture.size())
        
        
        self.position = CGPoint(x: viewSize.width * 0.5, y: viewSize.height * 0.1)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    
    var weapon : Weapon {
        get {
            return _weapon!
        } set {
            _weapon = newValue
        }
    }
    
    var heart : Int32 {
        get {
            return _hearts!
        } set {
            _hearts = newValue
        }
    }
    
    var supplement : Supplement {
        get {
            return _supplement!
        } set {
            _supplement = newValue
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
