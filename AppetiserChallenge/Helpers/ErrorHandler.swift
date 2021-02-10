//
//  ErrorHandler.swift
//  AppetiserChallenge
//
//  Created by Daniel Marco S. Rafanan on Feb/9/21.
//

import UIKit

extension UIViewController{
    func handleError(for errorType:ErrorType){
        var errorTitle = ""
        var errorDesc = ""
        switch errorType{
        case .invalidInput:
            errorTitle = "Invalid input"
        case .userNotFound:
            errorTitle = "User not Found"
        case .repeatUsername:
            errorTitle = "Username taken"
            errorDesc = "Try again"
        case .fetchingError:
            errorTitle = "Error fetcing data"
        }
        let alert = UIAlertController(title: errorTitle, message: errorDesc, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

enum ErrorType:Error{
    case invalidInput
    case userNotFound
    case repeatUsername
    case fetchingError
}
