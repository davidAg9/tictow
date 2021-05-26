//
//  Alerts.swift
//  TickTacTow
//
//  Created by Dave Agyakwa on 25/05/2021.
//

import SwiftUI


struct AlertItem :Identifiable{

    let id  = UUID()
    var Title:Text
    var message:Text
    var buttonTitle:Text


}



struct AlertContext {
  static  let humanWins=AlertItem(Title:Text( "Winner!"),
                           message: Text("Your Rocked that board,Our A.I froze"),
                           buttonTitle:Text( "Ooh yeah! "))


   static let computerWins=AlertItem(Title:Text( "Loser!"),
                           message: Text("You Lost TickTackTow to an A.I"),
                           buttonTitle:Text( "Grrr!,Try Again"))

   static let draw = AlertItem(Title:Text( "Draw!"),
                           message: Text("Believe it  or not you tied with our dumb A.I,"),
                           buttonTitle:Text( "C'mon! rematch!"))

}
