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
    
    @objc func openDb(name: String, completionBlock:((String)->())) {
        do {
            database = try Database(name: name)
            completionBlock(Constants.SUCCESS)
        } catch {
            completionBlock(Constants.ERROR)
            fatalError("Error opening database")
        }
    }
    
    @objc func saveDocument(key: String, doc: String, completionBlock:((String)->())) -> Void {
        let docId = key + "||" + "abc123" //Application Id
        let mutableDoc = MutableDocument(id: docId)
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
        let docId = key + "||" + "abc123" //Application Id
        let list = database.document(withID: docId)?.toMutable().string(forKey: key)
        
        if let docList = list {
            completionBlock(docList)
        } else {
            completionBlock(Constants.ERROR)
        }
    }
    
    @objc func deleteDocument(key: String, completionBlock:((String)->())) {
        let docId = key + "||" + "abc123" //Application Id
        let docToDel = database.document(withID: docId)!
        do {
            try database.deleteDocument(docToDel)
            completionBlock(Constants.SUCCESS)
        } catch let error as NSError {
            completionBlock(error.localizedDescription)
        }
    }
    
    @objc func sendDataToJSDummyFunc() {
        let dict: [String: String] = ["Name": "ePos"]
        
        let emitterManager: EmitterManager = EmitterManager()
        emitterManager.initiateEmitter(withEventDict: dict )
    }
}
