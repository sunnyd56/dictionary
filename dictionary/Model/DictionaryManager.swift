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
    //let appId = "9473a6d3"
    //let appKey = "8539de0a23591f90c807ee900a2bb79b"
    //let dictionaryURL = "https://od-api.oxforddictionaries.com/api/v2/entries/en-gb/"
    let dictionaryURL = "https://wordsapiv1.p.rapidapi.com/words/"
    let headers = [
        "x-rapidapi-key": "473e5b3ec0mshe51f0ccaa481649p1e38f7jsn15e73bacbd4b",
        "x-rapidapi-host": "wordsapiv1.p.rapidapi.com"
    ]
    var delegate: DictionaryManagerDelegate?
    func fetchWord(searchWord: String){
        //let definitionString = "\(dictionaryURL)\(searchWord)?strictMatch=false"
        let definitionString = "\(dictionaryURL)\(searchWord)"
        //let etymologyString = "\(dictionaryURL)\(searchWord)?fields=etymologies&strictMatch=false"
        performRequest(with: definitionString)
        //performRequest(urlString: etymologyString)
    }
    func performRequest(with urlString:String){
        //let url = URL(string: urlString)!
        //var request = URLRequest(url: url)
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        //request.addValue(appId, forHTTPHeaderField: "app_id")
        //request.addValue(appKey, forHTTPHeaderField: "app_key")
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
//let appId = "<my_app_id>"
//    let appKey = "<my_app_key>"
//    let language = "en-gb"
//    let word = "Ace"
//    let fields = "pronunciations"
//    let strictMatch = "false"
//    let word_id = word.lowercased()
//    let url = URL(string: "https://od-api.oxforddictionaries.com:443/api/v2/entries/\(language)/\(word_id)?fields=\(fields)&strictMatch=\(strictMatch)")!
//    var request = URLRequest(url: url)
//    request.addValue("application/json", forHTTPHeaderField: "Accept")
//    request.addValue(appId, forHTTPHeaderField: "app_id")
//    request.addValue(appKey, forHTTPHeaderField: "app_key")
//
//    let session = URLSession.shared
//    _ = session.dataTask(with: request, completionHandler: { data, response, error in
//        if let response = response,
//            let data = data,
//            let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
//            print(response)
//            print(jsonData)
//        } else {
//            print(error)
//            print(NSString.init(data: data!, encoding: String.Encoding.utf8.rawValue))
//        }
//    }).resume()
