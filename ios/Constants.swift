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
    public static let END_POINT_URL = "ws://localhost:4984/prudb"
    public static let AGENT_ID_WITH_SEP = "agent123::"
    public static let ERROR = "error"
    public static let SUCCESS = "success"
    public static let DB_NAME = "ePos"
    public static let ERROR_IN_SAVING = "Error occurred in saving data"
    public static let ERROR_IN_FETCHING = "Error occurred in fetching the data"
    public static let ERROR_IN_CREATING_DB = "Error occurred in creating the DB"
}
