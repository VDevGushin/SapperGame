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

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initStartGame()
    }


    @IBAction func endGameHandler(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    func initStartGame(){
        do{
            let delegate = GameObserverDelegate(endGameAction : endGame)
            let game = try SapperGame(numbersOfField : gameSettings!.numColumnsAndRows , bombsCount : gameSettings!.numberOfBombs, delegate : delegate)

            try game.makeStep(0,0)
            try game.makeStep(2,2)
            try game.makeStep(0,6)
            try game.makeStep(1,6)

            game.testPrintField()

        }catch let GameErrors.bomblimit(n) {
            print("Init error \(n) (bomb limit)")
            showErrorMessage("Init error \(n) bomb limit)")
        }catch   GameErrors.outOfField{
            print("outOfField")
            showErrorMessage("outOfField")
        }catch{
            print("error")
            showErrorMessage("game error")
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
            print("Fick!!!")

            let alertController = UIAlertController(title: "Fick!!!", message:
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

}
