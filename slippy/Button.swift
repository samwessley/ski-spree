//
//  Button.swift
//  slippy
//
//  Created by Sam Wessley on 5/15/19.
//  Copyright © 2019 Sam Wessley. All rights reserved.
//

import SpriteKit
import StoreKit

class Button: SKSpriteNode {
    var isTouched = false
    var isActive = false
    var isToggle = false
    
    var isUnlocked: Bool?
    var product: SKProduct?
    
    var defaultTexture: SKTexture
    var pressedTexture: SKTexture
    var activatedTexture: SKTexture?
    var activatedPressedTexture: SKTexture?
    
    //Variables for Ride Select-style buttons
    var defaultLockedTexture: SKTexture?
    var pressedLockedTexture: SKTexture?

    //Basic initializer for button without label or toggle
    init(defaultTexture: SKTexture, pressedTexture: SKTexture) {
        self.defaultTexture = defaultTexture
        self.pressedTexture = pressedTexture
        
        super.init(texture: defaultTexture, color: .clear, size: defaultTexture.size())
    }
    
    //Initializer for button with one-line label
    init(defaultTexture: SKTexture, pressedTexture: SKTexture, firstLabel: String) {
        self.defaultTexture = defaultTexture
        self.pressedTexture = pressedTexture
        
        super.init(texture: defaultTexture, color: .clear, size: defaultTexture.size())
        
        addLabels(labels: [firstLabel])
    }
    
    //Initializer for button with two-line label
    init(defaultTexture: SKTexture, pressedTexture: SKTexture, firstLabel: String, secondLabel: String) {
        self.defaultTexture = defaultTexture
        self.pressedTexture = pressedTexture
        
        super.init(texture: defaultTexture, color: .clear, size: defaultTexture.size())

        addLabels(labels: [firstLabel, secondLabel])
    }
    
    //Initializer for ride select button
    init(defaultLockedTexture: SKTexture, pressedLockedTexture: SKTexture) {
        self.defaultLockedTexture = defaultLockedTexture
        self.pressedLockedTexture = pressedLockedTexture
        self.defaultTexture = SKTexture(imageNamed: "select_button")
        self.pressedTexture = SKTexture(imageNamed: "select_button_pressed")
        self.activatedTexture = SKTexture(imageNamed: "selected_button")
        self.isToggle = true
        
        super.init(texture: defaultTexture, color: .clear, size: defaultTexture.size())
    }
    
    //Initializer for button with label and toggle
    init(defaultTexture: SKTexture, pressedTexture: SKTexture, activatedTexture: SKTexture, activatedPressedTexture: SKTexture, firstLabel: String, secondLabel: String) {
        self.defaultTexture = defaultTexture
        self.pressedTexture = pressedTexture
        self.activatedTexture = activatedTexture
        self.activatedPressedTexture = activatedPressedTexture
        self.isToggle = true
        
        super.init(texture: defaultTexture, color: .clear, size: defaultTexture.size())
        
        addLabels(labels: [firstLabel, secondLabel])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addLabels(labels: [String]) {
        var iteration = 0
        
        for label in labels {
            let line = SKLabelNode(text: label.uppercased())
            line.name = "line"
            line.fontName = "Quick"
            line.fontSize = 24
            line.horizontalAlignmentMode = .right
            line.setScale(0.5)
            line.position = CGPoint(x: -self.size.width, y: 20 - CGFloat(15*iteration))
            self.addChild(line)
            iteration += 1
        }
    }
}
