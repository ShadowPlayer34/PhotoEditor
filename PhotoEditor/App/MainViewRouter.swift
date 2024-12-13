//
//  MainViewRouter.swift
//  PhotoEditor
//
//  Created by Andrew Hudik on 13/12/24.
//

import SwiftUI
import Combine

class MainViewRouter: ObservableObject {
    var isUserLoggedInPublisher = CurrentValueSubject<Bool, Never>(false)
}
