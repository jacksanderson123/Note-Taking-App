//
//  QuotClient.swift
//  Protivity
//
//  Created by jack sanderson on 28/02/2019.
//  Copyright © 2019 jack sanderson. All rights reserved.
//

import Foundation
import UIKit
class QuotClient: NSObject {

    var session = URLSession.shared
    var dataController:DataController!
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    func getRandomQuote(completionHandler: @escaping (_ success: Bool, _ quotation: String?, _ error: String?)-> Void) -> Void {
        let parameters: [String: String] = [
            "filter[orderby]": "rand",
            "filter[posts_per_page]": "1"
        ]
        
        var request = URLRequest(url: buildURLWithParameters(parameters: parameters))
        request.httpMethod = Quote.APIMethod
      
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else{
                completionHandler(false, nil, "Unable to establish a connection")
                return
            }
            guard let data = data else {
                completionHandler(false, nil, "No results found")
                return
            }
            
            self.parseData(data) { (result, error) in
                guard error == nil else{
                    completionHandler(false, nil, error)
                    return
                }
              
                //result?.firstItem
                guard var quotes = result else{
                    completionHandler(false, nil, "Unable to handel JSon")
                    return
                }
                
                if var quote = quotes[0]["content"] as? String{
                    //Remove HTML with Reg X
                    quote = quote.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                    completionHandler(true, quote, nil)
                }
   
            }
        
        }
        task.resume()
    
    }
    
    func parseData( _ data: Data, _ parseDataCompletionHandler: @escaping( _ result:[[String : AnyObject]]?, _ error: String?) -> Void) {

        var parsedData: [[String : AnyObject]]!  = nil
     
        do {
      
            parsedData = try JSONSerialization.jsonObject(with: data , options: .allowFragments) as? [[String : AnyObject]]
        }catch{
            print("json error: \(error)")
            parseDataCompletionHandler(nil, "Could not parse the data as JSON")
            return
        }
   
        parseDataCompletionHandler(parsedData as [[String : AnyObject]], nil)
    }
    
    class func currentSession() -> QuotClient {
        struct Singleton {
            static var sharedInstance = QuotClient()
        }
        return Singleton.sharedInstance
    }
}
extension QuotClient{
     func buildURLWithParameters(parameters: [String:String]) -> URL {
        var url = URLComponents()
        url.scheme = Quote.APIScheme
        url.host = Quote.APIHost
        url.path = Quote.APIPath
        url.queryItems = [URLQueryItem]()
        for(key, value) in parameters {
            let queryItems = URLQueryItem(name: key, value: value)
            url.queryItems?.append(queryItems)
        }
        return url.url!
    }
    
    
    func displayError(_ description: String, _ viewController: UIViewController) {
        let alert = UIAlertController(title: "Something went wrong!", message: description, preferredStyle: .alert)
        let alertButton = UIAlertAction(title: "Okay", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(alertButton)
        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}

