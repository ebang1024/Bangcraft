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
 
    override func didMove(to view: SKView)
        
    {
        //placing our player sprite
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        
        //adding the sprite
        addChild(player)
        
       let backgroundMusic = SKAudioNode(fileNamed: "gameMusic.mp3")
       backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
}
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        run(SKAction.playSoundFileNamed("GAWRSH!!.mp3", waitForCompletion: false))
        guard let touch = touches.first
            else { return }
        
        let touchLocation = touch.location(in: self)
        
        let projectile = SKSpriteNode (imageNamed: "FEH_Orb")
        
        projectile.position = player.position
        
        let offset = touchLocation - projectile.position
        if offset.x < 0 {
            return
        }
        addChild(projectile)
        let direction = offset.normalized()
        let shootAmount = direction * 1000
        let realDest = shootAmount + projectile.position
        
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove,actionMoveDone]))
    }
}
