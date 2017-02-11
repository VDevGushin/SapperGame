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


    @IBAction func rowsAndColumnsSliderValueChanged(_ sender: UISlider) {
        let roundedValue = round(sender.value / 1) * 1
        sender.value = roundedValue
        BombsCountSlider.value = Float(BombsCountSlider.minimumValue)
        RowsAndColumnsTF.text =  String(Int(sender.value))
        BombsCountTF.text =  String(Int(BombsCountSlider.value))
        updateMaxBombsCount()
    }

    @IBAction func bombsCountValueChanged(_ sender: UISlider) {
        let roundedValue = round(sender.value / 1) * 1
        sender.value = roundedValue
        BombsCountTF.text =  String(Int(roundedValue))
    }

    @IBAction func startGameAction(_ sender: UIButton) {
        let gameSettings = GameSettings(numColumnsAndRows: Int(RowsAndColumnsSlider.value), numberOfBombs: Int(BombsCountSlider.value))
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
        RowsAndColumnsTF.text =  String(Int(RowsAndColumnsSlider.value))
        BombsCountTF.text =  String(Int(BombsCountSlider.value))
        updateMaxBombsCount()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }



    private func updateMaxBombsCount(){
        BombsCountSlider.maximumValue = Float((Int(RowsAndColumnsSlider.value) * Int(RowsAndColumnsSlider.value)) - 1)
    }
}

