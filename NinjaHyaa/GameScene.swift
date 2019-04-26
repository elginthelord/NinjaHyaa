//
//  GameScene.swift
//  NinjaHyaa
//
//  Created by LORD ELGIN RAGUERO on 4/8/19.
//  Copyright © 2019 CLC. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    
    static let none: UInt32 = 0
    static let all: UInt32 = UInt32.max
    static let ninja: UInt32 = 1
    static let dragon: UInt32 = 2 // number 1
    static let star: UInt32 = 4 // number 2
    
    
    
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
 
     var ninja = SKSpriteNode(imageNamed: "ninja")
   
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        backgroundColor = UIColor.white
        
        
        
        let backgroundMusic = SKAudioNode(fileNamed: "gameMusic.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        physicsWorld.gravity = CGVector.zero // set the gravity of the entire sprite nodes to zero
        createPlayer()
     
        run(SKAction.repeatForever(
            SKAction.sequence([SKAction.run(dragonEnemy),SKAction.wait(forDuration: 1.0)]
                )))
        
        }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // step 1 get the location of where we touch
        guard let touch = touches.first else {
            return
            
        }
        
        // finding the location of the last touch
        let touchLocation = touch.location(in: self)
        
        // step 2 set the location of the projectile
        let star = SKSpriteNode(imageNamed: "star")
        
        star.position = ninja.position
        star.physicsBody = SKPhysicsBody(rectangleOf: star.size)
      
        star.physicsBody?.categoryBitMask = PhysicsCategory.star
        star.physicsBody?.contactTestBitMask = PhysicsCategory.dragon
     //   star.physicsBody?.collisionBitMask = PhysicsCategory.none
        star.physicsBody?.isDynamic = true
        
             addChild(star)
   
        
        // step 3 determine where to fire the projectile
        let offSet = touchLocation - star.position
        let direction = offSet.normalized()
        let shootAmount = direction * 1000
        let realDest = shootAmount + star.position
        
        // step 4 create the actions
        let actionMoved = SKAction.move(to: realDest, duration: TimeInterval(2.0))
        let actionMoveDone = SKAction.removeFromParent()
        star.run(SKAction.sequence([actionMoved, actionMoveDone]))
    }
    
    func randomPoint() -> CGPoint{
        var xPos = Int.random(in: 0...Int(self.size.width))
        var yPos = Int.random(in: 0...Int(self.size.height))

        return CGPoint(x: xPos, y: yPos)
    }
    
    func createPlayer(){
      //  var ninja = SKSpriteNode(imageNamed: "ninja")
      //  ninja.position = randomPoint()
        
        
        ninja.position = CGPoint(x: (self.size.width * 0.10), y: (self.size.height * 0.50))
        ninja.scale(to: CGSize(width: 50, height: 50))
        ninja.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: ninja.size.width, height: ninja.size.height))
        ninja.physicsBody?.categoryBitMask = PhysicsCategory.ninja
       
        ninja.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        ninja.physicsBody?.contactTestBitMask = PhysicsCategory.dragon
        
        
     ninja.physicsBody?.affectedByGravity = false
      
    //    ninja.physicsBody?.isDynamic = true
        
        addChild(ninja)
        
    //     ninja.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 0))
        
    }
    
    
    
    func dragonEnemy(){
        
        var dragon = SKSpriteNode(imageNamed: "dragon")
        
        var scale = Int.random(in: 50...100)
        
        dragon.physicsBody = SKPhysicsBody(rectangleOf: dragon.size)
        dragon.scale(to: CGSize(width: scale, height: scale))
       dragon.physicsBody?.mass = 1
       // dragon.physicsBody?.categoryBitMask = 2
        dragon.physicsBody?.categoryBitMask = PhysicsCategory.dragon
        dragon.physicsBody?.contactTestBitMask = PhysicsCategory.star
       dragon.physicsBody?.collisionBitMask = PhysicsCategory.none
        dragon.physicsBody?.isDynamic = true
        
      //  dragon.position = randomPoint()
        let height = (self.size.height * (CGFloat.random(in: 0.10...0.90)))
        
        dragon.position = CGPoint(x: (self.size.width * 0.90), y: CGFloat(height))
        
        
        
        let actionMove = SKAction.move(to: CGPoint(x: 0, y: dragon.position.y), duration: TimeInterval(CGFloat.random(in: 2.0...4.0)))
        let actionMoveDone = SKAction.removeFromParent()
        addChild(dragon)
        dragon.run(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
    
    func starDidCollideWithDragon(star: SKSpriteNode, dragon: SKSpriteNode, ninja: SKSpriteNode) {
        
       star.removeFromParent()
        dragon.removeFromParent()
        ninja.removeFromParent()
        
        print("CONTACT")
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let first = contact.bodyA
        let second = contact.bodyB
        
        if let dragon = first.node as? SKSpriteNode, let star = second.node as? SKSpriteNode, let ninja = first.node as? SKSpriteNode{
            starDidCollideWithDragon(star: dragon, dragon: star, ninja: ninja)
        }
        
        
        
        
    }
}
