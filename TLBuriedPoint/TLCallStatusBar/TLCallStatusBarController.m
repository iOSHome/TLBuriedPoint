//
//  TLCallStatusBarController.m
//  TLBuriedPoint
//
//  Created by lichuanjun on 2023/4/14.
//  Copyright © 2023 lichuanjun. All rights reserved.
//

#import "TLCallStatusBarController.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "Masonry.h"
#import "TLStringUtil.h"

@interface TLCallStatusBarController ()

@property (nonatomic, strong) UIButton *btnPhoneCall;
@property (nonatomic, strong) UIButton *btnRareCharacter;
@property (nonatomic, strong) UIButton *btnSimplifiedCharacter;
@property (nonatomic, strong) UILabel *lblRareCharacter;
@property (nonatomic, strong) UILabel *lblSimplifiedCharacter;

@end

@implementation TLCallStatusBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"状态栏";
    
    //    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 300, 300, 50)];
    //    [btn setTitle:@"测试" forState:UIControlStateNormal];
    //    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //    [btn setBackgroundColor:[UIColor lightGrayColor]];
    //    [btn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:btn];
    
    [self initView];
    
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(statusBarFrameChanged:)
    //                                                 name:@"Status Bar Frame Change"
    //                                               object:[[UIApplication sharedApplication] delegate]];
    
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(cameBackFromSleep:)
    //                                                 name:@"UIApplicationDidBecomeActive"
    //                                               object:nil];
    
    //    NSLog(@"statusBarFrame.size.height = %ld", (long)[UIApplication sharedApplication].statusBarFrame.size.height);
}

//- (void)statusBarFrameChanged:(NSNotification*)notification
//{
//    CGRect newFrame = [[notification.userInfo objectForKey:@"current status bar frame"] CGRectValue];
//    NSLog(@"new height %f", CGRectGetHeight(newFrame));
//}

//- (void)cameBackFromSleep:(NSNotification*)notification
//{
//    CGRect newFrame = [[notification.userInfo objectForKey:@"current status bar frame"] CGRectValue];
//    NSLog(@"new height %f", CGRectGetHeight(newFrame));
//}

/*
 Returns TRUE/YES if the user is currently on a phone call
 */
-(bool)isOnPhoneCall {
    CTCallCenter *callCenter = [[CTCallCenter alloc] init];
    for (CTCall *call in callCenter.currentCalls) {
        if (call.callState == CTCallStateConnected) {
            return YES;
        }
    }
    return NO;
}

-(bool)isIncomingPhoneCall {
    CTCallCenter *callCenter = [[CTCallCenter alloc] init];
    for (CTCall *call in callCenter.currentCalls) {
        if (call.callState == CTCallStateIncoming) {
            return YES;
        }
    }
    return NO;
}

-(bool)isDialingPhoneCall {
    CTCallCenter *callCenter = [[CTCallCenter alloc] init];
    for (CTCall *call in callCenter.currentCalls) {
        if (call.callState == CTCallStateDialing) {
            return YES;
        }
    }
    return NO;
}

-(bool)isDisconnectedPhoneCall {
    CTCallCenter *callCenter = [[CTCallCenter alloc] init];
    for (CTCall *call in callCenter.currentCalls) {
        if (call.callState == CTCallStateDisconnected) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - init View

-(void)initView {
    [self.view addSubview:self.btnPhoneCall];
    [self.view addSubview:self.btnRareCharacter];
    [self.view addSubview:self.btnSimplifiedCharacter];
    [self.view addSubview:self.lblRareCharacter];
    [self.view addSubview:self.lblSimplifiedCharacter];
    
    [self layout];
}

-(void)layout{
    [self.btnPhoneCall mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(150);
        make.left.mas_equalTo(30);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(60);
    }];
    [self.btnRareCharacter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.btnPhoneCall.mas_bottom).offset(20);
        make.left.mas_equalTo(30);
        make.width.mas_equalTo(self.btnPhoneCall);
        make.height.mas_equalTo(self.btnPhoneCall);
    }];
    [self.btnSimplifiedCharacter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.btnRareCharacter.mas_bottom).offset(20);
        make.left.mas_equalTo(30);
        make.width.mas_equalTo(self.btnPhoneCall);
        make.height.mas_equalTo(self.btnPhoneCall);
    }];
    
    [self.lblRareCharacter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.btnRareCharacter);
        make.left.mas_equalTo(self.btnRareCharacter.mas_right).offset(20);
        make.height.mas_equalTo(self.btnRareCharacter);
        make.right.mas_equalTo(-30);
    }];
    
    [self.lblSimplifiedCharacter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.btnSimplifiedCharacter);
        make.left.mas_equalTo(self.btnSimplifiedCharacter.mas_right).offset(20);
        make.height.mas_equalTo(self.btnSimplifiedCharacter);
        make.right.mas_equalTo(-30);
    }];
}
#pragma  mark - Lazy

