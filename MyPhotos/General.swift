//
//  General.swift
//  MyPhotos
//
//  Created by Артем Соловьенко on 14.11.16.
//  Copyright © 2016 Artem Solovenko. All rights reserved.
//

import Foundation


/// Log function with date prefix
func Logger(_ string: String) {
    print("\(Date()) " + string)
}

func Localized(_ stringToLocalize: String) -> String {
    return NSLocalizedString(stringToLocalize, comment: "")
}
