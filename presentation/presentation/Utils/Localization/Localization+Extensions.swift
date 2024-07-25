//
//  Localization+Extensions.swift
//  presentation
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import Foundation

extension String {
    var localized: String{
        let lang = "en"
//        let lang = if DefaultsStorage.lang == "eng" {
//            "en"
//        } else {
//            "az"
//        }
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
