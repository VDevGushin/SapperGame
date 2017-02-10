//
//  GameObserverDelegate.swift
//  Sapper
//
//  Created by Vladislav Gushin on 11/02/2017.
//  Copyright © 2017 VladislavGushin. All rights reserved.
//

import Foundation

class GameObserverDelegate : GameObserver{
    internal var endGameHandler :  (Bool)->()
    internal var cellWasOpenInAnalizeHandler  : ((Int, Int))->()


    init(endGameAction  : @escaping (Bool)->() , cellWasOpenInAnalizeHandler: @escaping  ((Int, Int))->()){
        self.endGameHandler = endGameAction
        self.cellWasOpenInAnalizeHandler = cellWasOpenInAnalizeHandler
    }

    func cellWasOpenInAnalize(_ param : (Int, Int)){
        cellWasOpenInAnalizeHandler(param)
    }

    func gameDidStart(message : String){
        print(message)
    }
    func gameDidEnd(isWin : Bool){
        endGameHandler(isWin)
    }
    func stepWasTaken(success : Bool, point: (row : Int , cell : Int),  message : String? = nil){
        if message != nil{
            print(message!)
        }
        if success{
            print("Step [\(point.row)][\(point.cell)] - success")
        }else{
            print("Step [\(point.row)][\(point.cell)] - fali")
        }
    }
}
