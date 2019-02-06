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
            localDatabase = try Database(name: Constants.LOCAL_DB_NAME)
        } catch {
            fatalError("Error opening local database")
        }
    }
    
    func createDatabase(dbConfig: NSDictionary, completionBlock:((Bool)->()))  {
        let dbNm = dbConfig["dbName"] as! String
        do {
            database = try Database(name: dbNm)
            if let strUrl = dbConfig["url"] {
                SyncGatewayConfig.shared.setReplicatorConfiguration(urlStr: strUrl as! String)
            }
            completionBlock(true)
        } catch {
            completionBlock(false)
            fatalError("Error opening database")
        }
    }
    
    func getDatabase() -> Database? {
        if (database != nil) {
            return database
        }
        return nil
    }
    
    func getLocalDatabase() -> Database? {
        if (localDatabase != nil) {
            return localDatabase
        }
        return nil
    }
}
