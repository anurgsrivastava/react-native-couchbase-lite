//
//  BridgeEmitter.m
//  workbench
//
//  Created by Sourab on 29/11/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "BridgeEmitter.h"

@implementation BridgeEmitter

RCT_EXPORT_MODULE(BridgeEmitter);
@synthesize bridge = _bridge;

+ (id)allocWithZone:(NSZone *)zone {
  static BridgeEmitter *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [super allocWithZone:zone];
  });
  return sharedInstance;
}

- (NSArray<NSString *> *)supportedEvents {
  return @[@"com.workBench.ePos.dataFetched"];
}

- (void)sendDataToJS:(NSDictionary *)eventDict {
  NSDictionary *d = [NSDictionary dictionary];
  d = eventDict;
  [self sendEventWithName:@"com.workBench.ePos.dataFetched" body:d];
}


@end
