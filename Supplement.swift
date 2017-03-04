//
//  Supplement.swift
//  FightingWarplanes
//
//  Created by 裴雷 on 15/02/2017.
//  Copyright © 2017 Rachel Liu. All rights reserved.
//

import SpriteKit

/**
 this is the base class for all the supplement
 */
class Supplement : SKSpriteNode {
    
    private var _laser : Laser?
    private var _missile : Missile?
    
    var laser : Laser {
        get {
            return _laser!
        } set {
            _laser = newValue
        }
    }
    
    var missile : Missile {
        get {
            return _missile!
        } set {
            _missile = newValue
        }
    }
}
