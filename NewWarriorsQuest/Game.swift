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
        //pickup numbers of players
        //repeat until less than 2 players
        repeat{
            print("How many player are you?")
            if let entry = readLine(){
                if let nb = Int(entry){
                    nbPlayers = nb
                }
            }
        }while nbPlayers < 2
        
        //create players card
        //repeat for the number of player
        for playerNumber in 1 ... nbPlayers{
            let playerX = Player(playerNumber, in: players)
            players.append(playerX)
        }
        
        showTeams(players)
        
        for currentPlayer in players{
            let currentCharacter = selectCharacter(currentPlayer)
            print(currentCharacter.name)
        }
    }
    
    
    
    private func showTeams(_ players: [Player]){
        for p in players{
            print("Player \(p.playerNumber) | Nickname : \(p.nickname)")
            for c in p.team{
                print("""
                \(c.name)
                PV : \(c.pv) | Attack : \(c.weapon.attack)
                    
                """)
            }
        }
    }
    
    //select character to use
    private func selectCharacter(_ currentPlayer: Player) -> Character{
        var characterIndex = 0
        
        print("Select your character :")
        for (index, character) in currentPlayer.team.enumerated(){
            print("""
                \(index + 1) : \(character.name)
                PV : \(character.pv) | Attack : \(character.weapon.attack)
                """)
        }
        if let entry = readLine(){
            guard let answer = Int(entry) else{
                print("Invalid entry, please choose a character")
                return selectCharacter(currentPlayer)
            }
            guard (answer - 1) < currentPlayer.team.count else{
                print("this player doesn't exist")
                return selectCharacter(currentPlayer)
            }
            characterIndex = (answer - 1)
        }
        return currentPlayer.team[characterIndex]
    }
    
}

