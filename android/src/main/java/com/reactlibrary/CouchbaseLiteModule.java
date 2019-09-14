
package com.reactlibrary;

import android.net.Uri;
import android.util.Log;

import com.couchbase.lite.Blob;
import com.couchbase.lite.Database;
import com.couchbase.lite.DatabaseConfiguration;
import com.couchbase.lite.Dictionary;
import com.couchbase.lite.Document;
import com.couchbase.lite.DocumentChange;
import com.couchbase.lite.DocumentChangeListener;
import com.couchbase.lite.Endpoint;
import com.couchbase.lite.MutableDocument;
import com.couchbase.lite.Query;
import com.couchbase.lite.QueryBuilder;
import com.couchbase.lite.QueryChange;
import com.couchbase.lite.QueryChangeListener;
import com.couchbase.lite.Replicator;
import com.couchbase.lite.ReplicatorChange;
import com.couchbase.lite.ReplicatorConfiguration;
import com.couchbase.lite.Result;
import com.couchbase.lite.Expression;
import com.couchbase.lite.DataSource;
import com.couchbase.lite.ResultSet;
import com.couchbase.lite.SelectResult;
import com.couchbase.lite.URLEndpoint;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.Callback;
import com.couchbase.lite.ReplicatorChangeListener;
import com.couchbase.lite.ListenerToken;

import com.couchbase.lite.CouchbaseLiteException;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.UUID;
import java.lang.String;

import javax.annotation.Nullable;

public class CouchbaseLiteModule extends ReactContextBaseJavaModule {

  private final ReactContext mReactContext;
  private String dbName;

  private static ListenerToken pullListenerToken;
  private static ListenerToken pushListenerToken;


  @Override
  public String getName() {
    return "CouchbaseLiteStorage";
  }

  public CouchbaseLiteModule(ReactApplicationContext reactContext) {
    super(reactContext);
    mReactContext = reactContext;
    DatabaseManager.setContext(reactContext);
  }

  private void sendEvent(String eventName, @Nullable WritableMap params) {
    mReactContext
            .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
            .emit(eventName, params);
  }

  @ReactMethod
  public void createDatabase(ReadableMap dbConfig, Promise promise) {
    try{
      this.dbName = dbConfig.getString("dbName");
      DatabaseManager.createDatabase(dbConfig, mReactContext);
      promise.resolve(true);
    }
    catch(CouchbaseLiteException e){
      promise.reject("createDatabase", "Error creating db");
    }
  }

  @ReactMethod
  public void getDocument(String docId, Promise promise) {
    Document doc = DatabaseManager.getDatabase().getDocument(this.dbName + ":" + docId);
    if (doc == null) {
      promise.resolve("");
    } else {
      //promise.resolve(ConversionUtil.toWritableMap( this.serializeDocument(doc) ) );
      promise.resolve(doc.getString(docId));
    }
  }

  @ReactMethod
  public void getLocalDocument(String docId, Promise promise) {
    Document doc = DatabaseManager.getLocalDatabase().getDocument(docId);
    if (doc == null) {
      promise.resolve("");
    } else {
      promise.resolve(ConversionUtil.toWritableMap( this.serializeDocument(doc) ) );
    }
  }

  @ReactMethod
  public void multiGet(String type, Promise promise) {
    Query query = QueryBuilder
      .select(SelectResult.all())
      .from(DataSource.database(DatabaseManager.getDatabase()))
      .where(Expression.property("type").equalTo(Expression.string(type)));

    try {
        ResultSet rs = query.execute();
        promise.resolve( ConversionUtil
                          .toWritableArray( this.getQueryResults(rs).toArray() ) 
                       );
    } catch (CouchbaseLiteException e) {
        promise.reject("query", "Error running query", e);
    }
  }

  @ReactMethod
  public void saveDocument(String key, String type, String data, Promise promise) {
    String docId = this.dbName + ":" + key;
    MutableDocument doc = new MutableDocument(docId);
    doc.setString(key, data);
    doc.setString("key", key);
    doc.setString("type", type);
    doc.setString("channel_name", this.dbName);

    try {
      DatabaseManager.getDatabase().save(doc);
      promise.resolve(true);
    } catch (CouchbaseLiteException e) {
      promise.reject("create_document", "Can not create document", e);
    }
  }

  @ReactMethod
  public void saveLocalDocument(String key, ReadableMap data, Promise promise) {
    MutableDocument doc = new MutableDocument(key);
    doc.setData( data.toHashMap() );
    try {
      DatabaseManager.getLocalDatabase().save(doc);
      promise.resolve(true);
    } catch (CouchbaseLiteException e) {
      promise.reject("create_document", "Can not create document", e);
    }
  }
  @ReactMethod
  public void multiSet(String key, ReadableArray dataArray, Promise promise) {
    List<Object> list = dataArray.toArrayList();
    try {
      for (Object data : list) {
        Map <String, String> map = (HashMap)data;
        for (Map.Entry<String, String> entry : map.entrySet()) {
            MutableDocument doc = new MutableDocument(this.dbName+":"+entry.getKey());
            doc.setString(entry.getKey(), entry.getValue());
            doc.setString("key", entry.getKey());
            doc.setString("type", key);
            doc.setString("channel_name", this.dbName);
            DatabaseManager.getDatabase().save(doc);
        }
      }
      promise.resolve(true);
    } catch (CouchbaseLiteException e) {
      promise.reject("create_document", "Can not create document", e);
    }
  }

