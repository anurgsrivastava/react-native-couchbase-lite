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
    
    //REMOVE openDb
    @objc func openDb(name: String, completionBlock:((String)->())) {
        //        do {
        //            database = try Database(name: name)
        //            completionBlock(Constants.SUCCESS)
        //        } catch {
        //            completionBlock(Constants.ERROR)
        //            fatalError("Error opening database")
        //        }
        guard DBManager.shared.database != nil else { return completionBlock(Constants.ERROR) }
        completionBlock(Constants.SUCCESS)
    }
    
    @objc func saveDocument(key: String, doc: String, completionBlock:((String)->())) -> Void {
        guard let cbLiteDb = DBManager.shared.database else { return completionBlock(Constants.ERROR) }
        
        let mutableDoc = MutableDocument(id: key)
        mutableDoc.setValue(doc, forKey: key)
        
        do {
            try cbLiteDb.saveDocument(mutableDoc)
            completionBlock(Constants.SUCCESS)
        } catch {
            completionBlock(Constants.ERROR)
            fatalError("Error saving document")
        }
    }
    
    @objc func getDocument(key: String, completionBlock:((String)->())) {
        guard let cbLiteDb = DBManager.shared.database else { return completionBlock(Constants.ERROR) }
        
        let list = cbLiteDb.document(withID: key)?.toMutable().string(forKey: key)
        
        if let docList = list {
            completionBlock(docList)
        } else {
            completionBlock(Constants.ERROR)
        }
    }
    
    @objc func deleteDocument(key: String, completionBlock:((String)->())) {
        guard let cbLiteDb = DBManager.shared.database else { return completionBlock(Constants.ERROR) }
        
        let docId = key + "||" + "abc123" //Application Id
        let docToDel = cbLiteDb.document(withID: docId)!
        do {
            try cbLiteDb.deleteDocument(docToDel)
            completionBlock(Constants.SUCCESS)
        } catch let error as NSError {
            completionBlock(error.localizedDescription)
        }
    }
    
    @objc func pushReplicator(sessionKey: String, completionBlock:@escaping ((String)->())) {
        guard let cbLiteDb = DBManager.shared.database else { return completionBlock(Constants.ERROR) }
        
        let targetEndpoint = URLEndpoint(url: URL(string: Constants.END_POINT_URL)!)
        let replConfig = ReplicatorConfiguration(database: cbLiteDb, target: targetEndpoint)
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
        guard let cbLiteDb = DBManager.shared.database else { return completionBlock(Constants.ERROR) }
        
        let targetEndpoint = URLEndpoint(url: URL(string: Constants.END_POINT_URL)!)
        let replConfig = ReplicatorConfiguration(database: cbLiteDb, target: targetEndpoint)
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
    
    @objc func multiSet(key: String, value: NSArray, completionBlock:((String)->())) -> Void {
        guard let cbLiteDb = DBManager.shared.database else { return completionBlock(Constants.ERROR) }
        //        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        //        print(paths[0])
        
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
                    try cbLiteDb.saveDocument(mutableDoc)
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
        guard let cbLiteDb = DBManager.shared.database else { return completionBlock([Constants.ERROR]) }
        
        let query = QueryBuilder
            .select(SelectResult.all())
            .from(DataSource.database(cbLiteDb))
            .where(Expression.property("docType").equalTo(Expression.string(type)));
        
        do {
            let allDatas: NSMutableArray = []
            for result in try query.execute() {
                if let resultDict = result.dictionary(forKey: cbLiteDb.name) {
                    
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
            completionBlock(Constants.SUCCESS)
        } catch {
            completionBlock(Constants.ERROR)
            fatalError("Error saving document")
        }
    }
    
    @objc func deleteLocalDocument(key: String, completionBlock:((String)->())) {
        guard let cbLiteLocalDb = DBManager.shared.localDatabase else { return completionBlock(Constants.ERROR) }
        
        let docToDel = cbLiteLocalDb.document(withID: key)!
        do {
            try cbLiteLocalDb.deleteDocument(docToDel)
            completionBlock(Constants.SUCCESS)
        } catch let error as NSError {
            completionBlock(error.localizedDescription)
        }
    }
}
