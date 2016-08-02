//
//  RocolaStorage.swift
//  AudioPlayer
//
//  Created by Gerardo Villarroel on 29-07-16.
//  Copyright © 2016 Gerardo Villarroel. All rights reserved.
//

import Foundation

class RocolaStorage {
    private var artista = ["ColdPlay",
                           "MarcosYaroide",
                           "TenthAvenue",
                           "Tree63",
                           "UB40"]
    
    private var cancion = ["Paradise",
                           "Todo se lo debo a él",
                           "Healing begins",
                           "Standing on it",
                           "I can't falling in love"]
    
    private var volume: Float = 1.2
    
    func stringFromTimeInterval(interval: NSTimeInterval)-> String {
        let ti = NSInteger(interval)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
    
    var listadoArtistas: [String] {
        return artista
    }
    
    var listadoDeCanciones: [String] {
        return cancion
    }
    
    var volumenCancion: Float {
        get {
            return volume
        }
        set {
            volume = newValue
        }
    }
}