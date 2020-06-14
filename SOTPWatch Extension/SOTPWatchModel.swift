//
//  SOTPWatchModel.swift
//  SOTPWatch Extension
//
//  Created by Anzhela Baroyan on 02.06.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import WatchKit

class SOTPWatchModel: NSObject {
    
    public var authList: [String: Any] = [:] {
        didSet{
//            delegate?.syncWithPhone(syncValue: authList)
        }
        
    }
    
//    var delegate: SyncWithPhoneDelegate?
    
    static let shared = SOTPWatchModel()
    
//    public var dataFromWatch: String? {
//        didSet{
//            guard let dataFromWatch = dataFromWatch else {return}
//            delegate?.syncWithPhone(syncValue: authList)
//
//            print ("Model data from watch\(dataFromWatch)")
//        }
//    }
}
