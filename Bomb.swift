//
//  Bomb.swift
//  FightingWarplanes
//
//  Created by 裴雷 on 15/02/2017.
//  Copyright © 2017 Rachel Liu. All rights reserved.
//

import SpriteKit

class Bomb : Weapon {
    private var _enemy: Enemy?
    private var _enemyDuration: CGFloat?
    
    // the animation associated with the bomb
    private var animatePlayerAction = SKAction()
    
    // ctor
    init(imageNamed: String, enemy: Enemy, enemyDuration: CGFloat) {
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.cyan, size: texture.size())
        
        _enemy = enemy
        _enemyDuration = enemyDuration
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Bomb
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.usesPreciseCollisionDetection = true
        
        self.position = CGPoint(x: _enemy!.position.x, y: _enemy!.position.y - _enemy!.size.height/2 - self.size.height/2)
        super.type = self
        
    }
    
    // create a Animation for move action
    func createMoveAnimation(_ viewSize : CGSize) {
        //time during(speed) of bomb moving
        let bombMoveDuration = (_enemy!.position.y + _enemy!.size.height/2) /
            ((viewSize.height + _enemy!.size.height) / _enemyDuration! * 1.2)
        
        animatePlayerAction = SKAction.move(to: CGPoint(x: self.position.x, y: -self.size.height/2), duration: TimeInterval(bombMoveDuration))
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
