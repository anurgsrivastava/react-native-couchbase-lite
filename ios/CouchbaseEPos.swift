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
  
  @objc func saveData(key: String, data: String) -> Void {
//    NSLog("%@ %@", key, data);
    
    do {
      database = try Database(name: "ePos")
    } catch {
      fatalError("Error opening database")
    }
    
    let docId = key + "||" + "abc123" //Application Id
//    print("docId is :: \(docId)")
    let doc = MutableDocument(id: docId)
    doc.setValue(data, forKey: key)
    
    // Save it to the database.
    do {
      try database.saveDocument(doc)
    } catch {
      fatalError("Error saving document")
    }
  }
  
  @objc func getDataWithPromisses(key: String, completionBlock:((String)->())?) {
    do {
      database = try Database(name: "ePos")
    } catch {
      fatalError("Error opening database")
    }
    
    let docId = key + "||" + "abc123" //Application Id
    let list = database.document(withID: docId)?.toMutable().string(forKey: key)
    
    if let docList = list {
      if (completionBlock != nil) {
        completionBlock!(docList)
      }
    } else {
      if (completionBlock != nil) {
        completionBlock!("Error")
      }
    }
  }
  
  @objc func sendDataToJSDummyFunc() {
    let dict: [String: String] = ["Name": "Sourab"]
    
    let emitterManager: EmitterManager = EmitterManager()
    emitterManager.initiateEmitter(withEventDict: dict )
  }
  
}
