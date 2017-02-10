//
//  SapperGame.swift
//  Sapper
//
//  Created by Vladislav Gushin on 11/02/2017.
//  Copyright © 2017 VladislavGushin. All rights reserved.
//

import Foundation

protocol GameObserver : class {
    var endGameHandler :  (Bool)->() {get}
    func gameDidStart(message : String)
    func gameDidEnd(isWin : Bool)
    func stepWasTaken(success : Bool, point: (row : Int , cell : Int), message : String? )
}

enum Squear{
    case Bomb
    case Number(Int)

    var description : String{
        get{
            switch self{
            case .Bomb:
                return "💣"
            case .Number(let x):
                return String(x)
            }
        }
    }
}

enum CellStatus{
    case closeCell
    case openCell
    case boom
}

struct GameCell{
    var value :  Squear
    var staus : CellStatus

    var description : String{
        get{
            switch staus{
            case .openCell :
                switch value{
                case .Number(let x) where x == 0:
                    return "⛳"
                default :
                    return value.description
                }
            case .boom:
                return "🔥"
            default :
                return "⬜"
            }
        }
    }

    var testDescription: String{
        get{
            switch staus{
            case .openCell :
                return "⛳"
            case .boom:
                return "🔥"
            default :
                return value.description
            }
        }
    }
}

enum GameErrors: Error{
    case bomblimit(_ : Int)
    case outOfField
}


class SapperGame{

    weak var delegate : GameObserver?
    var numColumnsAndRows : Int
    var stepCount = 0
    var bombsCount : Int
    var gameField = Array<Array<GameCell>>()

    init(numbersOfField : Int, bombsCount : Int , delegate : GameObserver? = nil) throws{
        self.delegate = delegate
        numColumnsAndRows = numbersOfField
        self.bombsCount = bombsCount
        let maxBombsLimit = numColumnsAndRows * numColumnsAndRows

        guard bombsCount < maxBombsLimit else{
            throw GameErrors.bomblimit(bombsCount - maxBombsLimit)
        }

        buildGameField()
    }

    private func buildGameField(){
        gameFieldInit()
        InitFields()
        delegate?.gameDidStart(message :  "Begin game \(numColumnsAndRows) x \(numColumnsAndRows) with \(bombsCount) bombs")
        testPrintField()
    }

    //Init field
    private func InitFields(){

        var bombCounter = 0
        while(bombCounter < bombsCount){
            //let i = Int(arc4random()) % numColumnsAndRows
            //let j = Int(arc4random()) % numColumnsAndRows
            let i = Int(drand48() * 100000) % numColumnsAndRows
            let j = Int(drand48() * 100000) % numColumnsAndRows

            switch gameField[i][j].value{
            case .Bomb :
                continue
            default:
                gameField[i][j] = GameCell(value : .Bomb, staus : .closeCell)
                bombCounter += 1
            }
        }

        for i in 0..<numColumnsAndRows{
            for j in 0..<numColumnsAndRows{
                var mineCounter = 0

                if j > 0{
                    if isBomb(i , j - 1){
                        mineCounter += 1
                    }
                }

                if j < numColumnsAndRows - 1{
                    if isBomb(i , j + 1){
                        mineCounter += 1
                    }
                }

                if i > 0 {
                    if isBomb(i - 1, j){
                        mineCounter += 1
                    }
                }

                if i < numColumnsAndRows - 1 {
                    if isBomb(i + 1 , j){
                        mineCounter += 1
                    }
                }

                //angle
                if j > 0 && i > 0{
                    if isBomb(i - 1 , j - 1){
                        mineCounter += 1
                    }
                }

                if j < numColumnsAndRows - 1 && i > 0{
                    if isBomb(i - 1 , j + 1){
                        mineCounter += 1
                    }
                }

                if j > 0 && i < numColumnsAndRows - 1{
                    if isBomb(i + 1 , j - 1){
                        mineCounter += 1
                    }
                }

                if j < numColumnsAndRows - 1 && i < numColumnsAndRows - 1{
                    if isBomb(i + 1 , j + 1){
                        mineCounter += 1
                    }
                }

                if !isBomb(i,j){
                    gameField[i][j] = GameCell(value : .Number(mineCounter), staus : .closeCell)
                }
            }
        }
    }

    private func isBomb(_ i : Int, _ j : Int) -> Bool{
        switch gameField[i][j].value{
        case .Bomb:
            return true
        default:
            return false
        }
    }

