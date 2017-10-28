//
//  UIGestureRecognizer+TLHook.m
//  TLBuriedPoint
//
//  Created by lichuanjun on 2017/10/26.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import "UIGestureRecognizer+TLHook.h"
#import "TLSwizzle.h"
#import "TLHookManager.h"

@implementation UIGestureRecognizer (TLHook)

+ (void)load {
    NSError *error = NULL;
    
    [self tl_swizzleMethod:@selector(initWithTarget:action:)
                withMethod:@selector(tlInitWithTarget:action:)
                     error:&error];
    if (error) {
        NSLog(@"Failed to swizzle initWithTarget:action: on UIGestureRecognizer. Details: %@", error);
        error = NULL;
    }
    
    [self tl_swizzleMethod:@selector(addTarget:action:)
                withMethod:@selector(tlAddTarget:action:)
                     error:&error];
    if (error) {
        NSLog(@"Failed to swizzle addTarget:action: on UIGestureRecognizer. Details: %@", error);
        error = NULL;
    }
}

- (instancetype)tlInitWithTarget:(nullable id)target action:(nullable SEL)action {
    id instance = [self tlInitWithTarget:target action:action];
    
    [instance tlAddTarget:[TLHookManager sharedInstance] action:@selector(gestureRecognizerAction:)];
    
    return instance;
}

- (void)tlAddTarget:(id)target action:(SEL)action {
    [self tlAddTarget:target action:action];
    
    [self tlAddTarget:[TLHookManager sharedInstance] action:@selector(gestureRecognizerAction:)];
}

@end
