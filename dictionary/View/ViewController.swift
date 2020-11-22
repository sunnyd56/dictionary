//
//  ViewController.swift
//  dictionary
//
//  Created by Sunny Duong on 11/16/20.
//

import UIKit
import AVFoundation
class ViewController: UIViewController,UITextFieldDelegate, DictionaryManagerDelegate {
       
    var player: AVAudioPlayer?
    @IBOutlet weak var word: UILabel!
    @IBOutlet weak var pronunciation: UILabel!
    @IBOutlet weak var definitionLabel: UILabel!
    @IBOutlet weak var partOfSpeech: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var example: UILabel!
    var dictionaryManager = DictionaryManager()
    override func viewDidLoad() {
        searchTextField.delegate = self
        dictionaryManager.delegate=self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let word = searchTextField.text!
        dictionaryManager.fetchWord(searchWord: word)
        searchTextField.text = ""
    }
    func didUpdateDictionary(_ dictionaryManager:DictionaryManager, dictionary:  DictionaryModel){
        var definitions = String()
        for x in 0..<dictionary.define.count{
            definitions += "\(x+1) \(dictionary.define[x]) \n\n"
        }
        DispatchQueue.main.async {
            
            self.definitionLabel.text = definitions
            self.word.text = dictionary.name
            self.pronunciation.text = "/\(dictionary.pronunciation)/"
            //self.example.text = dictionary.examples
            self.partOfSpeech.text = dictionary.partOfSpeech[0]
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

