'use strict';

import { NativeModules } from "react-native";
const CBLiteStorage = NativeModules.CouchbaseLiteStorage;

const CouchbaseLiteStorage = {
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
                    callback && callback(error)
                    if (!callback) throw error
                })
  },

  multiGet(
    key: string
  ): Promise { 
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
                    callback && callback(error)
                    if (!callback) throw error
                })
  },

  multiSet(
    key: string,
    value: Array<any>,
  ): Promise { 
        return CBLiteStorage.multiSet(key, value);
  },

  removeItem(
    key: string,
    callback?: ?(error: ?Error) => void
  ): Promise {
        return CBLiteStorage.removeDocument(key)
                .then(() => callback && callback())
                .catch(error => {
                    callback && callback(error)
                    if (!callback) throw error
                })
  },

  openDb(name: string): Promise {
    return CBLiteStorage.openDb(name);
  }

}

export default CouchbaseLiteStorage;
