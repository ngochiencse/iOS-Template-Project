//
//  AlertPresentableViewModel.swift
//  AlertSample
//
//  Created by Isa Aliev on 10.10.2018.
//  Copyright © 2018 IsaAliev. All rights reserved.
//

import RxCocoa

protocol AlertPresentableViewModel {
    var alertModel: BehaviorRelay<AlertModel?> { get set }
}
