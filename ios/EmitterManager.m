//
//  EmitterManager.m
//  workbench
//
//  Created by Sourab on 29/11/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "EmitterManager.h"
#import "BridgeEmitter.h"

@implementation EmitterManager

- (void)initiateEmitterWithEventDict:(NSDictionary*)eventDict {
  BridgeEmitter *bridgeEmitter = [BridgeEmitter allocWithZone: nil];
  [bridgeEmitter sendDataToJS: eventDict];
}

@end
