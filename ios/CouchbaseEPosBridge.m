//
//  CouchbaseEPosBridge.m
//  workbench
//
//  Created by Sourab on 26/11/18.
//  Copyright © 2018 Facebook. All rights reserved.
//
#import "CouchbaseEPosBridge.h"
#import "RNReactNativeCbl-Swift.h"

@implementation CouchbaseEPosBridge

RCT_EXPORT_MODULE(CouchbaseLiteStorage); // CBLiteStorage

#pragma mark openDb
RCT_EXPORT_METHOD(openDb:(nonnull NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    //    if (!_objCouchbaseEpos) {
    //        _objCouchbaseEpos = [[CouchbaseEPos alloc] init];
    //    }
    CouchbaseEPos *objCouchbaseEPos = [[CouchbaseEPos alloc] init];
    [objCouchbaseEPos openDbWithName: name completionBlock:^(NSString * strStatus) {
        if ([strStatus isEqualToString:Constants.SUCCESS]) {
            resolve(strStatus);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:@"123" code:123 userInfo:nil];
            reject(Constants.ERROR, Constants.ERROR_IN_CREATING_DB, error);
        }
    }];
}

#pragma mark initialiseDBWithAgentId
RCT_EXPORT_METHOD(initialiseDBWithAgentId:(nonnull NSString*)dbName
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    //    CouchbaseEPos *objCouchbaseEPos = [[CouchbaseEPos alloc] init];
    if (!_objCouchbaseEpos) {
        _objCouchbaseEpos = [[CouchbaseEPos alloc] init];
    }
    
    [_objCouchbaseEpos initialiseDBWithAgentIdWithDbName: dbName completionBlock:^(NSString * strStatus) {
        if ([strStatus isEqualToString:Constants.SUCCESS]) {
            resolve(strStatus);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:@"123" code:123 userInfo:nil];
            reject(Constants.ERROR, Constants.ERROR_IN_CREATING_DB, error);
        }
    }];
}

#pragma mark doc save get and delete
RCT_EXPORT_METHOD(saveDocument:(NSString *)key
                  document:(NSString *)doc
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    //    CouchbaseEPos *objCouchbaseEPos = [[CouchbaseEPos alloc] init];
    [_objCouchbaseEpos saveDocumentWithKey: key doc:doc completionBlock:^(NSString * strDoc) {
        if ([strDoc isEqualToString:Constants.SUCCESS]) {
            resolve(strDoc);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:@"123" code:123 userInfo:nil];
            reject(Constants.ERROR, Constants.ERROR_IN_SAVING, error);
        }
    }];
}

RCT_EXPORT_METHOD(getDocument:(NSString *)key
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    //    CouchbaseEPos *objCouchbaseEPos = [[CouchbaseEPos alloc] init];
    [_objCouchbaseEpos getDocumentWithKey: key completionBlock:^(NSString * strData) {
        if (![strData isEqualToString: Constants.ERROR]) {
            resolve(strData);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:@"123" code:123 userInfo:nil];
            reject(Constants.ERROR, Constants.ERROR_IN_FETCHING, error);
        }
    }];
}

RCT_EXPORT_METHOD(removeDocument:(NSString *)key
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    //    CouchbaseEPos *objCouchbaseEPos = [[CouchbaseEPos alloc] init];
    [_objCouchbaseEpos deleteDocumentWithKey: key completionBlock:^(NSString * strData) {
        if ([strData isEqualToString: Constants.SUCCESS]) {
            resolve(strData);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:@"123" code:123 userInfo:nil];
            reject(Constants.ERROR, strData, error);
        }
    }];
}

#pragma mark push and pull replicators
RCT_EXPORT_METHOD(pushReplicator:(NSString *)sessionKey
                  Resolver:(RCTPromiseResolveBlock)resolve
                  Rejecter:(RCTPromiseRejectBlock)reject) {
    //    CouchbaseEPos *objCouchbaseEPos = [[CouchbaseEPos alloc] init];
    [_objCouchbaseEpos pushReplicatorWithSessionKey: sessionKey completionBlock:^(NSString * strDoc) {
        if ([strDoc isEqualToString:Constants.SUCCESS]) {
            resolve(strDoc);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:@"123" code:123 userInfo:nil];
            reject(Constants.ERROR, @"", error);
        }
    }];
}

RCT_EXPORT_METHOD(pullReplicator:(NSString *)sessionKey
                  Resolver:(RCTPromiseResolveBlock)resolve
                  Rejecter:(RCTPromiseRejectBlock)reject) {
    //    CouchbaseEPos *objCouchbaseEPos = [[CouchbaseEPos alloc] init];
    [_objCouchbaseEpos pullReplicatorWithSessionKey: sessionKey completionBlock:^(NSString * strDoc) {
        if ([strDoc isEqualToString:Constants.SUCCESS]) {
            resolve(strDoc);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:@"123" code:123 userInfo:nil];
            reject(Constants.ERROR, @"", error);
        }
    }];
}

