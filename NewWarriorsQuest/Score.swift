//
//  Score.swift
//  NewWarriorsQuest
//
//  Created by mickael ruzel on 19/03/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation
class Score{
    var players: [Player]
    var winner: Player
    
    
    init(players: [Player], winner: Player) {
        self.players = players
        self.winner = winner
        
        print("""
/////////////////////////////////
THE WINNER IS:
    \(winner.nickname)!
Congratulation!!!
---------------------------------
""")
        for player in players{
            print("""
Player \(player.playerNumber) : \(player.nickname)
---------------------------------
""")
            for character in player.team{
                print("""
\(character.race) : \(character.name), \(character.pv) PV, \(character.weapon.name) as weapon

""")
            }
        }
    }
}
