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
        
    }
    
    let wordModel = WordModel()
    var randomNum: Int = 0
    var newWords: [String] = []
    var currentWord: String = ""
    var letterIndex: [Int] = []
    
    @IBOutlet weak var word: UILabel!
    @IBOutlet weak var letters: UISegmentedControl!
    @IBOutlet weak var length: UISegmentedControl!
    @IBOutlet weak var response: UILabel!
    

    @IBAction func onClickNewWord(_ sender: UIButton) {
        word.text = ""
        let selectedLength: Int = length.selectedSegmentIndex + 3
        newWords.removeAll()
        letterIndex.removeAll()
        for index in 0...selectedLength{
            letters.setEnabled(true, forSegmentAt: index)
        }
        wordModel.setCurrentWordSize(newSize: length.selectedSegmentIndex + 4)
        currentWord = wordModel.randomWord
        let displayWord = Array(currentWord)
        for index in 0...(length.selectedSegmentIndex + 3){
            letters.setTitle(String(displayWord[index]), forSegmentAt: index)
        }
        
    }
    
    @IBAction func onClickCheck(_ sender: UIButton) {
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
    }
    
    @IBAction func onClickUndo(_ sender: UIButton) {
        if newWords.count == 0{
            
        }
        else{
            let _: String = newWords.popLast() ?? ""
//            let lastIndex: Int = letterIndex.popLast() ?? -1
//            print(lastIndex)
            var newString: String = ""
            for item in newWords{
                newString = newString + item
            }
            word.text = newString
            letters.setEnabled(true, forSegmentAt: (letterIndex.popLast()!))
        }
    }
    
    @IBAction func onClickLetter(_ sender: Any) {
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
        print(currentIndex)
        //letters.selectedSegmentIndex = -1
    }
    
    
    @IBAction func onClickLength(_ sender: Any) {
        response.text = ""
        word.text = ""
        newWords.removeAll()
        letterIndex.removeAll()
        let newSelect: Int = length.selectedSegmentIndex + 4
        letters.removeAllSegments()
        for index in 1...newSelect{
            letters.insertSegment(withTitle: " ", at: index, animated: true)
        }
        
    }
}


