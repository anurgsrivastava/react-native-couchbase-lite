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

RCT_EXPORT_MODULE(CouchbaseEPosBridge);

RCT_EXPORT_METHOD(saveDocument:(NSString *)key document:(NSString *)doc resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
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

RCT_EXPORT_METHOD(getDocument:(NSString *)key resolver:(RCTPromiseResolveBlock)resolve
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

RCT_EXPORT_METHOD(deleteDocument:(NSString *)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
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


@end
