//
//  ApiEntity.swift
//  QLDA_IOS
//
//  Created by dungnn on 3/13/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import Foundation

class ErrorEntity {
    var error :Error?
}

class SuccessEntity {
    var data : Data?
    var response : URLResponse?
}
