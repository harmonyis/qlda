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
    
    static public var idNotification : Int? = 0
    
    func SetNotification(v:Int){
        UILabel.idNotification = v
    }
    func GetNotification() -> Int{
        return UILabel.idNotification!
    }
}




extension String {
    subscript(pos: Int) -> String {
        precondition(pos >= 0, "character position can't be negative")
        guard pos < characters.count else { return "" }
        let idx = index(startIndex, offsetBy: pos)
        return self[idx...idx]
    }
    subscript(range: CountableRange<Int>) -> String {
        precondition(range.lowerBound.distance(to: 0) <= 0, "range lowerBound can't be negative")
        let lowerIndex = index(startIndex, offsetBy: range.lowerBound, limitedBy: endIndex) ?? endIndex
        return self[lowerIndex..<(index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) ?? endIndex)]
    }
    subscript(range: ClosedRange<Int>) -> String {
        precondition(range.lowerBound.distance(to: 0) <= 0, "range lowerBound can't be negative")
        let lowerIndex = index(startIndex, offsetBy: range.lowerBound, limitedBy: endIndex) ?? endIndex
        return self[lowerIndex..<(index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) ?? endIndex)]
    }
}

extension NSLayoutConstraint {
    
    override  open var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)" //you may print whatever you want here
    }
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
