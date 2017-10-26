//
//  TLObjectPath.h
//  Specter
//
//  Created by lichuanjun on 2017/4/1.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+TLHook.h"

@interface TLObjectPath : NSObject

- (NSString *)getPathWithObject:(NSObject *)object;

- (NSString *)getInterfacePathWithObject:(id)object;

@end

#pragma mark - Strings
static NSString *const kObjectPathName = @"path";
static NSString *const kCurrentUrlPathName = @"current_url";
static NSString *const kRefererPathName = @"referer";
static NSString *const kObjectEventPrefix = @"ios_event";
