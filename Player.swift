//
//  Player.swift
//  FightingWarplanes
//
//  Created by 裴雷 on 08/02/2017.
//  Copyright © 2017 Rachel Liu. All rights reserved.
//

import SpriteKit

class Player : SKSpriteNode {
    
    func movePlayer(moveLeft: Bool) {
        if moveLeft {
            self.position.x = self.position.x - 7;
        } else {
            self.position.x = self.position.x + 7;
        }
    }
    
}
