//
//  Supplement.swift
//  FightingWarplanes
//
//  Created by 裴雷 on 15/02/2017.
//  Copyright © 2017 Rachel Liu. All rights reserved.
//

import SpriteKit

/**
 this is the base class for all the supplement
 */
class Supplement : SKSpriteNode {
    
    private var suppAnimation : SKAction
    
    init(imageNamed : String, enemy : Enemy){
        let texture = SKTexture(imageNamed: imageNamed)
        suppAnimation = SKAction()
        super.init(texture: texture, color: UIColor.cyan, size: texture.size())
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Supplement
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.position = enemy.position
        
    }
    
    func createMoveAnimation(_ viewSize : CGSize) {
        suppAnimation = SKAction.move(to: CGPoint(x: self.position.x, y: viewSize.height + self.size.height/2), duration: 2.0)
    }
    
    // run the animation
    func runAnimation() {
        let actionMoveDone = SKAction.removeFromParent()
        let actionWait = SKAction.wait(forDuration: 1000)
        self.run(SKAction.sequence([suppAnimation, actionWait, actionMoveDone]))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
