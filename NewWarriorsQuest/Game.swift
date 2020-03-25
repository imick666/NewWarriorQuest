//
//  Game.swift
//  NewWarriorsQuest
//
//  Created by mickael ruzel on 17/03/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

enum State {
    case ongoing, over
}
enum Action {
    case heal, attack
}
//--------------------------
// MARK: - GAME
//---------------------------
class Game {
    var players = [Player]()
    var nbPlayers = 0
    var state: State {
        var playersAlive = 0
        for player in players where !player.isDead {
            playersAlive += 1
        }

        guard playersAlive <= 1 else {
            return .ongoing
        }
        return .over
    }
    var score = Score()

    //-------------------------------------
    // MARK: - FUNCTION
    //-------------------------------------
    func startGame() {
        print("""
        Welcom in NewWarriorQuest

        This game is a RPGLike for 2 or more players
        Each player have to choose 3 characters

        """)
        generatePlayers()
        battle()
    }

    func enumerateAliveTargetPlayers(_ currentPlayer: Player) -> [Player] {
        var aliveTargetPlayers = [Player]()

        for player in players where (!player.isDead) && (player.playerNumber != currentPlayer.playerNumber) {
            aliveTargetPlayers.append(player)
        }

        return aliveTargetPlayers
    }

    func showAliveTargetPlayers(_ currentPlayer: Player) {
        for (index, player) in enumerateAliveTargetPlayers(currentPlayer).enumerated() where player.playerNumber != currentPlayer.playerNumber {
            print("\(index + 1) - \(player.nickname) -- Attack")
        }
    }
    //-------------------------------------
    // MARK: - PRIVATE FUNCTION
    //-------------------------------------
    // MARK: Utilities
    //-------------------------------------
    private func generatePlayers() {
        //--------------------------------
        // MARK: Create Players
        //--------------------------------
        //pickup numbers of players
        //repeat until less than 2 players
        repeat {
            print("How many player are you?")
            if let entry = readLine() {
                guard let number = Int(entry) else {
                    print("Invalid entry")
                    continue
                }
                nbPlayers = number
            }
        }while nbPlayers < 2
        //create players card
        //repeat for the number of player
        for playerNumber in 1 ... nbPlayers {
            let playerX = Player(playerNumber)
            players.append(playerX)
        }

        score.players = players
        showTeams()
    }

    private func battle() {
        print("\n---FIGHT---\n")
        //--------------------------
        // MARK: FIGHT
        //--------------------------
        //0 - switch on each alive player
        //1 - Select character to use
        //2 - A random weapon can appear randomly at the begin of the round
        //3 - Select what to do
        //4a - If current character is an elf
        //------------------------------------------------------------
            //5a - Choose if attack or heal
                //6aa - If heal, Show the current player team for heal
                //6ab - If attack, as than other races
        //------------------------------------------------------------
        //4b - If current character isn't an elf
        //------------------------------------------------------------
            //5ba - If 2 players : Select the othger
            //5bb - If more than 2 players :  ask witch player to target
        //------------------------------------------------------------
        //6 - Select character to target and attack him
        //7 - check if the game is over
            //------------------------------------------------------------
            //8a - If more than 1 player alive, game continue
            //------------------------------------------------------------
            //8b - If 1 player alive, game is over
            //9b - Show score table
            //------------------------------------------------------------
        //9 - Repeate loop 'till the game switch to over
        repeat {
            //count rounds
            score.round += 1
            var actions: Action = .attack
            //show round number
            print("ROUND \(score.round)")
            //0 - switch on each alive player
            for currentPlayer in players where !currentPlayer.isDead {
                //print the current player
                print("Player \(currentPlayer.playerNumber) : \(currentPlayer.nickname) ")
                //1 - Select character to use
                let currentCharacter = currentPlayer.selectCharacter()
                //show wich character have been choose
                print("You choosed \(currentCharacter.name)")
                //2 - A random weapon can appear randomly at the begin of the round
                // ternary condition for make apears random weapon with 25% of chance
                _ = Int.random(in: 0 ... 100) <= 25 ? randomWeaponAppear(for: currentCharacter) : nil
                //3 - Ask what to do if elfe chossed
                if currentCharacter.race == .elfs {
                    actions = selectAction()
                } else {
                    actions = .attack
                }
                //4 - Select target Player if attack
                    //If only 2 players, target is automatically other player
                    //If more than 2 players, select player to target
                //4 - select target character if heal
                switch actions {
                case .attack:
                    let targetPlayer = selectTargetPlayer(from: currentPlayer)
                    currentCharacter.attack(to: targetPlayer)
                case .heal:
                    currentCharacter.heal(to: currentPlayer)
                }
                //5 - check if the game is over
                if state == .over {
                    //6b - If 1 player alive, game is over
                    //7b - Show score table
                    score.showScoreTable()
                    break
                }
                //6a - If more than 1 player alive, game continue
                showTeams()
            }
        //8 - Repeate loop 'till the game switch to over
        }while state == .ongoing
    }

    private func showTeams() {
        for player in players {
            print("\nPlayer \(player.playerNumber) | Nickname : \(player.nickname)")
            for character in player.team {
                print("\(character.name) :PV : \(character.lifePoint) | Attack : \(character.weapon.attack)")
            }
        }
    }

    private func selectAction() -> Action {
        print("""
        What do you wanna do ?
        1 - Attack
        2 - Heal
        """)
        if let entry = readLine() {
            switch entry {
            case "1":
                return .attack
            case "2":
                return .heal
            default:
                print("I don't understand")
                return selectAction()
            }
        }
        return selectAction()
    }

    //select the target player if more than 2 players
    private func selectTargetPlayer(from currentPlayer: Player) -> Player {
        guard enumerateAliveTargetPlayers(currentPlayer).count != 1 else {
            return enumerateAliveTargetPlayers(currentPlayer)[0]
        }
        print("Select player you wanna target : ")
        showAliveTargetPlayers(currentPlayer)
        if let entry = readLine() {
            guard let index = Int(entry) else {
                print("Invalid entry")
                return selectTargetPlayer(from: currentPlayer)
            }
            switch index {
            case 1 ... enumerateAliveTargetPlayers(currentPlayer).count:
                return enumerateAliveTargetPlayers(currentPlayer)[index - 1]
            default:
                print("This player doesn't exist")
                return selectTargetPlayer(from: currentPlayer)
            }
        }
        return selectTargetPlayer(from: currentPlayer)
    }

     //create a random weapon
    private func randomWeaponAppear(for currentCharacter: Character) {
        let randomWeapon = Weapon.randomWeapon()

        print("""
            A new weapon has appear!!!!
            Do you wanna assign \(randomWeapon.name) to a character?
            Y / N
        """)
        if let entry = readLine() {
            switch entry {
            case "y", "Y":
                currentCharacter.weapon = randomWeapon
                print("\(currentCharacter.name) have now : \(randomWeapon.attack) attack and \(randomWeapon.heal) heal capacity")
            case "n", "N":
                print("As you want, the weapon is destroy")
            default:
                print("Invalid entry")
                return randomWeaponAppear(for: currentCharacter)
            }
        }
    }
}
