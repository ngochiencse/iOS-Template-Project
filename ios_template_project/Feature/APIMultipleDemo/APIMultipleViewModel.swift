//
//  APIMultipleViewModel.swift
//  ios_template_project
//
//  Created by Hien Pham on 11/9/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import Foundation

protocol APIMultipleViewModel: class {
    var basicViewModel: BasicViewModel { get }
    func runOperationQueue()
    func runOneByOne()
}
