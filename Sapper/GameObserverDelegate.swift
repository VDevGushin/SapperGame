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

    init(endGameAction  : @escaping (Bool)->()){
        self.endGameHandler = endGameAction
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
