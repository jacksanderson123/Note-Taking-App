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
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    func getRandomQuote(completionHandler: @escaping (_ success: Bool, _ photos: [AnyObject?], _ error: String?)-> Void) -> Void {
        var request = URLRequest(url: buildURL())
       // print(buildURL())
        request.httpMethod = Quote.APIMethod
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else{
                completionHandler(false, [], "Unable to establish a connection")
                return
            }
            guard let data = data else {
                completionHandler(false, [], "No results found")
                return
            }
            self.parseData(data) { (result, error) in
                
                guard error == nil else{
                    completionHandler(false, [], error)
                    return
                }
                
                guard let photos = result?["photos"] as? AnyObject,
                    let photo = photos["photo"] as? [AnyObject]  else {
                        completionHandler(false, [], "no photos attribute present")
                        return
                }
                
            }
        }
    }
    
    func parseData( _ data: Data, _ parseDataCompletionHandler: @escaping( _ result: AnyObject?, _ error: String?) -> Void) {
        var parsedData: [String:AnyObject]!  = nil
        
        do {
            parsedData = try (JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject])
        }catch{
            print("json error: \(error)")
            parseDataCompletionHandler(nil, "Could not parse the data as JSON")
            return
        }
        
        parseDataCompletionHandler(parsedData as AnyObject, nil)
    }
    
    class func currentSession() -> QuotClient {
        struct Singleton {
            static var sharedInstance = QuotClient()
        }
        return Singleton.sharedInstance
    }
}
extension QuotClient{
    
    func buildURL() -> URL {
        var url = URLComponents()
        url.scheme = Quote.APIScheme
        url.host = Quote.APIHost
        url.path = Quote.APIPath + Quote.APIParameters
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

