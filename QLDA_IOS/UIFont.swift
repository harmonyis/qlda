//
//  UIFont.swift
//  QLDA_IOS
//
//  Created by datlh on 3/10/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import Foundation

extension UIFont {
    
    func withTraits(traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    func boldItalic() -> UIFont {
        return withTraits(traits: .traitBold, .traitItalic)
    }
    
}
