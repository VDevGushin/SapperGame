//
//  ViewController.swift
//  Sapper
//
//  Created by Vladislav Gushin on 10/02/2017.
//  Copyright © 2017 VladislavGushin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var RowsAndColumnsTF: UILabel!
    @IBOutlet weak var BombsCountTF: UILabel!
    @IBOutlet weak var RowsAndColumnsSlider: UISlider!
    @IBOutlet weak var BombsCountSlider: UISlider!

    var rowsAndColumnsCount = 0
    var maxBombsCount = 0
    var bombsCout = 0

    @IBAction func rowsAndColumnsSliderValueChanged(_ sender: UISlider) {
        let roundedValue = round(sender.value / 1) * 1
        sender.value = roundedValue
        bombsCout = Int(BombsCountSlider.minimumValue)
        BombsCountSlider.value = Float(bombsCout)
        rowsAndColumnsCount = Int(roundedValue)
        updateCurrentBombsNumber()
        updateRowsColumnsCountNumber()
        updateMaxBombsCount()
    }

    @IBAction func bombsCountValueChanged(_ sender: UISlider) {
        let roundedValue = round(sender.value / 1) * 1
        sender.value = roundedValue
        bombsCout = Int(roundedValue)
        updateCurrentBombsNumber()
    }

    @IBAction func startGameAction(_ sender: UIButton) {
        let gameSettings = GameSettings(numColumnsAndRows: rowsAndColumnsCount, numberOfBombs: bombsCout)
        print(gameSettings)
        performSegue(withIdentifier: "BeginGameSegue", sender: gameSettings)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BeginGameSegue" {
            if let colorViewController = segue.destination as? VDevGameViewController {
                colorViewController.gameSettings = sender as? GameSettings
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        initFields()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func initFields(){
        rowsAndColumnsCount = Int((RowsAndColumnsSlider.value))
        bombsCout = Int(BombsCountSlider.value)
        updateRowsColumnsCountNumber()
        updateCurrentBombsNumber()
        updateMaxBombsCount()
    }

    private func updateRowsColumnsCountNumber(){
        RowsAndColumnsTF.text = String(rowsAndColumnsCount)
    }

    private func updateCurrentBombsNumber(){
         BombsCountTF.text =  String(bombsCout)
    }

    private func updateMaxBombsCount(){
        maxBombsCount = (rowsAndColumnsCount * rowsAndColumnsCount) - 1
        BombsCountSlider.maximumValue = Float(maxBombsCount)
    }
}

