//
//  TLPageExchangeInfo.m
//  iosFetchModuleTech
//
//  Created by lichuanjun on 2017/4/11.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import "TLPageExchangeInfo.h"

@implementation TLPageExchangeInfo

+ (TLPageExchangeInfo *)sharedInstance
{
    static TLPageExchangeInfo *sharedReferInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedReferInstance = [[self alloc] init];
    });
    return sharedReferInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _referer = @"";
        _current = @"";
    }
    return self;
}

-(void)setReferer:(NSString *)referer {
    _referer = referer;
}

-(void)setCurrent:(NSString *)current {
    _current = current;
}

@end
