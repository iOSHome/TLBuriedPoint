//
//  TLHookMananger.h
//  TLBuriedPoint
//
//  Created by lichuanjun on 2017/10/26.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
#import <WebKit/WebKit.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface TLHookManager : NSObject

+ (TLHookManager *)sharedInstance;

// UITableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

// UICollectionView
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

// UIGestureRecognizer
- (void)gestureRecognizerAction:(UIGestureRecognizer*)gestureRecognizer;

// UIWebView
- (void)webViewDidStartLoad:(UIWebView *)webView;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

// WKWebView
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation;
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler;
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation;
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation;
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation;

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
