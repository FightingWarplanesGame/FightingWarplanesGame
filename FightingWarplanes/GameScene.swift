//
//  GameScene.swift
//  FightingWarplanes
//
//  Created by Rachel Liu on 2017/2/3.
//  Copyright © 2017年 Rachel Liu. All rights reserved.
//



import SpriteKit
import GameplayKit

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}


struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Enemy   : UInt32 = 0b1       // 1
    static let Bullet: UInt32 = 0b10      // 2
    static let Player: UInt32 = 0b100      // 3
    static let Bomb: UInt32 = 0b1000      // 4
}
 


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player = SKSpriteNode(imageNamed: "hero")
    
    var score : Int = 0;
    let message = "score:"
    let label = SKLabelNode(fontNamed: "Chalkduster")
    
    override func didMove(to view: SKView) {
        
        //background color
        backgroundColor = SKColor.cyan
        
        //label for score
        label.text = message + String(score)
        label.fontSize = 20
        label.fontColor = SKColor.red
        label.position = CGPoint(x: label.frame.width/2 + 2, y: size.height - label.frame.height - 2)
        addChild(label)
        
        //add player
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        player.physicsBody?.collisionBitMask = PhysicsCategory.None
        player.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(player)
        
        
        //create physicsWorld
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        
        //interval of enemy entering
        let enemyEnterDuration = random(min: CGFloat(1.0), max: CGFloat(2.0))
        
        //repeat to add enemy
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addEnemy),
                SKAction.wait(forDuration: TimeInterval(enemyEnterDuration))
            ])
        ))
        
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addBullet(){
        //add bullet
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.position = player.position
        
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width/2)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        bullet.physicsBody?.collisionBitMask = PhysicsCategory.None
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(bullet)
        
        //add actions to bullet
        let actionMove = SKAction.move(to: CGPoint(x: bullet.position.x, y: size.height + bullet.size.height/2), duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        bullet.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    func addBomb(_ enemyNode: SKSpriteNode, _ enemyDuration: CGFloat) -> Void{
        //add bomb
        let bomb = SKSpriteNode(imageNamed: "bomb")
        bomb.position = enemyNode.position
        
        bomb.physicsBody = SKPhysicsBody(circleOfRadius: bomb.size.width/2)
        bomb.physicsBody?.isDynamic = true
        bomb.physicsBody?.categoryBitMask = PhysicsCategory.Bomb
        bomb.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        bomb.physicsBody?.collisionBitMask = PhysicsCategory.None
        bomb.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(bomb)
        
        //time during(speed) of bomb moving
        let bombMoveDuration = (enemyNode.position.y + enemyNode.size.height/2) /
                                ((size.height + enemyNode.size.height) / enemyDuration * 1.2)
        
        //add actions to bomb
        let actionMove = SKAction.move(to: CGPoint(x: bomb.position.x, y: -bomb.size.height/2), duration: TimeInterval(bombMoveDuration))
        let actionMoveDone = SKAction.removeFromParent()
        bomb.run(SKAction.sequence([actionMove, actionMoveDone]))
    }

    
    
    func addEnemy(){
        //add enemy
        let enemy = SKSpriteNode(imageNamed: "enemy")
        
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size) // 1
        enemy.physicsBody?.isDynamic = true // 2
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy // 3
        enemy.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet // 4
        enemy.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
        
        //start position
        let actualX = random(min: enemy.size.width/2, max: size.width - enemy.size.width/2)
        enemy.position = CGPoint(x: actualX, y: size.height + enemy.size.height/2)
        
        addChild(enemy)
        
        //time duration(speed) of enemy moving
        let enemyMoveDuration = random(min: CGFloat(8.0), max: CGFloat(10.0))
        
        //add actions to enemy
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -enemy.size.height/2), duration: TimeInterval(enemyMoveDuration))
        
        //interval of firing bombs
        let fireBombDuration = random(min: CGFloat(4.0), max: CGFloat(6.0))

        //enemy repeat to fire bombs
        let actionForever = SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run({self.addBomb(enemy, enemyMoveDuration)}),
                SKAction.wait(forDuration: TimeInterval(fireBombDuration))
                ])
        )
        
        let actionMoveDone = SKAction.removeFromParent()
        enemy.run(SKAction.sequence([SKAction.group([actionMove, actionForever]), actionMoveDone]))
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
            }
    
    func touchMoved(toPoint pos : CGPoint) {
            }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //repeat to add bullet when touch beginning
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addBullet),
                SKAction.wait(forDuration: 0.1)
                ])
        ), withKey: "shootingBullets")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchMoved(toPoint: t.location(in: self))
            let touchLocation = t.location(in: self)
            player.position = touchLocation
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        removeAction(forKey: "shootingBullets");
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    //collide between bullet and enemy -> shooting enemy
    func bulletDidCollideWithEnemy(bullet: SKSpriteNode, enemy: SKSpriteNode) {
        print("shootEnemy")
        //when collide, remove both nodes
        bullet.removeFromParent()
        enemy.removeFromParent()
        score += 1;
        label.text = message + String(score)
    }
    
    //collide between player and enemy -> game over
    func playerDidCollideWithEnemy(player: SKSpriteNode, enemy: SKSpriteNode) {
        print("lose - hit enemy")
        //when collide, remove both nodes
        player.removeFromParent()
        enemy.removeFromParent()
        
        //go to GameOverScene
        let loseAction = SKAction.run() {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: false, score: self.score)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        
        run(loseAction)
    }
    
    //collide between player and bomb -> game over
    func playerDidCollideWithBomb(player: SKSpriteNode, bomb: SKSpriteNode) {
        print("lose - hit bomb")
        //when collide, remove both nodes
        player.removeFromParent()
        bomb.removeFromParent()
        
        //go to GameOverScene
        let loseAction = SKAction.run() {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: false, score: self.score)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        
        run(loseAction)
    }

    
    func didBegin(_ contact: SKPhysicsContact) {
        //first < second
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        //set different collision situations
        if ((PhysicsCategory.Enemy != 0) &&
            (PhysicsCategory.Bullet != 0) &&
            (firstBody.categoryBitMask == PhysicsCategory.Enemy) &&
            (secondBody.categoryBitMask == PhysicsCategory.Bullet)){
            if let enemy = firstBody.node as? SKSpriteNode,
                let bullet = secondBody.node as? SKSpriteNode {
                bulletDidCollideWithEnemy(bullet: bullet, enemy: enemy)
            }
        } else if((PhysicsCategory.Enemy != 0) &&
            (PhysicsCategory.Player != 0) &&
            (firstBody.categoryBitMask == PhysicsCategory.Enemy) &&
            (secondBody.categoryBitMask == PhysicsCategory.Player)){
            if let enemy = firstBody.node as? SKSpriteNode,
                let player = secondBody.node as? SKSpriteNode {
                playerDidCollideWithEnemy(player: player, enemy: enemy)
            }
        }else if((PhysicsCategory.Bomb != 0) &&
            (PhysicsCategory.Player != 0) &&
            (firstBody.categoryBitMask == PhysicsCategory.Player) &&
            (secondBody.categoryBitMask == PhysicsCategory.Bomb)){
            if let player = firstBody.node as? SKSpriteNode,
                let bomb = secondBody.node as? SKSpriteNode {
                playerDidCollideWithBomb(player: player, bomb: bomb)
            }
        }
        
        
        
    }
}

