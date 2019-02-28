//
//  QuotConstants.swift
//  Protivity
//
//  Created by jack sanderson on 28/02/2019.
//  Copyright © 2019 jack sanderson. All rights reserved.
//

import Foundation

extension QuotClient{
  
    //?filter[orderby]=rand&filter[posts_per_page]=1&_jsonp=mycallback
    
    struct Quote {
        static let APIScheme = "http"
        static let APIHost = "quotesondesign.com/wp-json/posts"
        static let APIPath = "/wp-json/posts"
        static let APIMethod = "GET"
        static let APIParameters = "filter[orderby]=rand&filter[posts_per_page]=1"

    }
 
    
}

