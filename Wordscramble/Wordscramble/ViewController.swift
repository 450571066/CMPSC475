//
//  ViewController.swift
//  Wordscramble
//
//  Created by Tianqi Liu on 9/1/19.
//  Copyright © 2019 Tianqi Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        checkStage(stage: currentStage.rawValue)
    }
    enum stage:Int {
        case Ready = 0
        case Playing = 1
        case Done = 2
    }
    var currentLength:Int = 0
    var currentStage = stage.Ready
    let wordModel = WordModel()
    var randomNum: Int = 0
    var newWords: [String] = []
    var currentWord: String = ""
    var letterIndex: [Int] = []
    

    @IBOutlet weak var newWordButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var word: UILabel!
    @IBOutlet weak var letters: UISegmentedControl!
    @IBOutlet weak var length: UISegmentedControl!
    @IBOutlet weak var response: UILabel!
    
    
    @IBAction func onClickNewWord(_ sender: UIButton) {
        response.text = ""
        word.text = ""
        let selectedLength: Int = length.selectedSegmentIndex + 3
        newWords.removeAll()
        letterIndex.removeAll()
        for index in 0...selectedLength{
            letters.setEnabled(true, forSegmentAt: index)
        }
        wordModel.setCurrentWordSize(newSize: selectedLength+1)
        currentWord = wordModel.randomWord
        let displayWord = Array(currentWord.shuffled())
        for index in 0...(selectedLength){
            letters.setTitle(String(displayWord[index]), forSegmentAt: index)
        }
        currentStage = stage.Playing
        checkStage(stage: currentStage.rawValue)
        
    }
    
    @IBAction func onClickCheck(_ sender: UIButton) {
        currentStage = stage.Ready
        checkStage(stage: currentStage.rawValue)
        var newString: String = ""
        for item in newWords{
            newString = newString + item
        }
        if newString == currentWord{
            response.text = "Correct!"
        }
        else{
            response.text = "False!"
            word.text = currentWord
        }
        length.selectedSegmentIndex = currentLength
    }
    
    @IBAction func onClickUndo(_ sender: UIButton) {
        disableButton(button: checkButton)
        let _: String = newWords.popLast() ?? ""
        var newString: String = ""
        for item in newWords{
            newString = newString + item
        }
        word.text = newString
        letters.setEnabled(true, forSegmentAt: (letterIndex.popLast()!))
        if newWords.count == 0{
            disableButton(button: undoButton)
        }
    }
    
    
    @IBAction func onClickLetter(_ sender: Any) {
        enableButton(button: undoButton)
        let newLetter: String = letters.titleForSegment(at: letters.selectedSegmentIndex) ?? ""
        newWords.append(String(newLetter))
        var newString: String = ""
        for item in newWords{
            newString = newString + item
        }
        word.text = newString
        let currentIndex: Int = letters.selectedSegmentIndex

        letters.setEnabled(false, forSegmentAt: letters.selectedSegmentIndex)
        letterIndex.append(currentIndex)
        if newWords.count == currentLength + 4{
            currentStage = stage.Done
            checkStage(stage: currentStage.rawValue)
        }

    }
    
    
    @IBAction func onClickLength(_ sender: Any) {
        response.text = ""
        currentStage = stage.Ready
        checkStage(stage: currentStage.rawValue)
        response.text = ""
        word.text = ""
        newWords.removeAll()
        letterIndex.removeAll()
        currentLength = length.selectedSegmentIndex
        let newSelect: Int = length.selectedSegmentIndex + 4
        letters.removeAllSegments()
        for index in 1...newSelect{
            letters.insertSegment(withTitle: " ", at: index, animated: true)
        }
        
        
    }
    
    func enableSegment(segment: UISegmentedControl){
        for i in 0...(segment.numberOfSegments-1){
            segment.setEnabled(true, forSegmentAt: i)
        }
    }
    
    func disableSegment(segment: UISegmentedControl){
        for i in 0...(segment.numberOfSegments-1){
            segment.setEnabled(false, forSegmentAt: i)
        }
    }
    
    func enableButton(button: UIButton){
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        button.isEnabled = true
    }
    
    
    func disableButton(button: UIButton){
        button.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        button.isEnabled = false
    }
    
    func checkStage(stage: Int){
        if stage == 0{
            enableButton(button: newWordButton)
            disableButton(button: undoButton)
            disableButton(button: checkButton)
            disableSegment(segment: letters)
            enableSegment(segment: length)
        }
        else if stage == 1{
            disableButton(button: newWordButton)
            disableButton(button: undoButton)
            disableButton(button: checkButton)
            disableSegment(segment: length)
            enableSegment(segment: letters)
        }
        else if stage == 2{
            disableButton(button: newWordButton)
            enableButton(button: undoButton)
            enableButton(button: checkButton)
            disableSegment(segment: length)
            disableSegment(segment: letters)
        }
    }
    
}


