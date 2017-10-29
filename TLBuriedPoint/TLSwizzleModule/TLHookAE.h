//
//  TLHookAE.h
//  TLBuriedPoint
//
//  Created by lichuanjun on 2017/10/29.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLHookAE : NSObject

+ (TLHookAE *)sharedInstance;
+ (TLHookAE *)sharedInstanceWithToken:(NSString *)apiToken launchOptions:(NSDictionary *)launchOptions;

- (instancetype)initWithToken:(NSString *)apiToken;
- (instancetype)initWithToken:(NSString *)apiToken launchOptions:(NSDictionary *)launchOptions;

@property (nonatomic, assign) BOOL validationEnabled;
@end
