//
//  TLInterfaceManager.h
//  TLBuriedPoint
//
//  Created by lichuanjun on 2017/10/28.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLInterfaceManager : NSObject

+ (TLInterfaceManager *)sharedInstance;

// 打开的当前页面的上个页面信息
@property (nonatomic, strong) NSString *referrer;
// 打开的当前页面信息
@property (nonatomic, strong) NSString *current;
// 打开的当前页面标题
@property (nonatomic, strong) NSString *currentTitle;
// 打开的当前页面类名
@property (nonatomic, strong) NSString *currentClassName;

@end
