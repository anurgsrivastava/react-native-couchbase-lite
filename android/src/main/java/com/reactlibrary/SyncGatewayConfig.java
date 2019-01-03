package com.reactlibrary;

import com.couchbase.lite.Array;
import com.couchbase.lite.Replicator;
import com.couchbase.lite.ReplicatorConfiguration;
import com.couchbase.lite.SessionAuthenticator;
import com.couchbase.lite.URLEndpoint;
import com.facebook.react.bridge.ReadableMap;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * The class represent the Sync Gateway Configuration.
 * This configuration class will act as a bridge between CBLite and CBServer for
 * back and forth data syncing.
 *
 * @author anas.mohammed
 */
public class SyncGatewayConfig {

    //This will be taken from properties files
    /** websocket endpoint of sync gateway*/
    private static final String SYNC_GATEWAY_URL = "ws://10.0.2.2:4984/prudential";

    /** Sync Gateway Configuration instance */
    private static SyncGatewayConfig syncGatewayConfig = null;

    /** Replicator configuration instance which will configured for session management
     *  channel allocation etc */
    private static ReplicatorConfiguration replicatorConfiguration;

    /** Replicator instance  responsible for data sync up*/
    private  static Replicator pushReplicator;

    /**Replicator instance  responsible for data sync down*/
    private static Replicator pullReplicator;


    private SyncGatewayConfig() {

        replicatorConfiguration = replicatorConfiguration();
    }

    private ReplicatorConfiguration replicatorConfiguration(){

        try {
            return new ReplicatorConfiguration(DatabaseManager.getDatabase(),
                    new URLEndpoint(new URI(SYNC_GATEWAY_URL)));
        } catch (URISyntaxException e) {
            return null;
        }
    }

    /**
     * Returns the specific replicator based upon the replication type option in readableMap
     *
     * @param readableMap holds data that will be used to configure replicatorConfiguration
     *                    as well as options to get specific replicator.
     * @return Replicator Instance, either pushReplicator or pullReplicator.
     */
    public static Replicator getPushReplicator(ReadableMap readableMap) {
        if(syncGatewayConfig == null) {
            syncGatewayConfig = new SyncGatewayConfig();
            List<String> channels = new ArrayList<>();
            channels.add(readableMap.getString("channel"));
            pushReplicator = new Replicator(replicatorConfiguration
                    .setAuthenticator(new SessionAuthenticator(readableMap.getString("replicationSessionKey")))
                    .setReplicatorType(ReplicatorConfiguration.ReplicatorType.PUSH));
        }
        return pushReplicator;
    }

    public static Replicator getPullReplicator(ReadableMap readableMap) {
        if(syncGatewayConfig == null) {
            syncGatewayConfig = new SyncGatewayConfig();
            List<String> channels = new ArrayList<>();
            channels.add(readableMap.getString("channel"));
            pullReplicator =  new Replicator(replicatorConfiguration
                    .setAuthenticator(new SessionAuthenticator(readableMap.getString("replicationSessionKey")))
                    .setChannels(channels)  
                    .setReplicatorType(ReplicatorConfiguration.ReplicatorType.PULL));
        }
        return pullReplicator;
    }
}
