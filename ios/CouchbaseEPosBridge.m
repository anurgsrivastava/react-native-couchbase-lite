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

RCT_EXPORT_METHOD(saveDocument:(NSString *)key
                  document:(NSString *)doc
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    CouchbaseEPos *objCouchbaseEPos = [[CouchbaseEPos alloc] init];
    [objCouchbaseEPos saveDocumentWithKey: key doc:doc completionBlock:^(NSString * strDoc) {
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
    CouchbaseEPos *objCouchbaseEPos = [[CouchbaseEPos alloc] init];
    [objCouchbaseEPos getDocumentWithKey: key completionBlock:^(NSString * strData) {
        if (![strData isEqualToString: Constants.ERROR]) {
            resolve(strData);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:@"123" code:123 userInfo:nil];
            reject(Constants.ERROR, Constants.ERROR_IN_FETCHING, error);
        }
    }];
}

RCT_EXPORT_METHOD(deleteDocument:(NSString *)key
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    CouchbaseEPos *objCouchbaseEPos = [[CouchbaseEPos alloc] init];
    [objCouchbaseEPos deleteDocumentWithKey: key completionBlock:^(NSString * strData) {
        if ([strData isEqualToString: Constants.SUCCESS]) {
            resolve(strData);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:@"123" code:123 userInfo:nil];
            reject(Constants.ERROR, strData, error);
        }
    }];
}

RCT_EXPORT_METHOD(pushReplicator:(NSString *)sessionKey
                  Resolver:(RCTPromiseResolveBlock)resolve
                  Rejecter:(RCTPromiseRejectBlock)reject) {
    CouchbaseEPos *objCouchbaseEPos = [[CouchbaseEPos alloc] init];
    [objCouchbaseEPos pushReplicatorWithSessionKey: sessionKey completionBlock:^(NSString * strDoc) {
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
    CouchbaseEPos *objCouchbaseEPos = [[CouchbaseEPos alloc] init];
    [objCouchbaseEPos pullReplicatorWithSessionKey: sessionKey completionBlock:^(NSString * strDoc) {
        if ([strDoc isEqualToString:Constants.SUCCESS]) {
            resolve(strDoc);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:@"123" code:123 userInfo:nil];
            reject(Constants.ERROR, @"", error);
        }
    }];
}

RCT_EXPORT_METHOD(multiSet:(NSString *)key value:(NSArray *)value
                  Resolver:(RCTPromiseResolveBlock)resolve
                  Rejecter:(RCTPromiseRejectBlock)reject) {
    
    CouchbaseEPos *objCouchbaseEPos = [[CouchbaseEPos alloc] init];
    [objCouchbaseEPos multiSetWithKey: key value:value completionBlock:^(NSString * strDoc) {
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
    
    CouchbaseEPos *objCouchbaseEPos = [[CouchbaseEPos alloc] init];
    [objCouchbaseEPos multiGetWithType: type completionBlock:^(NSArray* arrData) {
        if (arrData.count > 0) {
            resolve(arrData);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:@"123" code:123 userInfo:nil];
            reject(Constants.ERROR, Constants.ERROR_IN_SAVING, error);
        }
    }];
}

RCT_EXPORT_METHOD(getLocalDocument:(NSString *)docId
                  Resolver:(RCTPromiseResolveBlock)resolve
                  Rejecter:(RCTPromiseRejectBlock)reject) {
    
    CouchbaseEPos *objCouchbaseEPos = [[CouchbaseEPos alloc] init];
    [objCouchbaseEPos getLocalDocumentWithDocId: docId completionBlock:^(NSString* docList) {
        if (![docList isEqualToString: Constants.ERROR]) {
            resolve(docList);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:@"123" code:123 userInfo:nil];
            reject(Constants.ERROR, Constants.ERROR_IN_SAVING, error);
        }
    }];
}

RCT_EXPORT_METHOD(saveLocalDocument:(NSString *)key
                  document:(NSString *)doc
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    CouchbaseEPos *objCouchbaseEPos = [[CouchbaseEPos alloc] init];
    [objCouchbaseEPos saveLocalDocumentWithKey: key doc:doc completionBlock:^(NSString * strDoc) {
        if ([strDoc isEqualToString:Constants.SUCCESS]) {
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
    CouchbaseEPos *objCouchbaseEPos = [[CouchbaseEPos alloc] init];
    [objCouchbaseEPos deleteLocalDocumentWithKey: key completionBlock:^(NSString * strData) {
        if ([strData isEqualToString: Constants.SUCCESS]) {
            resolve(strData);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:@"123" code:123 userInfo:nil];
            reject(Constants.ERROR, strData, error);
        }
    }];
}

@end
