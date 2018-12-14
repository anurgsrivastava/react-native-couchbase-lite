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
    
    //REMOVE openDb
    @objc func openDb(name: String, completionBlock:((String)->())) {
//        do {
//            database = try Database(name: name)
//            completionBlock(Constants.SUCCESS)
//        } catch {
//            completionBlock(Constants.ERROR)
//            fatalError("Error opening database")
//        }
        
        guard let cbLiteDb = DBManager.shared.database else { return completionBlock(Constants.ERROR) }
        completionBlock(Constants.ERROR)
    }
    
    @objc func saveDocument(key: String, doc: String, completionBlock:((String)->())) -> Void {
        guard let cbLiteDb = DBManager.shared.database else { return completionBlock(Constants.ERROR) }

        let docId = key + "||" + "abc123" //Application Id
        let mutableDoc = MutableDocument(id: docId)
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
        
        let docId = key + "||" + "abc123" //Application Id
        let list = cbLiteDb.document(withID: docId)?.toMutable().string(forKey: key)
        
        if let docList = list {
            completionBlock(docList)
        } else {
            completionBlock(Constants.ERROR)
        }
    }
    
    @objc func deleteDocument(key: String, completionBlock:((String)->())) {
        guard let cbLiteDb = DBManager.shared.database else { return completionBlock(Constants.ERROR) }

        let docId = key + "||" + "abc123" //Application Id
        let docToDel = database.document(withID: docId)!
        do {
            try cbLiteDb.deleteDocument(docToDel)
            completionBlock(Constants.SUCCESS)
        } catch let error as NSError {
            completionBlock(error.localizedDescription)
        }
    }
    
    @objc func pushReplicator(completionBlock:@escaping ((String)->())) {
        guard let cbLiteDb = DBManager.shared.database else { return completionBlock(Constants.ERROR) }
        
        let targetEndpoint = URLEndpoint(url: URL(string: Constants.END_POINT_URL)!)
        let replConfig = ReplicatorConfiguration(database: cbLiteDb, target: targetEndpoint)
        replConfig.replicatorType = .push
        
        replConfig.authenticator = BasicAuthenticator(username: "sourabRoy", password: "pass")
        //    replConfig.authenticator = SessionAuthenticator.init(sessionID: "f2918f92357cd89075256eb307b2e81d1db3ba2c")
        
        let replicator = Replicator(config: replConfig)
        
        replicator.addChangeListener { (change) in
            if let error = change.status.error as NSError? {
                print("Error code :: \(error.code)")
                completionBlock(error.localizedDescription)
            } else {
                completionBlock(Constants.SUCCESS)
            }
        }
        
        replicator.start()
    }
    
    @objc func sendDataToJSDummyFunc() {
        let dict: [String: String] = ["Name": "ePos"]
        
        let emitterManager: EmitterManager = EmitterManager()
        emitterManager.initiateEmitter(withEventDict: dict )
    }
}
