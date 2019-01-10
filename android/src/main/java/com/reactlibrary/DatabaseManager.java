package com.reactlibrary;

import android.content.Context;

import com.couchbase.lite.CouchbaseLiteException;
import com.couchbase.lite.Database;
import com.couchbase.lite.DatabaseConfiguration;

/**
 * The class represent the database configuration responsibe for allocating database
 * connection object
 *
 */
public class DatabaseManager {

    //need to be loaded from properties.
    /** name of the database in CBLite. */
    private static String DB_NAME = "prudential";
    private static String LOCAL_DB_NAME = "prudential:local";
    /** Database connection object */
    private static Database database;
    private static Database localDatabase;
    private static DatabaseManager instance = null;

    private DatabaseManager(Context context) {
        DatabaseConfiguration configuration = new DatabaseConfiguration(context);
    }

    public static void localDatabaseManager(Context context) {

        DatabaseConfiguration configuration = new DatabaseConfiguration(context);
        try {
            //database = new Database(DB_NAME, configuration);
            localDatabase = new Database(LOCAL_DB_NAME, configuration);
        } catch (CouchbaseLiteException e) {
            e.printStackTrace();
        }
    }

    public static void agentDatabaseManager(Context context, String dbName) {

        DatabaseConfiguration configuration = new DatabaseConfiguration(context);
        try {
            database = new Database(dbName, configuration);
        } catch (CouchbaseLiteException e) {
            e.printStackTrace();
        }
    }

    /**
     * Initialized a new DatabaseManager instance only once with a Database instance.
     * @param context
     * @return
     */
    public static DatabaseManager getLocalSharedInstance(Context context) {
        if (instance == null) {
            instance = new DatabaseManager(context);
        }
        localDatabaseManager(context);
        return instance;
    }

    public static DatabaseManager getAgentSharedInstance(Context context, String dbName) {
        if (instance == null) {
            instance = new DatabaseManager(context);
        }
        agentDatabaseManager(context, dbName);
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
