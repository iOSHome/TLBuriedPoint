//
//  TLWKWebViewController.m
//  TLBuriedPoint
//
//  Created by lichuanjun on 2017/10/27.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import "TLWKWebViewController.h"

@interface TLWKWebViewController ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation TLWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"WKWebView";
    
    UIBarButtonItem *startButton = [[UIBarButtonItem alloc] initWithTitle:@"start" style:UIBarButtonItemStylePlain target:self action:@selector(startClick)];
    UIBarButtonItem *stopButton = [[UIBarButtonItem alloc]initWithTitle:@"stop" style:UIBarButtonItemStylePlain target:self action:@selector(stopClick)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:stopButton , startButton, nil]];
    
    if (self.webView) {
        [self.view addSubview:self.webView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(WKWebView *)webView
{
    if (_webView == nil)
    {
        _webView = [[WKWebView alloc] init];
        _webView.frame = self.view.bounds;
        _webView.backgroundColor = [UIColor clearColor];
        
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
    }
    
    return _webView;
}


#pragma mark - WKUIDelegate代理方法
//UI界面相关，原生控件支持，三种提示框：输入、确认、警告。首先将web提示框拦截然后再做处理
/// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    NSLog(@"加载：打开内部链接");
    
    // 打开内部链接
    return self.webView;
    
    // 不打开
    //    return nil;
}

/// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    NSLog(@"加载：输入框提示");
    
    completionHandler(@"Client Not handler");
}

/// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
{
    NSLog(@"加载：确认框提示");
    
    //  js 里面的alert实现，如果不实现，网页的alert函数无效
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler(YES);
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action){
                                                          completionHandler(NO);
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
}

/// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    NSLog(@"加载：警告框提示");
    
    // js 里面的alert实现，如果不实现，网页的alert函数无效
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
}



#pragma mark - WKNavigationDelegate代理方法
//追踪加载过程，有是否允许加载、开始加载、加载完成、加载失败

/// 接收到服务器跳转请求之后调用 (服务器端redirect)，不一定调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO ;
    
    NSLog(@"加载：服务器跳转--%@",webView);
}

/// 1 在发送请求之前，决定是否跳转（注：不加上decisionHandler回调会造成闪退）
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES ;
    
    NSLog(@"加载：发送请求是否跳转--%@",webView);
    
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    // 这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
}

/// 2 页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES ;
    
    NSLog(@"加载：开始--url:%@",webView.URL);
}

/// 3 在收到服务器的响应头，根据response相关信息，决定是否跳转。decisionHandler必须调用，来决定是否跳转，参数WKNavigationActionPolicyCancel取消跳转，WKNavigationActionPolicyAllow允许跳转（注：不加上decisionHandler回调会造成闪退）
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    NSLog(@"加载：服务器响应头--url:%@",webView.URL);
    
    WKNavigationResponsePolicy responsePolicy = WKNavigationResponsePolicyAllow;
    // 这句是必须加上的，不然会异常
    decisionHandler(responsePolicy);
}

/// 4 开始获取到网页内容时返回
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES ;
    
    NSLog(@"加载：开始获取信息--url:%@",webView.URL);
}

/// 5 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO ;
    
    NSLog(@"加载：完成--url:%@--title:%@",webView.URL,webView.title);
}

/// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO ;
    
    NSLog(@"加载：失败--url:%@",webView.URL);
}

#pragma mark - 打开web页面，或停止加载web页面

- (void)startClick
{
    if ([_webView isLoading])
    {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:@"https://m.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    NSLog(@"加载：启动");
}

- (void)stopClick
{
    if ([_webView isLoading])
    {
        [_webView stopLoading];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSLog(@"加载：停止");
    }
}

-(void)dealloc
{
    _webView.UIDelegate = nil;
    _webView.navigationDelegate = nil;
    [_webView loadHTMLString:@"" baseURL:nil];
    [_webView stopLoading];
    [_webView removeFromSuperview];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    _webView = nil;
}

@end
