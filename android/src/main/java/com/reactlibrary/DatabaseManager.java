package com.reactlibrary;

import android.content.Context;

import com.couchbase.lite.CouchbaseLiteException;
import com.couchbase.lite.Database;
import com.couchbase.lite.DatabaseConfiguration;
import com.facebook.react.bridge.ReadableMap;

/**
 * The class represent the database configuration responsibe for allocating database
 * connection object
 *
 */
public class DatabaseManager {

    //need to be loaded from properties.
    /** name of the database in CBLite. */
    private static String LOCAL_DB_NAME = "prudential:local";
    /** Database connection object */
    private static Database database;
    private static Database localDatabase;
    private static DatabaseManager instance = null;

    private DatabaseManager(Context context) {
        DatabaseConfiguration configuration = new DatabaseConfiguration(context);
        try {
            localDatabase = new Database(LOCAL_DB_NAME, configuration);
        } catch (CouchbaseLiteException e) {
            e.printStackTrace();
        }
    }

    public static void createDatabase(ReadableMap dbConfig, Context context) throws CouchbaseLiteException{
        DatabaseConfiguration configuration = new DatabaseConfiguration(context);
        database = new Database(dbConfig.getString("dbName"), configuration);
        SyncGatewayConfig.setSyncGatewayConfig(dbConfig.getString("url"));
    }

    /**
     * Initialized a new DatabaseManager instance only once with a Database instance.
     * @param context
     * @return
     */
    public static DatabaseManager setContext(Context context) {
        if (instance == null) {
            instance = new DatabaseManager(context);
        }
        return instance;
    }

    /**
     * Returns the same instance of Database for subsequent invocation.
     * @return Database connection instance
     */
    public static Database getDatabase() {
        if (instance == null) {
            try {
                throw new Exception("Must call getSharedInstance first");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return database;
    }

    public static Database getLocalDatabase() {
        if (instance == null) {
            try {
                throw new Exception("Must call getSharedInstance first");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return localDatabase;
    }
}
