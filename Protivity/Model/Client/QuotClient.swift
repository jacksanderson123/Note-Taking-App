//
//  QuotClient.swift
//  Protivity
//
//  Created by jack sanderson on 28/02/2019.
//  Copyright © 2019 jack sanderson. All rights reserved.
//

import Foundation

class QuotClient: NSObject {

    var session = URLSession.shared
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    func getRandomQuot(completionHandler: @escaping (_ success: Bool, _ photos: [AnyObject?], _ error: String?)-> Void) -> Void {
    
        let paraneters: [String: String] = [
        
        ]
    }
    
}
