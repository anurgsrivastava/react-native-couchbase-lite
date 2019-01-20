"use strict";

import { NativeModules } from "react-native";
const CBLiteStorage = NativeModules.CouchbaseLiteStorage;

const CouchbaseLiteStorage = {
  pushItem(
    key: any,
    callback?: ?(error: ?Error, result: ?string) => void
  ): Promise {
    return CBLiteStorage.pushReplicator(key)
      .then(data => {
        callback && callback(null, data);
        return data;
      })
      .catch(error => {
        callback && callback(error);
        if (!callback) throw error;
      });
  },

  pullItem(
    key: any,
    callback?: ?(error: ?Error, result: ?string) => void
  ): Promise {
    return CBLiteStorage.pullReplicator(key)
      .then(data => {
        callback && callback(null, data);
        return data;
      })
      .catch(error => {
        callback && callback(error);
        if (!callback) throw error;
      });
  },

  getItem(
    key: string,
    callback?: ?(error: ?Error, result: ?string) => void
  ): Promise {
    return CBLiteStorage.getDocument(key)
      .then(data => {
        callback && callback(null, data);
        return data;
      })
      .catch(error => {
        callback && callback(error);
        if (!callback) throw error;
      });
  },

  getLocalDocument(
    key: string,
    callback?: ?(error: ?Error, result: ?string) => void
  ): Promise {
    return CBLiteStorage.getLocalDocument(key)
      .then(data => {
        callback && callback(null, data);
        return data;
      })
      .catch(error => {
        callback && callback(error);
        if (!callback) throw error;
      });
  },

  multiGet(key: string): Promise {
    return CBLiteStorage.multiGet(key);
  },

  setItem(
    key: string,
    value: any,
    callback?: ?(error: ?Error) => void
  ): Promise {
    return CBLiteStorage.saveDocument(key, value)
      .then(() => callback && callback())
      .catch(error => {
        callback && callback(error);
        if (!callback) throw error;
      });
  },

  saveLocalDocument(
    key: string,
    value: any,
    callback?: ?(error: ?Error) => void
  ): Promise {
    return CBLiteStorage.saveLocalDocument(key, value)
      .then(data => {
        callback && callback(null, data);
        return data;
      })
      .catch(error => {
        callback && callback(error);
        if (!callback) throw error;
      });
  },

  deleteLocalDocument(
    key: string,
    callback?: ?(error: ?Error, result: ?string) => void
  ): Promise {
    return CBLiteStorage.deleteLocalDocument(key)
      .then(data => {
        callback && callback(null, data);
        return data;
      })
      .catch(error => {
        callback && callback(error);
        if (!callback) throw error;
      });
  },

  multiSet(key: string, value: Array<any>): Promise {
    return CBLiteStorage.multiSet(key, value);
  },

  removeItem(key: string, callback?: ?(error: ?Error) => void): Promise {
    return CBLiteStorage.removeDocument(key)
      .then(() => callback && callback())
      .catch(error => {
        callback && callback(error);
        if (!callback) throw error;
      });
  },

  createDatabase(dbName: string, callback?: ?(error: ?Error) => void): Promise {
    return CBLiteStorage.createDatabase(dbName)
      .then(data => {
        callback && callback(null, data);
        return data;
      })
      .catch(error => {
        callback && callback(error);
        if (!callback) throw error;
      });
  },

};

export default CouchbaseLiteStorage;