  @ReactMethod
  public void removeDocument(String docId, Promise promise) {
    Database db = DatabaseManager.getDatabase();
    Document doc = db.getDocument(this.dbName + ":" + docId);
    if(doc != null){
      try {
        db.delete(doc);
        promise.resolve(true);
      } catch (CouchbaseLiteException e) {
        promise.reject("delete_document", "Can not delete document", e);
      }
    }else{
      promise.resolve(true);
    }
  }

  @ReactMethod
  public void deleteLocalDocument(String docId, Promise promise) {
    Database db = DatabaseManager.getLocalDatabase();
    Document doc = db.getDocument(docId);
    try {
      db.delete(doc);
      promise.resolve(true);
    } catch (CouchbaseLiteException e) {
      promise.reject("delete_document", "Can not delete document", e);
    }
  }
   /**
    * This method will do data sync up/down based upon the sync type provided in readableMap.
    * @param readableMap holds the channel,session key,replication type.
    * @param promise
    */
  @ReactMethod
  public void pushReplicator(ReadableMap readableMap, final Promise promise) {
      /**Replicator instance */
      final Replicator replicator = SyncGatewayConfig.getPushReplicator(readableMap);

      /** keeps track of completed/total documents syncing
       * completed will tell how many documents are synced at the moment
       * total will represent the total count of document to be synced*/
    pushListenerToken = replicator.addChangeListener(new ReplicatorChangeListener() {
          @Override
          public void changed(ReplicatorChange change) {
            if (change.getStatus().getError() != null) {
              Log.i("message", "Error code ::  " + change.getStatus().getError().getCode());
              String errorCode = String.valueOf(change.getStatus().getError().getCode());
              removePushChangeListener(replicator);
              promise.reject(errorCode);
            }
            else if (change.getStatus().getActivityLevel().toString() == "STOPPED" ) {
                Log.i("message", "Completed::  " + change.getStatus().getProgress().getCompleted());
                Log.i("message", "Total ::  " + change.getStatus().getProgress().getTotal());
                removePushChangeListener(replicator);
                promise.resolve("true");
            }
          }
      });
      /**starting syncing in the background*/
      replicator.start();
  }

  @ReactMethod
  public void pullReplicator(ReadableMap readableMap, final Promise promise) {
      /**Replicator instance */
      final Replicator replicator = SyncGatewayConfig.getPullReplicator(readableMap);

      /** keeps track of completed/total documents syncing
       * completed will tell how many documents are synced at the moment
       * total will represent the total count of document to be synced*/
    pullListenerToken = replicator.addChangeListener(new ReplicatorChangeListener() {
          @Override
          public void changed(ReplicatorChange change) {
            if (change.getStatus().getError() != null) {
              Log.i("message", "Error code ::  " + change.getStatus().getError().getCode());
              String errorCode = String.valueOf(change.getStatus().getError().getCode());
              removePullChangeListener(replicator);
              promise.reject(errorCode);
            }
            //TODO need to send proper error codes back to react side
            else if (change.getStatus().getActivityLevel().toString() == "STOPPED" ){
              Log.i("message", "Completed::  " + change.getStatus().getProgress().getCompleted());
              Log.i("message", "Total ::  " + change.getStatus().getProgress().getTotal());
              removePullChangeListener(replicator);
              promise.resolve("true");
            }
          }
      });
      /**starting syncing in the background*/
      replicator.start();

  }

  @ReactMethod
  public void reset(final Promise promise){
    SyncGatewayConfig.resetReplicators();
    promise.resolve("true");
  }

  private void removePullChangeListener(Replicator replicator){
    replicator.removeChangeListener(pullListenerToken);
  }

  private void removePushChangeListener(Replicator replicator){
    replicator.removeChangeListener(pushListenerToken);
  }

  private Map<String, Object> serializeDocument(Document document) {
    Map<String, Object> properties = new HashMap<>(document.toMap());
    properties.put("id", document.getId());
    for(Map.Entry<String, Object> entry: properties.entrySet()) {
      if (entry.getValue() instanceof Blob) {
        Blob blob = (Blob)entry.getValue();
        Map<String, Object> blobProps = new HashMap<>(blob.getProperties());
        String path = DatabaseManager.getDatabase().getPath().concat("Attachments/").concat( blob.digest().substring(5) ).concat(".blob");
        try {
          blobProps.put("url", new File(path).toURI().toURL().toString());
        } catch (MalformedURLException e) {
          blobProps.put("url", null);
        }
        properties.put(entry.getKey(), blobProps);
      }
    }
    return properties;
  }

  private List getQueryResults(ResultSet result) {
    List list = new ArrayList<>();
    for (Result row : result.allResults()) {
      list.add( row.toList() );
    }
    return list;
  }

}
