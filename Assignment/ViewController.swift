//
//  ViewController.swift
//  Assignment
//
//  Created by Guest User on 26/06/2018.
//  Copyright © 2018 Lee Hoe Mun. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var startButtonUI: UIButton!
    @IBOutlet weak var resetButtonUI: UIButton!
    @IBOutlet weak var checkAnswerButtonUI: UIButton!
    @IBOutlet weak var giveUpButtonUI: UIButton!
    
    @IBOutlet weak var word1Text: UITextField!
    @IBOutlet weak var word2Text: UITextField!
    @IBOutlet weak var word3Text: UITextField!
    @IBOutlet weak var word4Text: UITextField!
    @IBOutlet weak var word5Text: UITextField!
    @IBOutlet weak var word6Text: UITextField!
    @IBOutlet weak var word7Text: UITextField!
    
    @IBOutlet weak var correct_1: UIImageView!
    @IBOutlet weak var correct_2: UIImageView!
    @IBOutlet weak var correct_3: UIImageView!
    @IBOutlet weak var correct_4: UIImageView!
    @IBOutlet weak var correct_5: UIImageView!
    @IBOutlet weak var correct_6: UIImageView!
    @IBOutlet weak var correct_7: UIImageView!
    
    let list1 = ["Morning","Cow","Milk","Assignment","Light","Six","Shoes"]
    let list2 = ["Mouse","Keyboard","Watch","Computer","Mobile","Windows","Ryzen"]
    let list3 = ["Ball","Human","Glasses","Bag","Water","Silver","Orange"]
    let list4 = ["Headset","Whiteboard","Fire","Laptop","Intel","Graphic","Science"]
    let list5 = ["Charger","Projector","Plug","Shuriken","Earth","Mars","playwright"]
    
    var selectedList : Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        word1Text.delegate = self
        word2Text.delegate = self
        word3Text.delegate = self
        word4Text.delegate = self
        word5Text.delegate = self
        word6Text.delegate = self
        word7Text.delegate = self
        getWord()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getWord () -> Void {
        let arrayText = [word1Text, word2Text, word3Text,word4Text,word5Text,word6Text,word7Text]
        let arrayList = [list1,list2,list3,list4,list5]
        var randomNum = Int(arc4random_uniform(UInt32(5)))
        while randomNum == selectedList {
            randomNum = Int(arc4random_uniform(UInt32(5)))
        }
        for num in 0...6 {
            arrayText[num]!.text = arrayList[randomNum][num]
        }
        selectedList = randomNum
    }
    
    @IBAction func ResetButton(_ sender: Any) {
        let arrayText = [word1Text, word2Text, word3Text,word4Text,word5Text,word6Text,word7Text]
        let arrayTick = [correct_1,correct_2,correct_3,correct_4,correct_5,correct_6,correct_7]
        for num in 0...6 {
            arrayText[num]!.isUserInteractionEnabled = false
            arrayTick[num]!.isHidden = true
        }
        getWord()
        startButtonUI.isHidden = false
        resetButtonUI.isHidden = true
        checkAnswerButtonUI.isHidden = true
        giveUpButtonUI.isHidden = true
    }
    
    @IBAction func startButton(_ sender: Any) {
        let arrayText = [word1Text, word2Text, word3Text,word4Text,word5Text,word6Text,word7Text]
        for num in 0...6 {
            arrayText[num]!.text = ""
            arrayText[num]!.isUserInteractionEnabled = true
        }
        checkAnswerButtonUI.isHidden = false
        giveUpButtonUI.isHidden = false
        startButtonUI.isHidden = true
        resetButtonUI.isHidden = false
    }
    
    @IBAction func checkButton(_ sender: Any) {
        let arrayText = [word1Text, word2Text, word3Text,word4Text,word5Text,word6Text,word7Text]
        var duplicateWord = false
        checkWordLoop:for outerNum in 0...6 {
            for num in 0...6 {
                if arrayText[outerNum]!.text!.uppercased() == arrayText[num]!.text!.uppercased() && arrayText[outerNum]!.text != "" && outerNum != num {
                    duplicateWord = true
                    let duplicateController = UIAlertController (title: "Duplicate Answer", message: "Duplicate answer found,please make sure all the answers are unique", preferredStyle: .alert)
                    let okAction = UIAlertAction (title: "Okay", style: .default, handler: nil)
                    duplicateController.addAction(okAction)
                    self.present(duplicateController,animated: true, completion: nil)
                    break checkWordLoop
                }
            }
        }
        
        if duplicateWord == false {
            var correctAns = 0
            let arrayList = [list1,list2,list3,list4,list5]
            let arrayTick = [correct_1,correct_2,correct_3,correct_4,correct_5,correct_6,correct_7]
            for index in 0...6 {
                if arrayText[index]!.text!.uppercased() == arrayList[selectedList!][index].uppercased(){
                    correctAns += 1
                    arrayTick[index]!.isHidden = false
                    arrayTick[index]!.image = #imageLiteral(resourceName: "correct")
                    arrayText[index]!.isUserInteractionEnabled = false
                }else{
                    arrayTick[index]!.isHidden = false
                    arrayTick[index]!.image = #imageLiteral(resourceName: "wrong")
                }
            }
            
            var matchingTitle : String
            var matchingMessage : String
            if correctAns == 7 {
                matchingTitle = "All Correct"
                matchingMessage = "Good job human."
                giveUpButtonUI.isHidden = true
                checkAnswerButtonUI.isHidden = true
            } else if correctAns > 5 {
                matchingTitle = "Almost There"
                matchingMessage = "There are \(correctAns) answers are correct."
            }else {
                matchingTitle = "So Bad"
                matchingMessage = "There are \(correctAns) answer(s) are correct only."
            }
            let matchingController = UIAlertController (title: matchingTitle, message: matchingMessage, preferredStyle: .alert)
            let okAction = UIAlertAction (title: "Okay", style: .default, handler: nil)
            matchingController.addAction(okAction)
            self.present(matchingController,animated: true, completion: nil)
        }
    }
    
    @IBAction func giveUpButton(_ sender: Any) {
        let arrayList = [list1,list2,list3,list4,list5]
        let arrayText = [word1Text, word2Text, word3Text,word4Text,word5Text,word6Text,word7Text]
        let arrayTick = [correct_1,correct_2,correct_3,correct_4,correct_5,correct_6,correct_7]
        let confirmGiveUpController = UIAlertController (title: "Give Up", message: "Are you sure you want to give up and show all the answer?", preferredStyle: .alert)
        let yesAction = UIAlertAction (title: "Yes", style: .default, handler: {(action:UIAlertAction)-> Void in
            for num in 0...6 {
                arrayText[num]!.text = arrayList[self.selectedList!][num]
                arrayText[num]!.isUserInteractionEnabled = false
                self.startButtonUI.isHidden = true
                self.resetButtonUI.isHidden = false
                self.checkAnswerButtonUI.isHidden = true
                self.giveUpButtonUI.isHidden = true
                arrayTick[num]!.isHidden = true
            }
        })
        let noAction = UIAlertAction (title: "No", style: .default, handler: nil)
        confirmGiveUpController.addAction(yesAction)
        confirmGiveUpController.addAction(noAction)
        self.present(confirmGiveUpController,animated: true,completion: nil)
    }
}


