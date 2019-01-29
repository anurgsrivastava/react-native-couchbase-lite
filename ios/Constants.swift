//
//  Constants.swift
//  Workbench
//
//  Created by Sourab Roy on 7/12/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

import Foundation

@objcMembers
public class Constants: NSObject {
    //    public static let END_POINT_URL = "ws://localhost:4984/prudential"
    public static let END_POINT_URL = "ws://10.4.10.41:4984/prudential"
    public static let ERROR = "error"
    public static let SUCCESS = "success"
    public static let DB_NAME = "ePos"
    public static let LOCAL_DB_NAME = "prudential:local"
    public static let ERROR_IN_SAVING = "Error occurred in saving data"
    public static let ERROR_IN_FETCHING = "Error occurred in fetching the data"
    public static let ERROR_IN_CREATING_DB = "Error occurred in creating the DB"
    public static let DOC_TYPE = "type"
    public static let CHANNEL_NAME = "channel_name"
    public static let CHANNEL_KEY = "channel"
    public static let REPLICATION_SESSION_KEY = "replicationSessionKey"
}
