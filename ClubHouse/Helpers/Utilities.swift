//
//  Utilities.swift
//  ClubHouse
//
//  Created by Jahid Hassan on 11/26/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

/// common method for selecting thread and creating delay
func invoke(after: Double = 0.0,
            onThread: DispatchQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default),
            callback: @escaping ()->())
{
    onThread.asyncAfter(deadline: .now()+after) {
        callback()
    }
}
