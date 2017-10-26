//
//  TLHookMananger.h
//  TLBuriedPoint
//
//  Created by lichuanjun on 2017/10/26.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TLHookManager : NSObject

+ (TLHookManager *)sharedInstance;

// UITableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

// UICollectionView
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

// UIGestureRecognizer
- (void)gestureRecognizerAction:(UIGestureRecognizer*)gestureRecognizer;

//- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item;
//- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item;
//
//
//// UIWebView
//- (void)webViewDidStartLoad:(UIWebView *)webView;
//- (void)webViewDidFinishLoad:(UIWebView *)webView;
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
//
//
//// UIScrollView
//- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView;
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;
//
//// UIAlertView
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

NS_ASSUME_NONNULL_END
