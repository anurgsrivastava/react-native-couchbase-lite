'use strict';

import { NativeModules } from "react-native";
const CBLiteStorage = NativeModules.CBLiteStorage;

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

  setItem(
    key: string,
    value: string,
    callback?: ?(error: ?Error) => void
  ): Promise {
        return CBLiteStorage.saveDocument(key, value)
                .then(() => callback && callback())
                .catch(error => {
                    callback && callback(error)
                    if (!callback) throw error
                })
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
