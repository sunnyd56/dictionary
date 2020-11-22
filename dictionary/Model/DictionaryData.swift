//
//  DictionaryData.swift
//  MinimalDictionary
//
//  Created by Sunny Duong on 11/20/20.
//

import Foundation
struct DictionaryData: Decodable{
    //let results:[Results]
    let word:String
    let results:[Results]
    let pronunciation:Pronunciations
}

struct Results:Decodable{
    let definition: String
    let partOfSpeech: String
    //let examples:[String]
}

//
//struct LexicalEntires:Decodable{
//
//    let entries:[Entries]
//}
//
//struct Entries:Decodable{
//   // let etymologies:[String]// *****
//    let senses:[Senses]
//    //let pronunciations:[Pronunciations]
//}
//
//struct Senses:Decodable{
//   let definitions : [String] // ******
//}
//
struct Pronunciations:Decodable{
    let all : String
}




