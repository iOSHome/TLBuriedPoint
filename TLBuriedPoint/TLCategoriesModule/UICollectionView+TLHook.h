//
//  UICollectionView+TLHook.h
//  TLBuriedPoint
//
//  Created by lichuanjun on 2017/10/26.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionViewDelegateForwarder : NSObject<UICollectionViewDelegate>

@property (nonatomic, weak, nullable) id <UICollectionViewDelegate> delegate;

@end

@interface UICollectionView (TLHook)

@end
