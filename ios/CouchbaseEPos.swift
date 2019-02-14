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
    var dbName: String!
    var pushListenerToken: ListenerToken!
    var pullListenerToken: ListenerToken!
    
    //MARK: createDatabase
    @objc func createDatabase(dbConfig: NSDictionary, completionBlock:((String)->())) {
        dbName = dbConfig["dbName"] as? String
        DBManager.shared.createDatabase(dbConfig: dbConfig) { (bl) in
            if (bl) {
                completionBlock(Constants.SUCCESS)
            } else {
                completionBlock(Constants.SUCCESS)
            }
        }
    }
    
    @objc func saveDocument(key: String, type: String, data: NSString, completionBlock:((String)->())) -> Void {
//        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
//        print("Document Directory path is :: \(paths)")
        
        guard let database  = DBManager.shared.getDatabase() else { return completionBlock(Constants.ERROR) }
        
        let idUUID = dbName + ":" + key
        let mutableDoc = MutableDocument(id: idUUID)
        mutableDoc.setString(data as String, forKey: key)
        mutableDoc.setString(key, forKey: "key")
        mutableDoc.setString(type, forKey: Constants.DOC_TYPE)
        mutableDoc.setString(dbName, forKey: Constants.CHANNEL_NAME)
        
        do {
            try database.saveDocument(mutableDoc)
            completionBlock(Constants.SUCCESS)
        } catch {
            completionBlock(Constants.ERROR)
            fatalError("Error saving document")
        }
    }
    
    @objc func getDocument(key: String, completionBlock:((String)->())) {
        guard let database  = DBManager.shared.getDatabase() else { return completionBlock(Constants.ERROR) }
        
        let list = database.document(withID: key)?.toMutable().string(forKey: key)
        
        if let docList = list {
            completionBlock(docList)
        } else {
            completionBlock(Constants.ERROR)
        }
    }
    
    @objc func removeDocument(key: String, completionBlock:((String)->())) {
        guard let database  = DBManager.shared.getDatabase() else { return completionBlock(Constants.ERROR) }
        
        do {
            let docId = dbName + ":" + key
            if let docTodl = database.document(withID: docId) {
                do {
                    try database.deleteDocument(docTodl)
                    completionBlock(Constants.SUCCESS)
                } catch let error as NSError {
                    completionBlock(error.localizedDescription)
                }
            } else {
                return completionBlock(Constants.SUCCESS)
            }
        }
    }
    
    //MARK: push and pull replicators
    @objc func pushReplicator(replicatorDetails: NSDictionary, completionBlock:@escaping ((String)->())) {
        let replicator = SyncGatewayConfig.shared.getPushReplicator(replicatorDetails: replicatorDetails)
        
        pushListenerToken = replicator.addChangeListener { (change) in
            if let error = change.status.error as NSError? {
                print("Error code for Push :: \(error.code)")
                self.removePushChangeListener(replicator: replicator)
                completionBlock(error.localizedDescription)
            } else {
                switch (change.status.activity) {
                case .stopped:
                    self.removePushChangeListener(replicator: replicator)
                    completionBlock(Constants.SUCCESS)
                    print("pushReplicator completed")
                case .offline:
                    print("pushReplicator offline")
                case .connecting:
                    print("pushReplicator connecting")
                case .idle:
                    print("pushReplicator idle")
                case .busy:
                    print("pushReplicator busy")
                }
            }
        }
        
        replicator.start()
    }
    
    @objc func pullReplicator(replicatorDetails: NSDictionary, completionBlock:@escaping ((String)->())) {
        let replicator = SyncGatewayConfig.shared.getPullReplicator(replicatorDetails: replicatorDetails)
        
        pullListenerToken = replicator.addChangeListener { (change) in
            if let error = change.status.error as NSError? {
                print("Error code for Pull :: \(error.code)")
                self.removePullChangeListener(replicator: replicator)
                completionBlock(error.localizedDescription)
            } else {
                switch (change.status.activity) {
                case .stopped:
                    self.removePullChangeListener(replicator: replicator)
                    completionBlock(Constants.SUCCESS)
                    print("pullReplicator completed")
                case .offline:
                    print("pullReplicator offline")
                case .connecting:
                    print("pullReplicator connecting")
                case .idle:
                    print("pullReplicator idle")
                case .busy:
                    print("pullReplicator busy")
                }
            }
        }
        
        replicator.start()
    }
    
    func removePushChangeListener(replicator: Replicator) {
        replicator.removeChangeListener(withToken: pushListenerToken)
    }
    
    func removePullChangeListener(replicator: Replicator) {
        replicator.removeChangeListener(withToken: pullListenerToken)
    }
    
    //MARK: multiSet and multiGet
    @objc func multiSet(key: String, value: NSArray, completionBlock:((String)->())) -> Void {
        guard let database  = DBManager.shared.getDatabase() else { return completionBlock(Constants.ERROR) }
        
        var blIsSuccess : Bool = true
        var mutableDoc = MutableDocument();
        let localAllValues: [NSDictionary] = value as! [NSDictionary]
        for eachValue in localAllValues {
            for objDict in eachValue {
                var idUUID: String = objDict.key as! String
                idUUID = dbName + ":" + idUUID // database.name
                mutableDoc = MutableDocument(id: idUUID)
                mutableDoc.setString(objDict.value as? String, forKey: objDict.key as! String)
                mutableDoc.setString((objDict.key as? String)!, forKey: "key")
                mutableDoc.setString(key, forKey: Constants.DOC_TYPE)
                mutableDoc.setString(dbName, forKey: Constants.CHANNEL_NAME)
                
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
        guard let database  = DBManager.shared.getDatabase() else { return completionBlock([Constants.ERROR]) }
        
        let query = QueryBuilder
            .select(SelectResult.all())
            .from(DataSource.database(database))
            .where(Expression.property(Constants.DOC_TYPE).equalTo(Expression.string(type)));
        
        do {
            let allDatas: NSMutableArray = []
            for result in try query.execute() {
                if let resultDict = result.dictionary(forKey: dbName) {
                    
                    var dict: [String: String] = [:]
                    
                    // Setting the value of DOC_TYPE
                    if let dataForType = resultDict.string(forKey: Constants.DOC_TYPE) {
                        dict[Constants.DOC_TYPE] = dataForType
                    } else {
                        dict[Constants.DOC_TYPE] = ""
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
    @objc func getLocalDocument(docId: String, completionBlock:((NSDictionary)->())) {
        guard let cbLiteLocalDb = DBManager.shared.getLocalDatabase() else {
            return completionBlock([Constants.ERROR: Constants.ERROR])
        }
        
        if let list = cbLiteLocalDb.document(withID: docId)?.toDictionary() {
            completionBlock(list as NSDictionary)
        } else {
            return completionBlock([Constants.ERROR: Constants.ERROR])
        }
    }
    
    @objc func saveLocalDocument(key: String, data: NSDictionary, completionBlock:((String)->())) -> Void {
        guard let cbLiteLocalDb = DBManager.shared.getLocalDatabase() else { return completionBlock(Constants.ERROR) }
        
        let mutableDoc = MutableDocument(id: key)
        mutableDoc.setData(data as? Dictionary<String, Any>)
        
        do {
            try cbLiteLocalDb.saveDocument(mutableDoc)
            completionBlock(Constants.SUCCESS)
        } catch {
            completionBlock(Constants.ERROR)
            fatalError("Error saving document")
        }
    }
    
    @objc func deleteLocalDocument(key: String, completionBlock:((String)->())) {
        guard let cbLiteLocalDb = DBManager.shared.getLocalDatabase() else { return completionBlock(Constants.ERROR) }
        do {
            if let docToDel = cbLiteLocalDb.document(withID: key) {
                
                do {
                    try cbLiteLocalDb.deleteDocument(docToDel)
                    completionBlock(Constants.SUCCESS)
                } catch let error as NSError {
                    completionBlock(error.localizedDescription)
                }
            }
        }
    }
}
