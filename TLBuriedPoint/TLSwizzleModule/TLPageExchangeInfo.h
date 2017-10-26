//
//  TLPageExchangeInfo.h
//  iosFetchModuleTech
//
//  Created by lichuanjun on 2017/4/11.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLPageExchangeInfo : NSObject

+ (TLPageExchangeInfo *)sharedInstance;

// 打开的当前页面的上个页面信息
@property (nonatomic, strong) NSString *referer;
// 打开的当前页面信息
@property (nonatomic, strong) NSString *current;

@end
