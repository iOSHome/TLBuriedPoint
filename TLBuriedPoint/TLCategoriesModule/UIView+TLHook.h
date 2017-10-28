//
//  UIView+TLHook.h
//  TLBuriedPoint
//
//  Created by lichuanjun on 2017/10/26.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TLHook)

- (UIImage *)tl_snapshotImage;
- (UIImage *)tl_snapshotForBlur;
- (int)tl_fingerprintVersion;
- (NSString *)tl_text;

- (NSString *)tl_viewId;
- (NSString *)tl_varA;
- (NSString *)tl_varE;

@end
