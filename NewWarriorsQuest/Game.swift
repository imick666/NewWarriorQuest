//
//  Game.swift
//  NewWarriorsQuest
//
//  Created by mickael ruzel on 17/03/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation
class Game{
    var players = [Player]()
    var nbPlayers = 0
        
    init(){
        repeat{
            print("How many player are you?")
            if let entry = readLine(){
                if let nb = Int(entry){
                    nbPlayers = nb
                }
            }
        }while nbPlayers < 2
        
        for playerNumber in 1 ... nbPlayers{
            let playerX = Player(playerNumber, allPlayers: players)
            players.append(playerX)
        }
        
        showTeams(players)
    }
    
    
    
    private func showTeams(_ players: [Player]){
        for p in players{
            print(p.nickname)
            for c in p.team{
                print("\(c.name) | \(c.race) | \(c.pv) | \(c.weapon.name) | \(c.weapon.attack) | \(c.weapon.heal) ")
            }
        }
    }
}

