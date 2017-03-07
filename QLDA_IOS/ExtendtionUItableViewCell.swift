//
//  ExtendtionUItableViewCell.swift
//  QLDA_IOS
//
//  Created by Hoang The Anh on 22/02/2017.
//  Copyright © 2017 datlh. All rights reserved.
//

import Foundation

extension UILabel {
    func decideTextDirection () {
        let tagScheme = [NSLinguisticTagSchemeLanguage]
        let tagger    = NSLinguisticTagger(tagSchemes: tagScheme, options: 0)
        tagger.string = self.text
        let lang      = tagger.tag(at: 0, scheme: NSLinguisticTagSchemeLanguage,
                                   tokenRange: nil, sentenceRange: nil)
        
      
            self.textAlignment = NSTextAlignment.right
       
}
/*
extension UITableViewCell {
    static var defaultReuseIdentifier : String {
        get {
            return String(describing: self)
        }
    }
    
}
*/
}
