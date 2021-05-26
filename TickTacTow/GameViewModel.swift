//
//  GameViewModel.swift
//  TickTacTow
//
//  Created by Dave Agyakwa on 25/05/2021.
//

import SwiftUI


final class GameViewModel:ObservableObject{

    @Published  var moves :[Move?] = Array(repeating: nil, count: 9)
    @Published  var isGameboardDisabled = false
    @Published  var alertItem:AlertItem?

    let items :[GridItem]=[GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]




    func isCircleOccupied(in moves:[Move?],for index:Int)->Bool{
       return   moves.contains(where: {
            $0?.boardIndex == index
        })
    }



    func processPlayers(for position:Int) -> Void {

            //Human move
            if isCircleOccupied(in: moves, for: position) {return}
            moves[position] = Move(player:.human , boardIndex: position)
           //check for win condition or draw
            if checkWin(for: .human, in: moves){
                alertItem = AlertContext.humanWins
                return
            }

            //checking for draw
            if checkForDraw(in: moves){
               alertItem = AlertContext.draw
                return
            }
            isGameboardDisabled = true


            //computer move
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { [self] in
                let computerPosition = makeComputerMovePosition(in: moves)
                moves[computerPosition] = Move(player:.computer, boardIndex: computerPosition)
                isGameboardDisabled = false
                if checkWin(for: .computer, in: moves){
                    print("Computer wins")
                    alertItem = AlertContext.computerWins
                    return
                }

                if checkForDraw(in: moves){
                   alertItem = AlertContext.draw
                    print("Computer Draws")
                    return
                }

            }

    }






    func makeComputerMovePosition(in moves:[Move?]) -> Int {
        //if A.I can win ,then win
        let winPattern :Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,4,8],[2,4,6],[0,3,6],[1,4,7],[2,5,8]]

        let computerMoves = moves.compactMap{$0 }.filter{
            $0.player == .computer}

            let computerPositions = Set(computerMoves.map{$0.boardIndex })

        for pattern in winPattern {
            let winPositions = pattern.subtracting(computerPositions)
            if winPositions.count == 1{
                let iswinAvailable = !isCircleOccupied(in: moves, for:  winPositions.first!)
                if iswinAvailable {
                    return winPositions.first!
                }
            }
        }

        //If A.I can't win then block
        let humanMoves = moves.compactMap{$0 }.filter{
            $0.player == .human}
            let humanPositions = Set(humanMoves.map{$0.boardIndex })
        for pattern in winPattern {
            let winPositions = pattern.subtracting(humanPositions)
            if winPositions.count == 1{
                let isBlockAvailable = !isCircleOccupied(in: moves, for:  winPositions.first!)
                if isBlockAvailable {
                    return winPositions.first!
                }
            }
        }
        //if A.I can't block then take middle
        let centreCircle = 4
        if !isCircleOccupied(in: moves, for: centreCircle){
            return centreCircle
        }

        //if A.I can take middle ,then take random available circle
        var movePosition = Int.random(in: 0..<9)
        while isCircleOccupied(in: moves, for: movePosition ){
             movePosition = Int.random(in: 0..<9)
        }
            return movePosition
    }

    func checkWin(for player:PlayerType,in moves:[Move? ])->Bool{
        let winPattern :Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,4,8],[2,4,6],[0,3,6],[1,4,7],[2,5,8]]

        let playersMoves = moves.compactMap{$0 }.filter{
            $0.player == player}

            let playerPositons = Set(playersMoves.map{$0.boardIndex })

            for pattern in winPattern where pattern.isSubset(of:playerPositons){
                return true
            }
            return false


    }

    func checkForDraw(in moves:[Move?])->Bool{
        return moves.compactMap { $0 }.count == 9
    }

    func resetGame(){
        moves = Array(repeating: nil, count: 9)
    }
}


enum  PlayerType {
   case human
   case computer
}


struct Move {
    let player:PlayerType
    let boardIndex:Int

    var indicator:String{
        return player == .human ? "hare":"tortoise"
    }

}