-(UIButton *)btnPhoneCall {
    if(!_btnPhoneCall) {
        _btnPhoneCall = [[UIButton alloc] init];
        [_btnPhoneCall setTitle:@"拨打电话状态" forState:UIControlStateNormal];
        [_btnPhoneCall setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_btnPhoneCall setBackgroundColor:[UIColor lightGrayColor]];
        [_btnPhoneCall addTarget:self action:@selector(phoneCallAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _btnPhoneCall;
}

-(UIButton *)btnRareCharacter {
    if(!_btnRareCharacter) {
        _btnRareCharacter = [[UIButton alloc] init];
        [_btnRareCharacter setTitle:@"生僻字正则" forState:UIControlStateNormal];
        [_btnRareCharacter setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_btnRareCharacter setBackgroundColor:[UIColor lightGrayColor]];
        [_btnRareCharacter addTarget:self action:@selector(rareCharacterAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _btnRareCharacter;
}

-(UIButton *)btnSimplifiedCharacter {
    if(!_btnSimplifiedCharacter) {
        _btnSimplifiedCharacter = [[UIButton alloc] init];
        [_btnSimplifiedCharacter setTitle:@"简体字正则" forState:UIControlStateNormal];
        [_btnSimplifiedCharacter setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_btnSimplifiedCharacter setBackgroundColor:[UIColor lightGrayColor]];
        [_btnSimplifiedCharacter addTarget:self action:@selector(simplifiedCharacterAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _btnSimplifiedCharacter;
}

-(UILabel *)lblRareCharacter {
    if (!_lblRareCharacter) {
        _lblRareCharacter = [[UILabel alloc] init];
        _lblRareCharacter.textColor = [UIColor blueColor];
        _lblRareCharacter.backgroundColor = [UIColor yellowColor];
    }
    return _lblRareCharacter;
}

-(UILabel *)lblSimplifiedCharacter {
    if (!_lblSimplifiedCharacter) {
        _lblSimplifiedCharacter = [[UILabel alloc] init];
        _lblSimplifiedCharacter.textColor = [UIColor blueColor];
        _lblSimplifiedCharacter.backgroundColor = [UIColor yellowColor];
    }
    return _lblSimplifiedCharacter;
}

#pragma mark - action

-(void)phoneCallAction {
    NSLog(@"电话已连接：%d", [self isOnPhoneCall]);
    NSLog(@"呼叫进来：%d", [self isIncomingPhoneCall]);
    NSLog(@"呼叫状态拨号：%d", [self isDialingPhoneCall]);
    NSLog(@"呼叫已断开连接：%d", [self isDisconnectedPhoneCall]);
}


-(void)rareCharacterAction {
    BOOL bRareCharacter = [TLStringUtil isIdCardNameRareCharacter:@"刘䶮煜·竉垄台灣"];
    self.lblRareCharacter.text = [NSString stringWithFormat:@"刘䶮煜·竉垄台灣：%d", bRareCharacter];
    NSLog(@"=====%d",bRareCharacter);
}

-(void)simplifiedCharacterAction {
    BOOL bSimplifiedCharacter = [TLStringUtil isIdCardName:@"刘龚煜"];
    self.lblSimplifiedCharacter.text = [NSString stringWithFormat:@"刘龚煜：%d", bSimplifiedCharacter];
    NSLog(@"=====%d",bSimplifiedCharacter);
}

@end
