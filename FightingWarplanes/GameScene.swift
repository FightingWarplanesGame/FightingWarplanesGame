//
//  GameScene.swift
//  FightingWarplanes
//
//  Created by Rachel Liu on 2017/2/3.
//  Copyright © 2017年 Rachel Liu. All rights reserved.
//



import SpriteKit
import GameplayKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var hero : Hero? = nil
    
    var score : Int = 0;
    
    let message = "score:"
    let label = SKLabelNode(fontNamed: "Chalkduster")
    let gameLayer = SKNode()
    //let pauseLayer = SKNode()
    var pauseButton: SKSpriteNode! = nil
    var playButton: SKSpriteNode! = nil
    var returnButton: SKSpriteNode! = nil
    let background1 = SKSpriteNode(imageNamed: "first_top")
    let background2 = SKSpriteNode(imageNamed: "second_bottom")
    let bgMusic : SKAudioNode = SKAudioNode(fileNamed: "Background music.mp3")
    
    
    override func didMove(to view: SKView) {
        
        //background color
        addBackGround()
        addChild(gameLayer)
        //addChild(pauseLayer)
        addButton()
        
        
        //label for score
        label.text = message + String(score)
        label.fontSize = 20
        label.fontColor = SKColor.red
        label.position = CGPoint(x: label.frame.width/2 + 2, y: size.height - label.frame.height - 2)
        gameLayer.addChild(label)
        
        //create physicsWorld
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        
        //add player
        hero = Hero(imageNamed: "hero", viewSize : size)
        gameLayer.addChild(hero!)
        
        //interval of enemy entering
        let enemyEnterDuration = Calculation.random(min: CGFloat(1.0), max: CGFloat(2.0))
        
        //repeat to add enemy
        
        
        gameLayer.run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addNormalEnemy),
                SKAction.wait(forDuration: TimeInterval(enemyEnterDuration))
                ])
        ))
        
        // add music background
        bgMusic.autoplayLooped = true
        bgMusic.run(SKAction.play())
        gameLayer.addChild(bgMusic)
        
    }
    
    func addBackGround() {
        background1.anchorPoint = CGPoint()
        background1.position = CGPoint(x: 0, y:0)
        background1.zPosition = -1
        gameLayer.addChild(background1)
        
        background2.anchorPoint = CGPoint()
        background2.position = CGPoint(x: 0, y:background2.size.height)
        background2.zPosition = -1
        gameLayer.addChild(background2)
    }
    
    func moveGround(){
        //speed of the backgroud moving
        background1.position = CGPoint(x:background1.position.x, y:background1.position.y - 5)
        background2.position = CGPoint(x:background2.position.x, y:background2.position.y - 5)
        
        if(background1.position.y < -background1.size.height)
        {
            print("1")
            background1.position = CGPoint(x:background2.position.x, y:background2.position.y + background2.size.height )
        }
        
        if(background2.position.y < -background2.size.height)
        {
            print("2")
            background2.position = CGPoint(x:background1.position.x, y:background1.position.y + background1.size.height )
            
        }
    }
    
    func addButton()
    {
        
        pauseButton = SKSpriteNode(imageNamed: "pause")
        pauseButton.size = CGSize(width: 20, height: 20)
        pauseButton.position = CGPoint(x:self.frame.maxX-20, y:self.frame.maxY-15)
        pauseButton.zPosition = 15
        
        playButton = SKSpriteNode(imageNamed: "resume")
        playButton.size = CGSize(width: 20, height: 20)
        playButton.position = CGPoint(x:self.frame.maxX-20, y:self.frame.maxY-15)
        playButton.zPosition = 15
        
        returnButton = SKSpriteNode(imageNamed: "home_icon")
        returnButton.size = CGSize(width:30, height:23)
        returnButton.position = CGPoint(x:self.frame.maxX-45, y:self.frame.maxY-15)
        returnButton.zPosition = 15
        
        
        self.gameLayer.addChild(pauseButton)
        self.gameLayer.addChild(playButton)
        self.gameLayer.addChild(returnButton)
        playButton.isHidden = true
        
        
        
        
    }
    
    func addBullet(){
        //add bullet
        let bullet = Bullet(imageNamed: "bullet", hero: hero!)
        gameLayer.addChild(bullet)
        
        //add actions to bullet
        bullet.createMoveAnimation(size)
        bullet.runAnimation()
    }
    
    func addBomb(_ enemyNode: Enemy!, _ enemyDuration: CGFloat!) -> Void{
        //add bomb
        let bomb = Bomb(imageNamed: "bomb", enemy: enemyNode!, enemyDuration: enemyDuration!)
        gameLayer.addChild(bomb)
        
        //add actions to bomb
        bomb.createMoveAnimation(size)
        bomb.runAnimation()

    }

    
    
    func addNormalEnemy(){
        //add enemy
        let enemy = Enemy(imageNamed: "enemy")
        enemy.heart = 5
        
        //start position
        let actualX = Calculation.random(min: enemy.size.width/2, max: size.width - enemy.size.width/2)
        enemy.position = CGPoint(x: actualX, y: size.height + enemy.size.height/2)
        
        gameLayer.addChild(enemy)
        
        //time duration(speed) of enemy moving
        let enemyMoveDuration = Calculation.random(min: CGFloat(8.0), max: CGFloat(10.0))
        
        //add actions to enemy
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -enemy.size.height/2), duration: TimeInterval(enemyMoveDuration))
        
        //interval of firing bombs
        let fireBombDuration = Calculation.random(min: CGFloat(6.0), max: CGFloat(15.0))

        
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
        if !gameLayer.isPaused {
            run(SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.run(addBullet),
                    SKAction.wait(forDuration: 0.1)
                    ])
            ), withKey: "shootingBullets")
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !gameLayer.isPaused {
            for t in touches {
                if (hero?.contains(t.location(in: self)))! {
                    
                }
                self.touchMoved(toPoint: t.location(in: self))
                let touchLocation = t.location(in: self)
                hero?.position = touchLocation
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !gameLayer.isPaused {
            for t in touches { self.touchUp(atPoint: t.location(in: self)) }
            removeAction(forKey: "shootingBullets");
        }
        
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        if pauseButton.contains(touchLocation) {
            if gameLayer.isPaused {
                gameLayer.addChild(bgMusic)
                bgMusic.autoplayLooped = true
                pauseButton.isHidden = false
                playButton.isHidden = true
                gameLayer.isPaused = false
                print("resume!")
            }else{
                bgMusic.removeFromParent()
                gameLayer.isPaused = true
                pauseButton.isHidden = true
                playButton.isHidden = false
                print("pause!")
            }
        }
        else if returnButton.contains(touchLocation){
            gameLayer.removeAllChildren()
            gameLayer.removeFromParent()
            
            let scene = MainMenuScene(fileNamed: "MainMenu")
            
            
            
            self.view?.showsFPS = true
            self.view?.showsNodeCount = true
            self.view?.ignoresSiblingOrder = true
            scene?.scaleMode = .resizeFill
            self.view?.presentScene(scene)
            
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if !gameLayer.isPaused {
            moveGround()
        }
    }
    
    //collide between bullet and enemy -> shooting enemy
    func bulletDidCollideWithEnemy(bullet: Bullet, enemy: Enemy) {
        print("shootEnemy")
        if (enemy.heart == 0){
            //when collide, remove both nodes
            let explosion : SKEmitterNode = SKEmitterNode(fileNamed: "Explosion")!
            explosion.position = enemy.position
            gameLayer.addChild(explosion)
            bullet.removeFromParent()
            enemy.removeFromParent()
            
            score += 1;
            label.text = message + String(score)
        } else {
            let wait = SKAction.wait(forDuration: 0.2)
            let red = SKAction.run {
                enemy.run(SKAction.colorize(with: .red, colorBlendFactor: 0.8, duration: 0.1))
            }
            let clear = SKAction.run {
                enemy.run(SKAction.colorize(with: .white, colorBlendFactor: 1, duration: 0.1))
            }
            let hitColor = SKAction.sequence([red,wait,clear])
            enemy.run(hitColor)
            enemy.heart -= 1
            enemy.run(SKAction.colorize(with: .white, colorBlendFactor: 1, duration: 10))
            enemy.color = .white
            bullet.removeFromParent()
        }
        
        
       
    }
    
    
    
    //collide between player and enemy -> game over
    func playerDidCollideWithEnemy(player: Hero, enemy: Enemy) {
        print("lose - hit enemy")
        let explosion : SKEmitterNode = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = player.position
        gameLayer.addChild(explosion)
        //when collide, remove both nodes
        
        player.removeFromParent()
        enemy.removeFromParent()
        
        let delay = SKAction.wait(forDuration: 1)
        //go to GameOverScene
        let loseAction = SKAction.run() {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: false, score: self.score)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        let sequence = SKAction.sequence([delay,loseAction])
        run(sequence)
    }
    
    //collide between player and bomb -> game over
    func playerDidCollideWithBomb(player: Hero, bomb: Bomb) {
        print("lose - hit bomb")
        let explosion : SKEmitterNode = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = player.position
        gameLayer.addChild(explosion)
        //when collide, remove both nodes
        
        player.removeFromParent()
        bomb.removeFromParent()
        
        let delay = SKAction.wait(forDuration: 1)
        //go to GameOverScene
        let loseAction = SKAction.run() {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: false, score: self.score)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        let sequence = SKAction.sequence([delay,loseAction])
        
        run(sequence)
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
            if let enemy = firstBody.node as? Enemy,
                let bullet = secondBody.node as? Bullet {
                bulletDidCollideWithEnemy(bullet: bullet, enemy: enemy)
            }
        } else if((PhysicsCategory.Enemy != 0) &&
            (PhysicsCategory.Player != 0) &&
            (firstBody.categoryBitMask == PhysicsCategory.Enemy) &&
            (secondBody.categoryBitMask == PhysicsCategory.Player)){
            if let enemy = firstBody.node as? Enemy,
                let player = secondBody.node as? Hero {
                playerDidCollideWithEnemy(player: player, enemy: enemy)
            }
        }else if((PhysicsCategory.Bomb != 0) &&
            (PhysicsCategory.Player != 0) &&
            (firstBody.categoryBitMask == PhysicsCategory.Player) &&
            (secondBody.categoryBitMask == PhysicsCategory.Bomb)){
            if let player = firstBody.node as? Hero,
                let bomb = secondBody.node as? Bomb {
                playerDidCollideWithBomb(player: player, bomb: bomb)
            }
        }
        
        
        
    }
}