    private func isEmpty(_ i : Int, _ j : Int) -> Bool{
        switch gameField[i][j].value{
        case let .Number(x) where x == 0:
            return true
        default:
            return false
        }
    }

    private func isOpen(_ i : Int, _ j : Int) -> Bool{
        switch gameField[i][j].staus{
        case .openCell:
            return true
        default:
            return false
        }
    }

    private func gameFieldInit(){
        for _ in 0 ..< numColumnsAndRows {
            var rows = [GameCell]()
            for _ in 0..<numColumnsAndRows{
                rows.append(GameCell(value : .Number(0), staus : .closeCell))
            }
            gameField.append(rows);
        }
    }

    func testPrintField(){
        print("====================")
        for i in 0..<numColumnsAndRows{
            var rowString = String()
            for j in 0..<numColumnsAndRows{
                //rowString += "\t" +  gameField[i][j].description
                rowString += "\t" +  gameField[i][j].testDescription
            }
            print(rowString)

        }
    }

    //game loop
    func makeStep(_ row: Int,_ column : Int) throws{
        if stepCount == 0 {
            delegate?.gameDidStart(message : "let's get ready to rumble")
        }

        if isOpen(row, column){
            return
        }

        stepCount += 1
        switch gameField[row][column].value{
        case .Bomb:
            gameField[row][column].staus = .boom
            delegate?.gameDidEnd(isWin: false)
        case let .Number(x) :
            gameField[row][column].staus = .openCell
            if x == 0{
                checkCellsForOpen(row,column)
            }
            delegate?.stepWasTaken(success: true, point: (row, column), message : nil)
            if checkForWin(){
                delegate?.gameDidEnd(isWin: true)
            }
        }
    }

    private func checkForWin() -> Bool{
        let nidSuccessCells = (numColumnsAndRows * numColumnsAndRows) - bombsCount
        var successField = 0
        for i in 0..<numColumnsAndRows{
            for j in 0..<numColumnsAndRows{
                switch gameField[i][j].staus{
                case .openCell:
                    successField += 1
                default:
                    break
                }
            }
        }

        if nidSuccessCells == successField{
            return true
        }
        return false
    }
    
    private func checkCellsForOpen(_ i : Int ,_ j : Int){
        if j > 0{
            if isEmpty(i , j - 1) && !isOpen(i , j - 1){
                gameField[i][j - 1].staus = .openCell
                checkCellsForOpen(i, j - 1)
            }
        }
        
        if j < numColumnsAndRows - 1{
            if isEmpty(i , j + 1) && !isOpen(i , j + 1){
                gameField[i][j + 1].staus = .openCell
                checkCellsForOpen(i, j + 1)
            }
        }
        
        if i > 0 {
            if isEmpty(i - 1, j) && !isOpen(i - 1, j){
                gameField[i - 1][j].staus = .openCell
                checkCellsForOpen(i - 1, j)
            }
        }
        
        if i < numColumnsAndRows - 1 {
            if isEmpty(i + 1 , j) && !isOpen(i + 1 , j){
                gameField[i + 1][j].staus = .openCell
                checkCellsForOpen(i + 1, j)
            }
        }
        
        //angle
        if j > 0 && i > 0{
            if isEmpty(i - 1 , j - 1) && !isOpen(i - 1 , j - 1){
                gameField[i - 1][j - 1].staus = .openCell
                checkCellsForOpen(i - 1, j - 1)
            }
        }
        
        if j < numColumnsAndRows - 1 && i > 0{
            if isEmpty(i - 1 , j + 1)  && !isOpen(i - 1 , j + 1){
                gameField[i - 1][j + 1].staus = .openCell
                checkCellsForOpen(i - 1, j + 1)
            }
        }
        
        if j > 0 && i < numColumnsAndRows - 1{
            if isEmpty(i + 1 , j - 1)  && !isOpen(i + 1 , j - 1){
                gameField[i + 1][j - 1].staus = .openCell
                checkCellsForOpen(i + 1, j - 1)
            }
        }
        
        if j < numColumnsAndRows - 1 && i < numColumnsAndRows - 1{
            if isEmpty(i + 1 , j + 1) && !isOpen(i + 1 , j + 1){
                gameField[i + 1][j + 1].staus = .openCell
                checkCellsForOpen(i + 1, j + 1)
            }
        }
    }
}
