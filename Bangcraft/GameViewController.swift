//
//  GameViewController.swift
//  Bangcraft
//
//  Created by Ethan Bang on 5/3/18.
//  Copyright © 2018 Ethan Bang. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size:view.bounds.size)
        let skView = view as! SKView
        
        //view fps
        skView.showsFPS = true
        //the scale of the game scene
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
}
}
