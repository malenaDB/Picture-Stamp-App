//
//  Theme.swift
//  MustacheMe
//
//  Created by Malena on 11/20/20.
//  Copyright © 2020 AssistStat. All rights reserved.
//

import Foundation
import UIKit

class Theme
{
    var theme: String
    var images: [String]
    
    init ()
    {
        theme = "test"
        images = ["Mustache"]
    }
    
    init (t: String, i: [String])
    {
        theme = t
        images = i
    }
    
}

