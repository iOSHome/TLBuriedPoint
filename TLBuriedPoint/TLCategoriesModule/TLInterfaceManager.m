//
//  TLInterfaceManager.m
//  TLBuriedPoint
//
//  Created by lichuanjun on 2017/10/28.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import "TLInterfaceManager.h"

@implementation TLInterfaceManager

+ (TLInterfaceManager *)sharedInstance
{
    static TLInterfaceManager *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _referrer = @"";
        _current = @"";
        _currentClassName = @"";
        _currentTitle = @"";
    }
    return self;
}

-(void)setReferrer:(NSString *)referrer
{
    _referrer = referrer;
}

-(void)setCurrent:(NSString *)current
{
    _current = current;
}

-(void)setCurrentClassName:(NSString *)currentClassName
{
    _currentClassName = currentClassName;
}

-(void)setCurrentTitle:(NSString *)currentTitle
{
    _currentTitle = currentTitle;
}

@end
