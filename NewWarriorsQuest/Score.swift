//
//  Score.swift
//  NewWarriorsQuest
//
//  Created by mickael ruzel on 19/03/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation
class Score {
    var players = [Player]()
    var round = 0
    var winner: Player {
        determinateWinner()
    }

    init() {
    }

    //player score table
    func showScoreTable() {
        print("""
            //////////////////////////
            THE WINNER IS : \(winner.nickname)!!!!!
            //////////////////////////
            """)
        for character in winner.team {
            print("""
                \(character.name) : wich is a(n) \(character.race) with \(character.lifePoint) PV |
                Weapon : \(character.weapon.name) with \(character.weapon.attack) attack and \(character.weapon.heal) heal capacity

                """)
        }
        print("//////////////////////////")

        for player in players where player.playerNumber != winner.playerNumber {
            print("Player \(player.playerNumber) - \(player.nickname)")
            for character in player.team {
                print("""
                    \(character.name) : wich is a(n) \(character.race) with \(character.lifePoint) PV |
                    Weapon : \(character.weapon.name) with \(character.weapon.attack) attack and \(character.weapon.heal) heal capacity

                    """)
            }
            print("//////////////////////////")
        }
    }

    //----------------------------
    // MARK: - PRIVATE FUNCITON
    //----------------------------
    //determine the winner
    private func determinateWinner() -> Player {

        for player in players where player.state == .alive {
            return player
        }
        return determinateWinner()
    }
}
