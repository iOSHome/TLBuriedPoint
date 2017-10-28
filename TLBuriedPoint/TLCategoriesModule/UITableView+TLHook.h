//
//  UITableView+TLHook.h
//  TLBuriedPoint
//
//  Created by lichuanjun on 2017/10/26.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewDelegateForwarder : NSObject<UITableViewDelegate>

@property (nonatomic, weak, nullable) id <UITableViewDelegate> delegate;

@end

@interface UITableView (TLHook)

@end
