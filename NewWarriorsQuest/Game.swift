//
//  Game.swift
//  NewWarriorsQuest
//
//  Created by mickael ruzel on 17/03/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

//--------------------------
//MARK: GAME
//---------------------------
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
            print("Player \(currentPlayer.playerNumber) : \(currentPlayer.nickname) ")
            let currentCharacter = selectCharacter(currentPlayer)
            print(currentCharacter.name)
            whatToDo(for: currentPlayer, with: currentCharacter)
            showTeams(players)
        }
    }
    
    
    //-------------------------------------
    //MARK: PRIVATE FUNCTION
    //-------------------------------------
    private func showTeams(_ players: [Player]){
        for p in players{
            print("\nPlayer \(p.playerNumber) | Nickname : \(p.nickname)")
            for c in p.team{
                print("\(c.name) :PV : \(c.pv) | Attack : \(c.weapon.attack)")
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
    
    private func whatToDo(for currentPlayer: Player, with currentCharacter: Character){
        print("""
What do you wanna do?
    1 - Attack
    2 - Heal
""")
        if let answer = readLine(){
            switch answer {
            case "1":
                attack(from: currentPlayer, with: currentCharacter)
            case "2":
                heal(in: currentPlayer, with: currentCharacter)
            default:
                print("Invalid entry")
                whatToDo(for: currentPlayer, with: currentCharacter)
            }
        }
    }
    
    private func attack(from currentPlayer: Player, with currentCharacter: Character){
        let targetPlayer = selectTargetPlayer(currentPlayer)
        
        print("select character you wanna attack : ")
        for (index, character) in targetPlayer.team.enumerated(){
            print("\(index + 1) - \(character.name) with \(character.pv) PV")
        }
        if let entry =  readLine(){
            if let index = Int(entry){
                targetPlayer.team[index - 1].pv -= currentCharacter.weapon.attack
            }
        }
        
    }
    
    private func heal(in currentPlayer: Player, with currentCharacter: Character){
        print("who do you wanna heal?")
        for (index, character) in currentPlayer.team.enumerated(){
            print("\(index + 1) - \(character.name) with \(character.pv) PV")
        }
        if let entry = readLine(){
            if let index = Int(entry){
                currentPlayer.team[index - 1].pv += currentCharacter.weapon.heal
            }
        }
    }
    
    private func selectTargetPlayer(_ currentPlayer: Player) -> Player{
        var targetPlayerList = [Player]()
        
        for player in players{
            if player.playerNumber != currentPlayer.playerNumber{
                targetPlayerList.append(player)
            }
        }
        if targetPlayerList.count > 1 {
            print(" Select the player you wanna target : ")
            for (index, player) in targetPlayerList.enumerated(){
                print("\(index + 1) - \(player.nickname)")
            }
            if let entry = readLine(){
                if let index = Int(entry){
                    return targetPlayerList[index - 1]
                }
            }
        }
        
        return targetPlayerList[0]
        
    }
    
}

