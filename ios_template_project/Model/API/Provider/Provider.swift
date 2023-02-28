//
//  APIProvider.swift
//  ios_template_project
//
//  Created by Hien Pham on 11/16/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Alamofire

/**
 Base class for api provider. Do not use this class directly but has to through subclass.
 */
class Provider<Target> where Target: Moya.TargetType {
    func request(_ token: Target) -> Single<Moya.Response> {
        fatalError("This class is used directly which is forbidden")
    }
}

extension Single {
    func catchCommonError(autoHandleNoInternetConnection: Bool = true,
                          autoHandleAPIError: Bool = true) -> PrimitiveSequence<Trait, Element> {
        return catchError {(error) in
            let handledError =
                ErrorHandler.shared.handleCommonError(error,
                                                      autoHandleNoInternetConnection: autoHandleNoInternetConnection,
                                                      autoHandleAPIError: autoHandleAPIError)
            let catched: PrimitiveSequence<Trait, Element>! = Single<Element>.error(handledError)
                as? PrimitiveSequence<Trait, Element>
            return catched
        }
    }
}

extension Observable {
    func catchCommonError(autoHandleNoInternetConnection: Bool = true,
                          autoHandleAPIError: Bool = true) -> Observable<Element> {
        return catchError {(error) in
            let handledError =
                ErrorHandler.shared.handleCommonError(error,
                                                      autoHandleNoInternetConnection: autoHandleNoInternetConnection,
                                                      autoHandleAPIError: autoHandleAPIError)
            let catched = Observable<Element>.error(handledError)
            return catched
        }
    }
}