#pragma mark multiSet and multiGet
RCT_EXPORT_METHOD(multiSet:(NSString *)key value:(NSArray *)value
                  Resolver:(RCTPromiseResolveBlock)resolve
                  Rejecter:(RCTPromiseRejectBlock)reject) {
    
    //    CouchbaseEPos *objCouchbaseEPos = [[CouchbaseEPos alloc] init];
    [_objCouchbaseEpos multiSetWithKey: key value:value completionBlock:^(NSString * strDoc) {
        if ([strDoc isEqualToString:Constants.SUCCESS]) {
            resolve(strDoc);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:@"123" code:123 userInfo:nil];
            reject(Constants.ERROR, Constants.ERROR_IN_SAVING, error);
        }
    }];
}

RCT_EXPORT_METHOD(multiGet:(NSString *)type
                  Resolver:(RCTPromiseResolveBlock)resolve
                  Rejecter:(RCTPromiseRejectBlock)reject) {
    
    //    CouchbaseEPos *objCouchbaseEPos = [[CouchbaseEPos alloc] init];
    [_objCouchbaseEpos multiGetWithType: type completionBlock:^(NSArray* arrData) {
        if (arrData.count > 0) {
            if ([arrData isKindOfClass: [NSString class]]) {
                NSString *strError = arrData[0];
                if (strError && strError != nil && [strError isEqualToString:Constants.ERROR]) {
                    NSLog(@"Error in multiGet where type is :: %@", type);
                    NSError *error = [[NSError alloc] initWithDomain:@"123" code:123 userInfo:nil];
                    reject(Constants.ERROR, Constants.ERROR_IN_FETCHING, error);
                } else {
                    resolve(arrData);
                }
            } else {
                resolve(arrData);
            }
        } else {
            resolve(arrData);
        }
        //        else {
        //            NSLog(@"Error in multiGet where type is :: %@", type);
        //            NSError *error = [[NSError alloc] initWithDomain:@"123" code:123 userInfo:nil];
        //            reject(Constants.ERROR, Constants.ERROR_IN_FETCHING, error);
        //        }
    }];
}

#pragma mark localDb
RCT_EXPORT_METHOD(getLocalDocument:(NSString *)docId
                  Resolver:(RCTPromiseResolveBlock)resolve
                  Rejecter:(RCTPromiseRejectBlock)reject) {
    
    //    CouchbaseEPos *objCouchbaseEPos = [[CouchbaseEPos alloc] init];
    if (!_objCouchbaseEpos) {
        _objCouchbaseEpos = [[CouchbaseEPos alloc] init];
    }
    
    [_objCouchbaseEpos getLocalDocumentWithDocId: docId completionBlock:^(NSString* docList) {
        if (![docList isEqualToString: Constants.ERROR]) {
            resolve(docList);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:@"123" code:123 userInfo:nil];
            reject(Constants.ERROR, Constants.ERROR_IN_FETCHING, error);
        }
    }];
}

RCT_EXPORT_METHOD(saveLocalDocument:(NSString *)key
                  document:(NSString *)doc
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    //    CouchbaseEPos *objCouchbaseEPos = [[CouchbaseEPos alloc] init];
    if (!_objCouchbaseEpos) {
        _objCouchbaseEpos = [[CouchbaseEPos alloc] init];
    }
    
    [_objCouchbaseEpos saveLocalDocumentWithKey: key doc:doc completionBlock:^(NSString * strDoc) {
        if (![strDoc isEqualToString:Constants.ERROR]) {
            resolve(strDoc);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:@"123" code:123 userInfo:nil];
            reject(Constants.ERROR, Constants.ERROR_IN_SAVING, error);
        }
    }];
}

RCT_EXPORT_METHOD(deleteLocalDocument:(NSString *)key
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    //    CouchbaseEPos *objCouchbaseEPos = [[CouchbaseEPos alloc] init];
    if (!_objCouchbaseEpos) {
        _objCouchbaseEpos = [[CouchbaseEPos alloc] init];
    }
    
    [_objCouchbaseEpos deleteLocalDocumentWithKey: key completionBlock:^(NSString * strData) {
        if ([strData isEqualToString: Constants.SUCCESS]) {
            resolve(strData);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:@"123" code:123 userInfo:nil];
            reject(Constants.ERROR, strData, error);
        }
    }];
}

@end
