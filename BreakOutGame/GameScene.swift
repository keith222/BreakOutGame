//
//  GameScene.swift
//  BreakOutGame
//
//  Created by Yang Tun-Kai on 2016/10/1.
//  Copyright © 2016年 Yang Tun-Kai. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var isFingerOnpaddle = false
    
    let BallCategory: UInt32 = 0x1 << 0
    let BottomCategory: UInt32 = 0x1 << 1
    let BlockCategory: UInt32 = 0x1 << 2
    let PaddleCategory: UInt32 = 0x1 << 3
    let BorderCategory: UInt32 = 0x1 << 4
    
    override func didMove(to view: SKView) {
        
        //border
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        physicsWorld.contactDelegate = self
        
        //ball
        let ball = childNode(withName: "ball") as! SKSpriteNode
        ball.physicsBody!.applyImpulse(CGVector(dx: 100.0, dy: 100.0))
    
        //bottom
        let bottomRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        addChild(bottom)
        
        let paddle = childNode(withName: "paddle") as! SKSpriteNode
        
        //physic categorybitmask
        bottom.physicsBody!.categoryBitMask = BottomCategory
        ball.physicsBody!.categoryBitMask = BallCategory
        paddle.physicsBody!.categoryBitMask = PaddleCategory
        borderBody.categoryBitMask = BorderCategory
        ball.physicsBody!.contactTestBitMask = BottomCategory
        
        //block
        let numberOfBlocks = 8
        let blockWitdh: CGFloat = 20.0
        let totalBlocksWidth = blockWitdh * CGFloat(numberOfBlocks)
        
        let xOffset = (frame.width - totalBlocksWidth) / 2
        for i in 0..<numberOfBlocks{
//            let block = SKLabelNode
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody

        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }

        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BottomCategory {
            print("Hit bottom. First contact has been made.")
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {}
    
    func touchMoved(toPoint pos : CGPoint) {}
    
    func touchUp(atPoint pos : CGPoint) {}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch?.location(in: self)
        
        if let body = physicsWorld.body(at: touchLocation!){
            if body.node?.name == "paddle"{
                print("Began touch on paddle")
                isFingerOnpaddle = true
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isFingerOnpaddle{
            let touch = touches.first
            let touchLocation = touch?.location(in: self)
            let previousLocation = touch?.previousLocation(in: self)
            let paddle = childNode(withName: "paddle") as! SKSpriteNode
            var paddleX = paddle.position.x + ((touchLocation?.x)! - (previousLocation?.x)!)
            paddleX = max(paddleX, paddle.size.width/2)
            paddleX = min(paddleX, size.width - paddle.size.width/2)
            paddle.position = CGPoint(x: paddleX, y: paddle.position.y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isFingerOnpaddle = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
