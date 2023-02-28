//
//  APIOperation.swift
//  ios_template_project
//
//  Created by Hien Pham on 4/6/20.
//  Copyright © 2020 BraveSoft Vietnam. All rights reserved.
//

import Foundation
import RxSwift

class APIOperation<T>: AsyncOperation {
    private(set) var value: T?
    private(set) var error: Error?
    let single: Single<T>
    private var disposable: Disposable?
    init(single: Single<T>) {
        self.single = single
        super.init()
    }

    override func main() {
        disposable = single.subscribe(
            onSuccess: {[weak self] value in
                self?.value = value
            }, onError: {[weak self] error in
                self?.error = error
            })
        disposable?.disposed(by: rx.disposeBag)
    }

    override func cancel() {
        disposable?.dispose()
    }
}
