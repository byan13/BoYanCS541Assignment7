//
//  GameOverScene.swift
//  Endgame
//
//  Created by Bo Yan on 12/7/19.
//  Copyright © 2019 Bo Yan. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.backgroundColor = SKColor.black
        let message = "GAME OVER"
        let label = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        label.text = message
        label.fontColor = SKColor.white
        label.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        
        addChild(label)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let transition = SKTransition.fade(withDuration: 0.5)
        let gameStartScene = GameStartScene(size: self.size)
        gameStartScene.scaleMode = .aspectFit
        self.view?.presentScene(gameStartScene, transition: transition)
    }
}
