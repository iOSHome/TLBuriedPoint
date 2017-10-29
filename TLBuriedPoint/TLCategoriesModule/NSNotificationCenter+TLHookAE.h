//
//  NSNotificationCenter+TLHookAE.h
//  TLBuriedPoint
//
//  Created by lichuanjun on 2017/10/29.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNotificationCenter (TLHookAE)

- (void)tl_postNotification:(NSNotification *)notification;

- (void)tl_postNotificationName:(NSString *)name
                         object:(nullable id)object
                       userInfo:(nullable NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
