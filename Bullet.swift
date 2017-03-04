//
//  Bullet.swift
//  FightingWarplanes
//
//  Created by 裴雷 on 15/02/2017.
//  Copyright © 2017 Rachel Liu. All rights reserved.
//

import SpriteKit

class Bullet : Weapon {
    // the animation associated with the bullet
    
    private var animatePlayerAction = SKAction();
    
    // ctor
    init(imageNamed: String, hero : Hero) {
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.cyan, size: texture.size())
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.usesPreciseCollisionDetection = true
        
        self.position = hero.position
        super.type = self
    }
    
    // create a Animation for move action
    func createMoveAnimation(_ viewSize : CGSize) {
        animatePlayerAction = SKAction.move(to: CGPoint(x: self.position.x, y: viewSize.height + self.size.height/2), duration: 2.0)
    }
    
    // run the animation
    func runAnimation() {
        let actionMoveDone = SKAction.removeFromParent()
        self.run(SKAction.sequence([animatePlayerAction, actionMoveDone]))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
