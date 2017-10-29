//
//  TLHookAE+TLAutomaticEvents.h
//  TLBuriedPoint
//
//  Created by lichuanjun on 2017/10/29.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import "TLHookAE.h"

@interface TLHookAE (TLAutomaticEvents)

+ (instancetype)sharedAutomatedInstance;
+ (void)setSharedAutomatedInstance:(TLHookAE *)instance;

@end
