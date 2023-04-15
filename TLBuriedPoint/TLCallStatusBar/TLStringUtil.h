//
//  TLStringUtil.h
//  TLBuriedPoint
//
//  Created by lichuanjun on 2023/4/14.
//  Copyright © 2023 lichuanjun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TLStringUtil : NSObject

/**
 *判断字符串是否中文字符和·  校验身份证姓名，包含生僻字
 */
+ (BOOL)isIdCardNameRareCharacter:(NSString *)validateString;
/**
 *判断字符串是否中文字符和·  校验身份证姓名，不包含生僻字
 */
+ (BOOL)isIdCardName:(NSString *)validateString;

@end

NS_ASSUME_NONNULL_END
