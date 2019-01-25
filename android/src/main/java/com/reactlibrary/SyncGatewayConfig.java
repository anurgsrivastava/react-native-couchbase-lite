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
    private static String SYNC_GATEWAY_URL = null;

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

        //  replicatorConfiguration = replicatorConfiguration();
    }

    private static ReplicatorConfiguration replicatorConfiguration(String url){

        try {
            return new ReplicatorConfiguration(DatabaseManager.getDatabase(),
                    new URLEndpoint(new URI(url)));
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
        if(pushReplicator == null) {
            List<String> channels = new ArrayList<>();
            channels.add(readableMap.getString("channel"));
            pushReplicator = new Replicator(replicatorConfiguration
                    .setAuthenticator(new SessionAuthenticator(readableMap.getString("replicationSessionKey")))
                    .setReplicatorType(ReplicatorConfiguration.ReplicatorType.PUSH));
        }
        return pushReplicator;
    }

    public static Replicator getPullReplicator(ReadableMap readableMap) {
        if(pullReplicator == null) {
            List<String> channels = new ArrayList<>();
            channels.add(readableMap.getString("channel"));
            pullReplicator =  new Replicator(replicatorConfiguration
                    .setAuthenticator(new SessionAuthenticator(readableMap.getString("replicationSessionKey")))
                    .setChannels(channels)  
                    .setReplicatorType(ReplicatorConfiguration.ReplicatorType.PULL));
        }
        return pullReplicator;
    }

    public static void setSyncGatewayConfig(String url){
        replicatorConfiguration = replicatorConfiguration(url);
    }

    public static void reset(){
        pushReplicator = null;
        pullReplicator = null;
        replicatorConfiguration = null;
    }
}
