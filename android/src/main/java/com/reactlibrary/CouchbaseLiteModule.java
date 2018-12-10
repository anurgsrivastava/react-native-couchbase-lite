
package com.reactlibrary;

import android.net.Uri;

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
import com.couchbase.lite.ReplicatorConfiguration;
import com.couchbase.lite.Result;
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

import javax.annotation.Nullable;

public class CouchbaseLiteModule extends ReactContextBaseJavaModule {

  private final ReactContext mReactContext;
  private Database db = null;
  private final HashMap<String, Document> liveDocuments = new HashMap<>();
  private final HashMap<String, Query> liveQueries = new HashMap<>();

  @Override
  public String getName() {
    return "CouchbaseLiteStorage";
  }

  public CouchbaseLiteModule(ReactApplicationContext reactContext) {
    super(reactContext);
    mReactContext = reactContext;
  }

  private void sendEvent(String eventName, @Nullable WritableMap params) {
    mReactContext
            .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
            .emit(eventName, params);
  }

  @ReactMethod
  public void openDb(String name, Promise promise) {
    if (this.db == null) {
      try {
        DatabaseConfiguration config = new DatabaseConfiguration(mReactContext.getApplicationContext());
        this.db = new Database(name, config);
        promise.resolve(null);
      } catch (CouchbaseLiteException e) {
        promise.reject("open_database", "Can not open database", e);
      }
    } else {
      promise.resolve(null);
    }
  }

  @ReactMethod
  public void getDocument(String docId, Promise promise) {
    Document doc = this.db.getDocument(docId);
    if (doc == null) {
      promise.reject("get_document", "Can not find document");
    } else {
      promise.resolve(doc.getString(docId));
    }
  }

  @ReactMethod
  public void saveDocument(String key, String data, Promise promise) {
    MutableDocument doc = new MutableDocument(key);
    doc.setString(key, data);
    try {
      this.db.save(doc);
      promise.resolve(true);
    } catch (CouchbaseLiteException e) {
      promise.reject("create_document", "Can not create document", e);
    }
  }

  @ReactMethod
  public void removeDocument(String docId, Promise promise) {
    Document doc = this.db.getDocument(docId);
    try {
      this.db.delete(doc);
      promise.resolve(null);
    } catch (CouchbaseLiteException e) {
      promise.reject("delete_document", "Can not delete document", e);
    }
  }

  private Map<String, Object> serializeDocument(Document document) {
    Map<String, Object> properties = new HashMap<>(document.toMap());
    properties.put("id", document.getId());
    for(Map.Entry<String, Object> entry: properties.entrySet()) {
      if (entry.getValue() instanceof Blob) {
        Blob blob = (Blob)entry.getValue();
        Map<String, Object> blobProps = new HashMap<>(blob.getProperties());
        String path = this.db.getPath().concat("Attachments/").concat( blob.digest().substring(5) ).concat(".blob");
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

}
