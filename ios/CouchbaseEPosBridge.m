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

#pragma mark createDatabase
RCT_EXPORT_METHOD(createDatabase:(nonnull NSDictionary *)dbConfig
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    if (!_objCouchbaseEpos) {
        _objCouchbaseEpos = [[CouchbaseEPos alloc] init];
    }
    
    [_objCouchbaseEpos createDatabaseWithDbConfig: dbConfig completionBlock:^(NSString * strStatus) {
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
                  document:(NSDictionary *)data
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    [_objCouchbaseEpos saveDocumentWithKey: key data: data completionBlock:^(NSString * strDoc) {
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
    [_objCouchbaseEpos removeDocumentWithKey: key completionBlock:^(NSString * strData) {
        if ([strData isEqualToString: Constants.SUCCESS]) {
            resolve(strData);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:@"123" code:123 userInfo:nil];
            reject(Constants.ERROR, strData, error);
        }
    }];
}

#pragma mark push and pull replicators
RCT_EXPORT_METHOD(pushReplicator:(NSDictionary *)replicatorDetails
                  Resolver:(RCTPromiseResolveBlock)resolve
                  Rejecter:(RCTPromiseRejectBlock)reject) {
    [_objCouchbaseEpos pushReplicatorWithReplicatorDetails: replicatorDetails completionBlock:^(NSString * strDoc) {
        if ([strDoc isEqualToString:Constants.SUCCESS]) {
            resolve(strDoc);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:@"123" code:123 userInfo:nil];
            reject(Constants.ERROR, @"", error);
        }
    }];
}

RCT_EXPORT_METHOD(pullReplicator:(NSDictionary *)replicatorDetails
                  Resolver:(RCTPromiseResolveBlock)resolve
                  Rejecter:(RCTPromiseRejectBlock)reject) {
    [_objCouchbaseEpos pullReplicatorWithReplicatorDetails: replicatorDetails completionBlock:^(NSString * strDoc) {
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
            NSError *error = [[NSError alloc] initWithDomain:@"123" code:123 userInfo:nil];
            reject(Constants.ERROR, Constants.ERROR_IN_FETCHING, error);
            //            resolve(arrData);
        }
    }];
}

#pragma mark localDb
RCT_EXPORT_METHOD(getLocalDocument:(NSString *)docId
                  Resolver:(RCTPromiseResolveBlock)resolve
                  Rejecter:(RCTPromiseRejectBlock)reject) {
    if (!_objCouchbaseEpos) {
        _objCouchbaseEpos = [[CouchbaseEPos alloc] init];
    }
    
    [_objCouchbaseEpos getLocalDocumentWithDocId: docId completionBlock:^(NSDictionary* docList) {
        NSString *strErr = [docList valueForKey:Constants.ERROR];
        if ([strErr isEqualToString:Constants.ERROR]) {
            NSError *error = [[NSError alloc] initWithDomain:@"123" code:123 userInfo:nil];
            reject(Constants.ERROR, Constants.ERROR_IN_FETCHING, error);
        } else {
            resolve(docList);
        }
    }];
}

RCT_EXPORT_METHOD(saveLocalDocument:(NSString *)key
                  document:(NSDictionary *)data
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    if (!_objCouchbaseEpos) {
        _objCouchbaseEpos = [[CouchbaseEPos alloc] init];
    }
    
    [_objCouchbaseEpos saveLocalDocumentWithKey: key data: data completionBlock:^(NSString * strDoc) {
        if (![strDoc isEqualToString:Constants.ERROR]) {
            resolve(Constants.SUCCESS);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:@"123" code:123 userInfo:nil];
            reject(Constants.ERROR, Constants.ERROR_IN_SAVING, error);
        }
    }];
}

RCT_EXPORT_METHOD(deleteLocalDocument:(NSString *)key
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
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

#pragma mark reset
RCT_REMAP_METHOD(reset,
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject) {
    SyncGatewayConfig *sycObj = [[SyncGatewayConfig alloc] init];
    [sycObj resetReplicators];
    resolve(Constants.SUCCESS);
}

@end
