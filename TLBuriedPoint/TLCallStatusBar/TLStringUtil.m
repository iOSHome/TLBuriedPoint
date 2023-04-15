//
//  NWDStringUtil.m
//  TLBuriedPoint
//
//  Created by lichuanjun on 2023/4/14.
//  Copyright © 2023 lichuanjun. All rights reserved.
//

#import "TLStringUtil.h"
#import "RegexKitLite.h"

@implementation TLStringUtil

/**
 *判断字符串是否中文字符和·  校验身份证姓名，包含生僻字、繁体字
 */
+ (BOOL)isIdCardNameRareCharacter:(NSString *)validateString
{//
//    return [validateString isMatchedByRegex:@"^[\u4E00-\u9FA5.]+$"];//^[\u4e00-\u9fbb·]+$
//    NSString *chinasRegex = @"^[\u2E80-\uFE4F·]+$";
//    NSString *chinasRegex = @"^((?![\u3000-\u303F])[\u2E80-\uFE4F]|·)(?![\u3000-\u303F])\u2E80-\uFE4F$";
//    NSPredicate *chinasTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",chinasRegex];
//    return [chinasTest evaluateWithObject:validateString];
    NSString *chinasRegex = @"^[\u9FA6-\u9FCB\u3400-\u4DB5\u4E00-\u9FA5]{1,}([\u25CF\u00B7][\u9FA6-\u9FCB\u3400-\u4DB5\u4E00-\u9FA5]{1,})*$";
    return [validateString isMatchedByRegex:chinasRegex];
    
}

/**
 *判断字符串是否中文字符和·  校验身份证姓名，不包含生僻字
 */
+ (BOOL)isIdCardName:(NSString *)validateString
{
    return [validateString isMatchedByRegex:@"^[\u9FA6-\u9FCB\u3400-\u4DB5\u4E00-\u9FA5]{1,}([\u25CF\u00B7][\u9FA6-\u9FCB\u3400-\u4DB5\u4E00-\u9FA5]{1,})*$"];
}

@end
