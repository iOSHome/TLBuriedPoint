//
//  TLHookAE.m
//  TLBuriedPoint
//
//  Created by lichuanjun on 2017/10/29.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import "TLHookAE.h"
#import "TLHookAE+TLAutomaticEvents.h"
#import "TLAutomaticEventsConstants.h"

@interface TLHookAE()

@property (nonatomic, copy) NSString *apiToken;

@end

@implementation TLHookAE

static NSMutableDictionary *instances;
static NSString *defaultProjectToken;

+ (TLHookAE *)sharedInstanceWithToken:(NSString *)apiToken launchOptions:(NSDictionary *)launchOptions
{
    if (instances[apiToken]) {
        return instances[apiToken];
    }
    
    return [[self alloc] initWithToken:apiToken launchOptions:launchOptions];
}

+ (TLHookAE *)sharedInstance
{
    if (instances.count == 0) {
        NSLog(@"sharedInstance called before creating a TLHookAE instance");
        return nil;
    }
    
    if (instances.count > 1) {
        NSLog(@"%@", [NSString stringWithFormat:@"sharedInstance called with multiple TLHookAE instances. Using (the first) token %@", defaultProjectToken]);
    }
    
    return instances[defaultProjectToken];
}

- (instancetype)init:(NSString *)apiToken
{
    if (self = [super init]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instances = [NSMutableDictionary dictionary];
            defaultProjectToken = apiToken;
        });
        
    }
    return self;
}

- (instancetype)initWithToken:(NSString *)apiToken launchOptions:(NSDictionary *)launchOptions
{
    if (apiToken.length == 0) {
        if (apiToken == nil) {
            apiToken = @"";
        }
        NSLog(@"%@ empty api token", self);
    }
    if (self = [self init:apiToken]) {
        self.apiToken = apiToken;
        
        instances[apiToken] = self;
        
        // 默认开启自动埋点
        self.validationEnabled = YES;
    }
    return self;
}

- (instancetype)initWithToken:(NSString *)apiToken
{
    return [self initWithToken:apiToken];
}

// 启动验证
-(void)setValidationEnabled:(BOOL)validationEnabled {
    _validationEnabled = validationEnabled;
    
    if (_validationEnabled) {
        [TLHookAE setSharedAutomatedInstance:self];
    } else {
        [TLHookAE setSharedAutomatedInstance:nil];
    }
}
@end
