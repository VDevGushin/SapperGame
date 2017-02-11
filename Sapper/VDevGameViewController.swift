//
//  VDevGameViewController.swift
//  Sapper
//
//  Created by Vladislav Gushin on 10/02/2017.
//  Copyright © 2017 VladislavGushin. All rights reserved.
//

import UIKit

class VDevGameViewController: UIViewController {

    let reuseIdentifier = "cell"
    var gameSettings : GameSettings?
    var game : SapperGame!
    var gameDelegate : GameObserverDelegate!
    var initSuccess : Bool = true

    @IBOutlet weak var gameField: UICollectionView!

    @IBOutlet weak var gameModeSwitch: UISwitch!

    @IBOutlet weak var gameModeLabel: UILabel!

    @IBAction func gameModeValueChanged(_ sender: AnyObject) {
        if sender.isOn!{
            game.gameMode = .test
        }else {
            game.gameMode = .real
        }
    }

    @IBAction func endGameHandler(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func makeTestStepHandler(_ sender: AnyObject) {
        do{
            let i = Int(arc4random()) % gameSettings!.numColumnsAndRows
            let j = Int(arc4random()) % gameSettings!.numColumnsAndRows
            try game.makeStep(i,j)
            game.testPrintField()

        }catch{
            print("error")
            showErrorMessage("game error")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        gameDelegate = GameObserverDelegate(endGameAction : endGame)
        if gameSettings == nil{
            gameSettings = GameSettings(numColumnsAndRows: 9, numberOfBombs: 15)
        }
        initSuccess = initStartGame()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !initSuccess{
            showErrorMessage("Init game error")
            dismiss(animated: true, completion: nil)
        }
    }


    func initStartGame() -> Bool{
        do{
            game = try SapperGame(numbersOfField : gameSettings!.numColumnsAndRows , bombsCount : gameSettings!.numberOfBombs, gameMode: .real, delegate : gameDelegate)
            return true;

        }catch{
            print("error")
            return false
        }
    }

    func showErrorMessage(_ message : String){
        let alertController = UIAlertController(title: "Game error", message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ок", style: UIAlertActionStyle.default,handler: goBack))
        present(alertController, animated: true, completion: nil)
    }


    func endGame(isWin : Bool){
        if isWin{
            print("Win!!!!!!!")
            let alertController = UIAlertController(title: "EEeee!!!", message:
                "You win!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ок", style: UIAlertActionStyle.default,handler: goBack))
            present(alertController, animated: true, completion: nil)

        }else{
            print("Fuck!!!")
            let alertController = UIAlertController(title: "BOOooooM!!!", message:
                "You lose!", preferredStyle: UIAlertControllerStyle.alert )
            alertController.addAction(UIAlertAction(title: "Ок", style: UIAlertActionStyle.default,handler: goBack))
            present(alertController, animated: true, completion: nil)
        }
    }

    private func goBack(_ : UIAlertAction) {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

class MyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var myLabel: UILabel!
    var gameObject : GameCell!
}


extension VDevGameViewController : UICollectionViewDataSource, UICollectionViewDelegate{


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameSettings!.numColumnsAndRows
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return gameSettings!.numColumnsAndRows
    }

    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell

        cell.myLabel.text = game!.printCellValue(indexPath[0],indexPath[1])
        cell.gameObject = game!.getCellObjec(indexPath[0],indexPath[1])
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0
        cell.layer.cornerRadius = 8

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        do{
            try game.makeStep(indexPath[0],indexPath[1])

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyCollectionViewCell
            cell.myLabel.text = game!.printCellValue(indexPath[0],indexPath[1])

            collectionView.reloadData()
            game.testPrintField()

        }catch{
            print("error")
            showErrorMessage("game error")
        }
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.red
    }

    // change background color back when user releases touch
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.white
    }

}

