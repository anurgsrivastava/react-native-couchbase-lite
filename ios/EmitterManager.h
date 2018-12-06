//
//  EmitterManager.h
//  workbench
//
//  Created by Sourab on 29/11/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EmitterManager : NSObject

- (void)initiateEmitterWithEventDict:(NSDictionary*)eventDict;

@end

NS_ASSUME_NONNULL_END
