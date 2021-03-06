//
//  GameScene.swift
//  Bangcraft
//
//  Created by Ethan Bang on 5/3/18.
//  Copyright © 2018 Ethan Bang. All rights reserved.
//

import SpriteKit
import GameplayKit


struct PhysicsCategory {
    static let None : UInt32 = 0
    static let All : UInt32 = UInt32.max
    static let Monster : UInt32 = 0b1      // is equal to binary 1
    static let Projectile: UInt32 = 0b10      // is equal to binary 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    // creating player sprite
    
    let player = SKSpriteNode(imageNamed: "bangbear")
    
    override func didMove(to view: SKView){
        let bgImage = SKSpriteNode(imageNamed: "FlappyFlop")
        bgImage.position = CGPoint(x:self.size.width/2, y: self.size.height/2.0)
        bgImage.zPosition = -1
        self.addChild(bgImage)
        
        //placing our player sprite
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.2)
        
        //adding the sprite
        addChild(player)
        
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self


        let backgroundMusic = SKAudioNode(fileNamed: "gameMusic.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        
        // Create infinite monsters
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addMonster), SKAction.wait(forDuration: 1.0)])))
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addDuck), SKAction.wait(forDuration: 1.0)])))

    }
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addMonster() {
        // create sprite node
        let monster = SKSpriteNode(imageNamed: "WaterMilan")
        // Creates physics body for the sprite:
        monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size)
        // Movements of the monster only happen in code (those moveActions we set up):
        monster.physicsBody?.isDynamic = true
        // We set that category bitmask to monster here:
        monster.physicsBody?.categoryBitMask = PhysicsCategory.Monster
        // Let us know when a monster and projectile contact
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        // Let’s things go through it instead of bounce off it. We don’t want things to bounce off stuff
        monster.physicsBody?.collisionBitMask = PhysicsCategory.None
        //determine where to put the enemy on y axis
        let actualY = random(min: monster.size.height/0.9, max: monster.size.height/0.9)
        //place monster slightly off screen
        monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
        //add monster to screen
        addChild(monster)
        monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size)
        monster.physicsBody?.isDynamic = true
        monster.physicsBody?.categoryBitMask = PhysicsCategory.Monster
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        monster.physicsBody?.collisionBitMask = PhysicsCategory.None
       //determine speed of monster
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        //create two actions
        let actionMove = SKAction.move(to: CGPoint(x: monster.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        monster.run(SKAction.sequence([actionMove, actionMoveDone]))
        

    }
    func addDuck() {
        let mrquack = SKSpriteNode(imageNamed: "mrquacknormal")
mrquack.physicsBody = SKPhysicsBody(rectangleOf: mrquack.size)
       mrquack.physicsBody?.isDynamic = true
        mrquack.physicsBody?.categoryBitMask = PhysicsCategory.Monster
        mrquack.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        let actualY2 = random(min: mrquack.size.height/0.4, max: size.height - mrquack.size.height/2)
        mrquack.position = CGPoint(x: size.width + mrquack.size.width/2, y: actualY2)
        addChild(mrquack)
        mrquack.physicsBody = SKPhysicsBody(rectangleOf: mrquack.size)
        mrquack.physicsBody?.isDynamic = true
        mrquack.physicsBody?.categoryBitMask = PhysicsCategory.Monster
        mrquack.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        mrquack.physicsBody?.collisionBitMask = PhysicsCategory.None
        let actualDuration2 = random(min: CGFloat(2.0), max: CGFloat(4.0))
        let actionMove2 = SKAction.move(to: CGPoint(x: mrquack.size.width/2, y: actualY2), duration: TimeInterval(actualDuration2))
        let actionMoveDone2 = SKAction.removeFromParent()
        mrquack.run(SKAction.sequence([actionMove2, actionMoveDone2]))

    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let projectile = SKSpriteNode (imageNamed: "FEH_Orb")
        run(SKAction.playSoundFileNamed("GAWRSH!!.mp3", waitForCompletion: false))
        guard let touch = touches.first
            else { return }
        let touchLocation = touch.location(in: self)
        projectile.position = player.position
        let offset = touchLocation - projectile.position
        if offset.x < 0 {
            return
        }
        addChild(projectile)
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        let direction = offset.normalized()
        let shootAmount = direction * 1000
        let realDest = shootAmount + projectile.position
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove,actionMoveDone]))
        }
    func projectileDidCollideWithMonster(nodeA: SKSpriteNode, nodeB: SKSpriteNode) {
        print("Hit")
        nodeA.removeFromParent()
        nodeB.removeFromParent()
    }

    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        if let monster = firstBody.node as? SKSpriteNode, let
            projectile = secondBody.node as? SKSpriteNode {
            projectileDidCollideWithMonster(nodeA: monster, nodeB: projectile)
            
        }
    }
}



