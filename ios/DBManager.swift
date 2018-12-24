//
//  DBManager.swift
//  workbench
//
//  Created by Sourab on 11/12/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

import UIKit
import CouchbaseLiteSwift

class DBManager: NSObject {
    static let shared = DBManager()
    var database: Database!
    var localDatabase: Database!
    
    override init() {
        do {
            database = try Database(name: Constants.DB_NAME)
        } catch {
            fatalError("Error opening database")
        }
        do {
            localDatabase = try Database(name: Constants.LOCAL_DB_NAME)
        } catch {
            fatalError("Error opening local database")
        }
    }
}
