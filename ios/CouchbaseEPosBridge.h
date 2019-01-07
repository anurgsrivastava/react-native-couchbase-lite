//
//  CouchbaseEPosBridge.h
//  workbench
//
//  Created by Sourab on 26/11/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

@class CouchbaseEPos;

NS_ASSUME_NONNULL_BEGIN

@interface CouchbaseEPosBridge : NSObject <RCTBridgeModule>

@property(nonatomic, strong) CouchbaseEPos *objCouchbaseEpos;

@end

NS_ASSUME_NONNULL_END
