//
//  DictionaryManager.swift
//  MinimalDictionary
//
//  Created by Sunny Duong on 11/18/20.
//

import Foundation
protocol DictionaryManagerDelegate{
    func didUpdateDictionary(_ dictionaryManager:DictionaryManager, dictionary:  DictionaryModel)
    func didFailWithError(error:Error)
}
struct DictionaryManager{

    let dictionaryURL = "https://wordsapiv1.p.rapidapi.com/words/"
    let headers = [
        "x-rapidapi-key": "your key",
        "x-rapidapi-host": "wordsapiv1.p.rapidapi.com"
    ]
    var delegate: DictionaryManagerDelegate?
    func fetchWord(searchWord: String){
        let definitionString = "\(dictionaryURL)\(searchWord)"
        performRequest(with: definitionString)
    }
    func performRequest(with urlString:String){
        let request = NSMutableURLRequest(url: NSURL(string:urlString)! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            if let safeData = data{
                if let dictionary = self.parseJSON(safeData){
                    self.delegate?.didUpdateDictionary(self, dictionary:dictionary)
                }
            }
        }
        task.resume()
        
    }
    func parseJSON(_ dictionaryData: Data) -> DictionaryModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(DictionaryData.self, from: dictionaryData)
            
            var definition = [String]()
            var part = [String]()
            for x in 0..<decodedData.results.count{
                definition.append(decodedData.results[x].definition)
                part.append(decodedData.results[x].partOfSpeech)
            }
            let id = decodedData.word
            let pronun = decodedData.pronunciation.all
            let dictionary = DictionaryModel(define: definition, name: id, partOfSpeech: part, pronunciation: pronun)
            return dictionary
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
}
