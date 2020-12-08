//
//  DictionaryData.swift
//  MinimalDictionary
//
//  Created by Sunny Duong on 11/20/20.
//

import Foundation
struct DictionaryData: Decodable{
    let word:String
    let results:[Results]
    let pronunciation:Pronunciations
}

struct Results:Decodable{
    let definition: String
    let partOfSpeech: String
}

struct Pronunciations:Decodable{
    let all : String
}




