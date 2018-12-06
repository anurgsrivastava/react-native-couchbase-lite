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

RCT_EXPORT_METHOD(saveDataWithKey:(NSString *)key withData:(NSString *)data) {
  CouchbaseEPos *objCouchbaseEPos = [[CouchbaseEPos alloc] init];
  [objCouchbaseEPos saveDataWithKey: key data: data];
  NSLog(@"Data saved");
}

RCT_EXPORT_METHOD(getDataWithPromisses:(NSString *)key callback:(RCTResponseSenderBlock)callback) {
  
  CouchbaseEPos *objCouchbaseEPos = [[CouchbaseEPos alloc] init];
  [objCouchbaseEPos getDataWithPromissesWithKey: key completionBlock:^(NSString * strData) {
    if (![strData isEqual: @"Error"]) {
      callback(@[@"", strData]);
//      NSLog(@"Loading done");
    } else {
      callback(@[@"Error", @""]);
//      NSLog(@"Loading done with Error");
    }
  }];
}

RCT_EXPORT_METHOD(getData:(NSString *)key resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject) {
  
  CouchbaseEPos *objCouchbaseEPos = [[CouchbaseEPos alloc] init];
  [objCouchbaseEPos getDataWithPromissesWithKey: key completionBlock:^(NSString * strData) {
    if (![strData isEqual: @"Error"]) {
      resolve(strData);
//      callback(@[@"", strData]);
      //      NSLog(@"Loading done");
    } else {
      NSError *error = [[NSError alloc] initWithDomain:@"123" code:123 userInfo:nil];
      reject(@"no_events", @"There were no events", error);
//      callback(@[@"Error", @""]);
      //      NSLog(@"Loading done with Error");
    }
  }];
}


@end
