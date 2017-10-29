//
//  TLHookAE+TLAutomaticEvents.m
//  TLBuriedPoint
//
//  Created by lichuanjun on 2017/10/29.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import "TLHookAE+TLAutomaticEvents.h"
#import "TLHookAE.h"
#import "TLSwizzle.h"
#import "UIViewController+TLHook.h"
#import "UIApplication+TLHookAE.h"

@implementation TLHookAE (TLAutomaticEvents)

static TLHookAE *gSharedAutomatedInstance = nil;
+ (instancetype)sharedAutomatedInstance {
    return gSharedAutomatedInstance;
}

+ (void)setSharedAutomatedInstance:(TLHookAE *)instance {
    gSharedAutomatedInstance = instance;
    [self addSwizzles];
}

+ (void)addSwizzles {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSError *error = NULL;
        
        // Navigation
        [UIViewController tl_swizzleMethod:@selector(viewWillAppear:)
                                withMethod:@selector(tl_viewWillAppear:)
                                     error:&error];
        if (error) {
            NSLog(@"Failed to swizzle viewWillAppear: on UIViewController. Details: %@", error);
            error = NULL;
        }
        
        [UIViewController tl_swizzleMethod:@selector(viewDidAppear:)
                                withMethod:@selector(tl_viewDidAppear:)
                                     error:&error];
        if (error) {
            NSLog(@"Failed to swizzle viewDidAppear: on UIViewController. Details: %@", error);
            error = NULL;
        }
        
        [UIViewController tl_swizzleMethod:@selector(viewWillDisappear:)
                                withMethod:@selector(tl_viewWillDisappear:)
                                     error:&error];
        if (error) {
            NSLog(@"Failed to swizzle viewDidDisappear: on UIViewController. Details: %@", error);
            error = NULL;
        }
        
        // UIApplication Actions
        [UIApplication tl_swizzleMethod:@selector(sendAction:to:from:forEvent:)
                             withMethod:@selector(tl_sendAction:to:from:forEvent:)
                                  error:&error];
        if (error) {
            NSLog(@"Failed to swizzle sendAction:to:from:forEvent: on UIAppplication. Details: %@", error);
            error = NULL;
        }
        
//        // Notifications
//        [NSNotificationCenter sp_swizzleMethod:@selector(postNotification:)
//                                    withMethod:@selector(sp_postNotification:)
//                                         error:&error];
//        if (error) {
//            SPLogError(@"Failed to swizzle postNotification: on NSNotificationCenter. Details: %@", error);
//            error = NULL;
//        }
//        
//        [NSNotificationCenter sp_swizzleMethod:@selector(postNotificationName:object:userInfo:)
//                                    withMethod:@selector(sp_postNotificationName:object:userInfo:)
//                                         error:&error];
//        if (error) {
//            SPLogError(@"Failed to swizzle postNotificationName:object:userInfo: on NSNotificationCenter. Details: %@", error);
//            error = NULL;
//        }
        
    });
}

@end
