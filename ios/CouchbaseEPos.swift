//
//  CouchbaseEPos.swift
//  workbench
//
//  Created by Sourab on 26/11/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

import Foundation
import CouchbaseLiteSwift

@objc class CouchbaseEPos: NSObject {
    
    var database: Database!
    
    //MARK: openDb
    @objc func openDb(name: String, completionBlock:((String)->())) {
        completionBlock(Constants.SUCCESS)
    }
    
    //MARK: InitialiseDb
    @objc func initialiseDBWithAgentId(dbName: String, completionBlock:((String)->())) {
        do {
            database = try Database(name: dbName)
            completionBlock(Constants.SUCCESS)
        } catch {
            completionBlock(Constants.ERROR)
            fatalError("Error opening database")
        }
    }
    
    @objc func saveDocument(key: String, doc: String, completionBlock:((String)->())) -> Void {
        //        guard let cbLiteDb = DBManager.shared.database else { return completionBlock(Constants.ERROR) }
        if !(database != nil) {
            return completionBlock(Constants.ERROR)
        }
        
        let mutableDoc = MutableDocument(id: key)
        mutableDoc.setValue(doc, forKey: key)
        
        do {
            try database.saveDocument(mutableDoc)
            completionBlock(Constants.SUCCESS)
        } catch {
            completionBlock(Constants.ERROR)
            fatalError("Error saving document")
        }
    }
    
    @objc func getDocument(key: String, completionBlock:((String)->())) {
        //        guard let cbLiteDb = DBManager.shared.database else { return completionBlock(Constants.ERROR) }
        if !(database != nil) {
            return completionBlock(Constants.ERROR)
        }
        
        let list = database.document(withID: key)?.toMutable().string(forKey: key)
        
        if let docList = list {
            completionBlock(docList)
        } else {
            completionBlock(Constants.ERROR)
        }
    }
    
    @objc func deleteDocument(key: String, completionBlock:((String)->())) {
        //        guard let cbLiteDb = DBManager.shared.database else { return completionBlock(Constants.ERROR) }
        if !(database != nil) {
            return completionBlock(Constants.ERROR)
        }
        
        do {
            if let docTodl = try database.document(withID: key) {
                do {
                    try database.deleteDocument(docTodl)
                    completionBlock(Constants.SUCCESS)
                } catch let error as NSError {
                    completionBlock(error.localizedDescription)
                }
            } else {
                return completionBlock(Constants.SUCCESS)
            }
        } catch let error as NSError {
            completionBlock(error.localizedDescription)
        }
    }
    
    //MARK: push and pull replicators
    @objc func pushReplicator(sessionKey: String, completionBlock:@escaping ((String)->())) {
        //        guard let cbLiteDb = DBManager.shared.database else { return completionBlock(Constants.ERROR) }
        if !(database != nil) {
            return completionBlock(Constants.ERROR)
        }
        
        let endPointUrl = Constants.END_POINT_URL + database.name
        let targetEndpoint = URLEndpoint(url: URL(string: endPointUrl)!)
        let replConfig = ReplicatorConfiguration(database: database, target: targetEndpoint)
        replConfig.replicatorType = .push
        
        replConfig.authenticator = SessionAuthenticator.init(sessionID: sessionKey)
        
        let replicator = Replicator(config: replConfig)
        
        replicator.addChangeListener { (change) in
            if let error = change.status.error as NSError? {
                print("Error code for Push :: \(error.code)")
                completionBlock(error.localizedDescription)
            } else {
                switch (change.status.activity) {
                case .stopped:
                    completionBlock(Constants.SUCCESS)
                case .offline:
                    print("offline")
                case .connecting:
                    print("connecting")
                case .idle:
                    print("idle")
                case .busy:
                    print("busy")
                }
            }
        }
        
        replicator.start()
    }
    
    @objc func pullReplicator(sessionKey: String, completionBlock:@escaping ((String)->())) {
        //        guard let cbLiteDb = DBManager.shared.database else { return completionBlock(Constants.ERROR) }
        if !(database != nil) {
            return completionBlock(Constants.SUCCESS)
            //            return completionBlock(Constants.ERROR)
        }
        
        let endPointUrl = Constants.END_POINT_URL + database.name
        
        let targetEndpoint = URLEndpoint(url: URL(string: endPointUrl)!)
        let replConfig = ReplicatorConfiguration(database: database, target: targetEndpoint)
        replConfig.replicatorType = .pull
        
        replConfig.authenticator = SessionAuthenticator.init(sessionID: sessionKey)
        
        let replicator = Replicator(config: replConfig)
        
        replicator.addChangeListener { (change) in
            if let error = change.status.error as NSError? {
                print("Error code for Pull :: \(error.code)")
                completionBlock(error.localizedDescription)
            } else {
                switch (change.status.activity) {
                case .stopped:
                    completionBlock(Constants.SUCCESS)
                case .offline:
                    print("offline")
                case .connecting:
                    print("connecting")
                case .idle:
                    print("idle")
                case .busy:
                    print("busy")
                }
            }
        }
        
        replicator.start()
    }
    
