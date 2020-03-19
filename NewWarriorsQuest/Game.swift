//
//  Game.swift
//  NewWarriorsQuest
//
//  Created by mickael ruzel on 17/03/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

enum State{
    case ongoing, over
}
//--------------------------
//MARK: GAME
//---------------------------
class Game{
    var players = [Player]()
    var nbPlayers = 0
    var state: State = .over
        
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
        
        showTeams()
        //--------------------------
        //MARK: FIGHT
        //--------------------------
        state = .ongoing
        while state == .ongoing{
            //switch on each player to each round
            for currentPlayer in players{
                //print the current player
                print("Player \(currentPlayer.playerNumber) : \(currentPlayer.nickname) ")
                //select the current character
                let currentCharacter = selectCharacter(currentPlayer)
                //show wich character have been choose
                print(currentCharacter.name)
                //ask wich action to do
                actions(for: currentPlayer, with: currentCharacter)
                //check if characters are dead or if the game is over
                checkState()
            }
        }
        
    }
    
    
    //-------------------------------------
    //MARK: PRIVATE FUNCTION
    //-------------------------------------
    private func showTeams(){
        for player in players{
            print("\nPlayer \(player.playerNumber) | Nickname : \(player.nickname)")
            for character in player.team{
                print("\(character.name) :PV : \(character.pv) | Attack : \(character.weapon.attack)")
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
        guard let entry = Int(readLine()!) else{
            print("Invalid entry, please choose a character")
            return selectCharacter(currentPlayer)
        }
        switch entry{
        case 1 ... currentPlayer.team.count:
            characterIndex = (entry - 1)
        default:
            print("This character doesn't exist")
            return selectCharacter(currentPlayer)
        }
        
        return currentPlayer.team[characterIndex]
    }
    
    //ask what to do
    private func actions(for currentPlayer: Player, with currentCharacter: Character){
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
                actions(for: currentPlayer, with: currentCharacter)
            }
        }
    }
    
    private func attack(from currentPlayer: Player, with currentCharacter: Character){
        let targetPlayer = selectTargetPlayer(currentPlayer)
        
        print("select character you wanna attack : ")
        for (index, character) in targetPlayer.team.enumerated(){
            print("\(index + 1) - \(character.name) with \(character.pv) PV")
        }
        guard let entry = Int(readLine()!) else{
            print("Invalid entry")
            return attack(from: currentPlayer, with: currentCharacter)
        }
            
        switch entry {
        case 1 ... targetPlayer.team.count:
            targetPlayer.team[entry - 1].pv -= currentCharacter.weapon.attack
        default:
            print("Invalid entry")
            return attack(from: currentPlayer, with: currentCharacter)
        }
    }
    
    private func heal(in currentPlayer: Player, with currentCharacter: Character){
        print("who do you wanna heal?")
        for (index, character) in currentPlayer.team.enumerated(){
            print("\(index + 1) - \(character.name) with \(character.pv) PV")
        }
        guard let entry = Int(readLine()!) else{
            print("Invalid entry")
            return heal(in: currentPlayer, with: currentCharacter)
        }
        switch entry {
        case 1 ... currentPlayer.team.count:
            currentPlayer.team[entry - 1].pv += currentCharacter.weapon.heal
        default:
            print("Invalid entry")
            return heal(in: currentPlayer, with: currentCharacter)
        }
    }
    
    //select the target player
    private func selectTargetPlayer(_ currentPlayer: Player) -> Player{
        var targetList = [Player]()
        var targetIndex = Int()
        
        for player in players{
            if player.playerNumber != currentPlayer.playerNumber{
                targetList.append(player)
            }
        }
        guard targetList.count > 1 else {
            return targetList[0]
        }
        //if more than 2 players, this code is execute
        for (index, player) in targetList.enumerated(){
            print("\(index + 1) - \(player.nickname)")
        }
        guard let entry = Int(readLine()!) else {
            print("Invalid entry")
            return selectTargetPlayer(currentPlayer)
        }
        switch entry {
        case 1 ... targetList.count:
            targetIndex = (entry - 1)
        default:
            print("This player doesn't exist")
            return selectTargetPlayer(currentPlayer)
        }
        
        return targetList[targetIndex]
    }
    
    private func checkState(){
        for player in players{
            for (index, character) in player.team.enumerated(){
                if character.pv <= 0{
                    player.team.remove(at: index)
                }
            }
            if player.team.isEmpty{
                state = .over
            }
        }
    }
}

