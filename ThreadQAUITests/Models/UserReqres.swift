//
//  UserReqres.swift
//  ThreadQA
//
//  Created by Maxim Makarov on 10.03.2026.
//

import Foundation
import UIKit

struct RequestModel: Decodable {
    let page: Int
    let data: [UserRequest]
}

struct UserRequest: Decodable {
    let id: Int
    let email: String
    let first_name: String
    let last_name: String
    let avatar: String
}
