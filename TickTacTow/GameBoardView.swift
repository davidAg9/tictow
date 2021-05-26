//
//  GameBoardView.swift
//  TickTacTow
//
//  Created by Dave Agyakwa on 24/05/2021.
//

import SwiftUI

struct GameBoardView: View {
    @StateObject private var viewModel = GameViewModel()


    var body: some View {

        GeometryReader { geometry in
            VStack{

                Spacer()
                LazyVGrid(columns:viewModel.items ,spacing:5) {
                    ForEach(0..<9) { item in
                        GameBoard(proxy:geometry,
                                  systemIconName: viewModel.moves[item]?.indicator  ?? "",
                                  selectedCircle:item,
                                  viewModel: viewModel
                                 )
                        }
                    }
                Spacer()
                }


            }
        .background(Color.secondary.ignoresSafeArea(.all))
            .disabled(viewModel.isGameboardDisabled)
            .padding()
            .alert(item: $viewModel.alertItem, content: { item in
                Alert(title: item.Title,
                      message: item.message,
                      dismissButton: .default(item.buttonTitle, action: {
                        viewModel.resetGame()
                }))
            })
        }


}

   




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameBoardView()
    }
}

struct GameBoard: View {
    var proxy :GeometryProxy
    var systemIconName:String
    var selectedCircle:Int
    var viewModel:GameViewModel
    var body: some View {
        ZStack{

            Circle()
                .foregroundColor(.black)
                .opacity(0.7)
                .frame(width:( proxy.size.width/3)-15, height: (proxy.size.width/3)-15, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

            Image(systemName:systemIconName).resizable().frame(width: 50, height: 50, alignment: .center).foregroundColor(.orange)
        }
        .onTapGesture {
            viewModel.processPlayers(for: selectedCircle)

        }
    }
}
