//
//  SyncGatewayConfig.swift
//  RNReactNativeCbl
//
//  Created by Sourab on 29/01/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import UIKit
import CouchbaseLiteSwift

class SyncGatewayConfig: NSObject {
    static let shared = SyncGatewayConfig()

    var replicatorConfiguration: ReplicatorConfiguration!
    var pushReplicator: Replicator!
    var pullReplicator: Replicator!
    
    func setReplicatorConfiguration(urlStr: String) {
        guard let database  = DBManager.shared.getDatabase() else { return }
        let targetEndpoint = URLEndpoint(url: URL(string: urlStr)!)
        replicatorConfiguration = ReplicatorConfiguration(database: database, target: targetEndpoint)
    }
    
    func getPushReplicator(replicatorDetails: NSDictionary) -> Replicator {
        if (pushReplicator != nil) {
            return pushReplicator
        }
        if let replicationSessionKey = replicatorDetails[Constants.REPLICATION_SESSION_KEY] as? String {
            replicatorConfiguration.authenticator = SessionAuthenticator.init(sessionID: replicationSessionKey)
        }
        replicatorConfiguration.replicatorType = .push
        pushReplicator = Replicator(config: replicatorConfiguration)
        return pushReplicator
    }
    
    func getPullReplicator(replicatorDetails: NSDictionary) -> Replicator {
        if (pullReplicator != nil) {
            return pullReplicator
        }
        if let replicationSessionKey = replicatorDetails[Constants.REPLICATION_SESSION_KEY] as? String {
            replicatorConfiguration.authenticator = SessionAuthenticator.init(sessionID: replicationSessionKey)
        }
        if let channelName = replicatorDetails[Constants.CHANNEL_KEY] as? String {
            replicatorConfiguration.channels = [channelName]
        }
        replicatorConfiguration.replicatorType = .pull
        pullReplicator = Replicator(config: replicatorConfiguration)
        return pullReplicator
    }
    
    @objc func resetReplicators() {
        replicatorConfiguration = nil
        pushReplicator = nil
        pullReplicator = nil
    }
}