    //MARK: multiSet and multiGet
    @objc func multiSet(key: String, value: NSArray, completionBlock:((String)->())) -> Void {
        //        guard let cbLiteDb = DBManager.shared.database else { return completionBlock(Constants.ERROR) }
//        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
//        print(paths[0])
        
        if !(database != nil) {
            return completionBlock(Constants.SUCCESS)
            //            return completionBlock(Constants.ERROR)
        }
        
        var blIsSuccess : Bool = true
        var mutableDoc = MutableDocument();
        let localAllValues: [NSDictionary] = value as! [NSDictionary]
        for eachValue in localAllValues {
            for objDict in eachValue {
                mutableDoc = MutableDocument(id: objDict.key as? String)
                mutableDoc.setString(objDict.value as? String, forKey: objDict.key as! String)
                mutableDoc.setString((objDict.key as? String)!, forKey:"key")
                mutableDoc.setString(key, forKey: "docType")
                
                do {
                    try database.saveDocument(mutableDoc)
                    blIsSuccess = true
                } catch {
                    blIsSuccess = false
                    fatalError("Error saving document")
                }
            }
        }
        
        if blIsSuccess {
            completionBlock(Constants.SUCCESS)
        } else {
            completionBlock(Constants.ERROR)
        }
    }
    
    @objc func multiGet(type: String, completionBlock:(([Any])->())) -> Void {
        //        guard let cbLiteDb = DBManager.shared.database else { return completionBlock([Constants.ERROR]) }
        if !(database != nil) {
            return completionBlock([Constants.ERROR])
        }
        
        let query = QueryBuilder
            .select(SelectResult.all())
            .from(DataSource.database(database))
            .where(Expression.property("docType").equalTo(Expression.string(type)));
        
        do {
            let allDatas: NSMutableArray = []
            for result in try query.execute() {
                if let resultDict = result.dictionary(forKey: database.name) {
                    
                    var dict: [String: String] = [:]
                    
                    // Setting the value of "docType"
                    if let dataForType = resultDict.string(forKey: "docType") {
                        dict["docType"] = dataForType
                    } else {
                        dict["docType"] = ""
                    }
                    // Setting the value of "key"
                    if let dataForKey = resultDict.string(forKey: "key") {
                        dict["key"] = dataForKey
                        
                        if let dataForIntKey = resultDict.string(forKey: dataForKey) {
                            dict[dataForKey] = dataForIntKey
                        } else {
                            dict[dataForKey] = ""
                        }
                    } else {
                        dict["key"] = ""
                    }
                    
                    allDatas.add([dict]);
                }
            }
            completionBlock(allDatas as! [Any])
        } catch {
            completionBlock([Constants.ERROR])
        }
    }
    
    //MARK: Data flowing native to RN with Emitter
    @objc func sendDataToJSDummyFunc() {
        let dict: [String: String] = ["Name": "ePos"]
        
        let emitterManager: EmitterManager = EmitterManager()
        emitterManager.initiateEmitter(withEventDict: dict )
    }
    
    //MARK: local DB
    @objc func getLocalDocument(docId: String, completionBlock:((String)->())) {
        guard let cbLiteLocalDb = DBManager.shared.localDatabase else { return completionBlock(Constants.ERROR) }
        
        let list = cbLiteLocalDb.document(withID: docId)?.toMutable().string(forKey: docId)
        
        if let docList = list {
            completionBlock(docList)
        } else {
            completionBlock(Constants.ERROR)
        }
    }
    
    @objc func saveLocalDocument(key: String, doc: String, completionBlock:((String)->())) -> Void {
        guard let cbLiteLocalDb = DBManager.shared.localDatabase else { return completionBlock(Constants.ERROR) }
        
        let mutableDoc = MutableDocument(id: key)
        mutableDoc.setValue(doc, forKey: key)
        
        do {
            try cbLiteLocalDb.saveDocument(mutableDoc)
            completionBlock(doc)
        } catch {
            completionBlock(Constants.ERROR)
            fatalError("Error saving document")
        }
    }
    
    @objc func deleteLocalDocument(key: String, completionBlock:((String)->())) {
        guard let cbLiteLocalDb = DBManager.shared.localDatabase else { return completionBlock(Constants.ERROR) }
        database = nil
        let docToDel = cbLiteLocalDb.document(withID: key)!
        do {
            try cbLiteLocalDb.deleteDocument(docToDel)
            completionBlock(Constants.SUCCESS)
        } catch let error as NSError {
            completionBlock(error.localizedDescription)
        }
    }
    
}
