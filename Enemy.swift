//
//  File.swift
//  FightingWarplanes
//
//  Created by 裴雷 on 15/02/2017.
//  Copyright © 2017 Rachel Liu. All rights reserved.
//

import SpriteKit

class Enemy : SKSpriteNode {
    
    private var _weapon : Weapon?
    // private var _score : Int32?
    private var _hearts : Int32?  // this is regarding to blood
    
    var weapon : Weapon {
        get {
            return _weapon!
        } set {
            _weapon = newValue
        }
    }
    
    var heart : Int32 {
        get {
            return _hearts!
        } set {
            _hearts = newValue
        }
    }
    

    
}
