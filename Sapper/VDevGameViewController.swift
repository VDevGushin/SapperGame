//
//  VDevGameViewController.swift
//  Sapper
//
//  Created by Vladislav Gushin on 10/02/2017.
//  Copyright © 2017 VladislavGushin. All rights reserved.
//

import UIKit

class VDevGameViewController: UIViewController {

    var gameSettings : GameSettings?
    var game : SapperGame!
    var gameDelegate : GameObserverDelegate!
    var gameMode : GameMode?

    @IBOutlet weak var gameField: UICollectionView!

    @IBOutlet weak var gameModeSwitch: UISwitch!

    @IBOutlet weak var gameModeLabel: UILabel!

    @IBAction func gameModeValueChanged(_ sender: AnyObject) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initStartGame()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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

    func initStartGame(){
        do{

            gameDelegate = GameObserverDelegate(endGameAction : endGame)
            game = try SapperGame(numbersOfField : gameSettings!.numColumnsAndRows , bombsCount : gameSettings!.numberOfBombs, gameMode: gameMode ?? .real, delegate : gameDelegate)

        }catch let GameErrors.bomblimit(n) {
            print("Init error \(n) (bomb limit)")
            //showErrorMessage("Init error \(n) bomb limit)")
        }catch   GameErrors.outOfField{
            print("outOfField")
           // showErrorMessage("outOfField")
        }catch{
            print("error")
           //showErrorMessage("game error")
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
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
}

class MyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var myLabel: UILabel!
}


extension VDevGameViewController : UICollectionViewDataSource, UICollectionViewDelegate{


    // MARK: - UICollectionViewDataSource protocol


    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameSettings!.numColumnsAndRows
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return gameSettings!.numColumnsAndRows
    }

    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell

        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.myLabel.text = game!.printCellValue(indexPath[0],indexPath[1])
        cell.backgroundColor = UIColor.white // make cell more visible in our example project
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0
        cell.layer.cornerRadius = 8

        return cell
    }

    // MARK: - UICollectionViewDelegate protocol

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        do{
            try game.makeStep(indexPath[0],indexPath[1])

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyCollectionViewCell

            cell.myLabel.text = game!.printCellValue(indexPath[0],indexPath[1])

            //collectionView.reloadItems(at: [indexPath])
            collectionView.reloadData()
            game.testPrintField()

        }catch{
            print("error")
            showErrorMessage("game error")
        }
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.red
    }

    // change background color back when user releases touch
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.white
    }

}

