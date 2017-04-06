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
    private var _viewSize: CGSize?
    
    // the animation associated with the bomb
    private var animateBombAction = SKAction()
    
    // ctor
    init(imageNamed: String, enemy: Enemy, enemyDuration: CGFloat, viewSize: CGSize) {
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.cyan, size: texture.size())
        
        
        
        _enemy = enemy
        _enemyDuration = enemyDuration
        _viewSize = viewSize
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Bomb
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.usesPreciseCollisionDetection = true
        
        self.position = CGPoint(x: _enemy!.position.x, y: _enemy!.position.y - _enemy!.size.height/2 - self.size.height/2)
        super.type = self
        
    }
    
    // create a Animation for move action in vertical direction
    func createMoveAnimation(speed : CGFloat) {
        //time during(speed) of bomb moving
        let bombMoveDuration1 = _enemy!.position.y + _enemy!.size.height/2
        
        let bombMoveDuration2 = ((_viewSize?.height)! + _enemy!.size.height) / _enemyDuration! * speed
        
        let bombMoveDuration = bombMoveDuration1/bombMoveDuration2
        
        animateBombAction = SKAction.move(to: CGPoint(x: self.position.x, y: -self.size.height/2), duration: TimeInterval(bombMoveDuration))
    }
    
    // create a Animation for move action in diff degree direction
    func createMoveAnimation(radin: CGFloat, isLeftDegree: Bool) {
        // get endPoint
        let endPoint = calculateEndPoint(radin: radin, isLeftDegree: isLeftDegree)
        
        let distanceOfStartAndEnd = hypot(self.position.x - endPoint.x, self.position.y - endPoint.y)
        
        //get bomb moving time(duration)
        let bombMoveDuration = distanceOfStartAndEnd /
            (((_viewSize?.height)! + _enemy!.size.height) / _enemyDuration! * 1.2)
        
        animateBombAction = SKAction.move(to: endPoint, duration: TimeInterval(bombMoveDuration))
    }
    
    
    func calculateEndPoint(radin : CGFloat, isLeftDegree: Bool) -> CGPoint {
        
        let leftCriticalRadin = atan(self.position.x / self.position.y)
        let rightCriticalRadin = atan(((_viewSize?.width)! - self.position.x) / self.position.y)
        
        if(isLeftDegree){
            if radin > leftCriticalRadin {
                return CGPoint(x: 0.0, y: self.position.y - self.position.x / tan(radin))
            }else{
                return CGPoint(x: self.position.x - self.position.y * tan(radin), y: 0.0)
            }
            
        }else{
            if radin > rightCriticalRadin {
                return CGPoint(x: _viewSize!.width, y: self.position.y - (_viewSize!.width - self.position.x) / tan(radin))
            }else{
                return CGPoint(x: self.position.x + self.position.y * tan(radin), y: 0.0)
            }
            
        }
        
    }

    // run the animation
    func runAnimation() {
        let actionMoveDone = SKAction.removeFromParent()
        self.run(SKAction.sequence([animateBombAction, actionMoveDone]))
    }

    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
