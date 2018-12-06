//
//  BridgeEmitter.h
//  workbench
//
//  Created by Sourab on 29/11/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTEventEmitter.h>
#import <React/RCTBridgeModule.h>

NS_ASSUME_NONNULL_BEGIN

@interface BridgeEmitter :RCTEventEmitter<RCTBridgeModule>

- (void)sendDataToJS:(NSDictionary *)eventDict;
+ (id)allocWithZone:(NSZone *)zone;

@end

NS_ASSUME_NONNULL_END
