//
//  TLGestureRecognizerViewController.m
//  TLBuriedPoint
//
//  Created by lichuanjun on 2017/10/26.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import "TLGestureRecognizerViewController.h"

@interface TLGestureRecognizerViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITapGestureRecognizer *singleRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *doubleRecognizer;

@end

@implementation TLGestureRecognizerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GestureView";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initView];
    
    self.singleRecognizer = [self singleRecognizer];
    self.doubleRecognizer = [self doubleRecognizer];
    [self swipeRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initView {
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tridonlee.png"]];
    _imageView.backgroundColor = [UIColor yellowColor];
    _imageView.userInteractionEnabled = YES;
    [self.view addSubview:_imageView];
    [_imageView addGestureRecognizer:self.singleRecognizer];
    @weakify(self);
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.view).offset(100.f);
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(@(self.view.frame.size.width-30));
    }];
    
    UILabel *labelName = [[UILabel alloc] init];
    labelName.text = @"Leecj";
    labelName.backgroundColor = [UIColor cyanColor];
    labelName.textAlignment = NSTextAlignmentCenter;
    labelName.userInteractionEnabled = YES;
    [self.view addSubview:labelName];
    [labelName addGestureRecognizer:self.singleRecognizer];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(_imageView.mas_bottom).offset(10.f);
        make.left.equalTo(self.view).offset(15.f);
        make.width.equalTo(@(80));
        make.height.equalTo(@(40));
    }];
}

#pragma mark - 触摸单击

-(UITapGestureRecognizer* )singleRecognizer {
    // 单击的 Recognizer
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    //点击的次数
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    singleRecognizer.numberOfTouchesRequired = 1;
//    singleRecognizer.delegate = self;
    
    return singleRecognizer;
}

//处理单击操作
-(void)handleSingleTapGesture:(UIGestureRecognizer*)sender{
    NSLog(@"handleSingleTapGesture");
}

#pragma mark - 触摸双击

-(UITapGestureRecognizer *)doubleRecognizer {
    // 双击的 Recognizer
    UITapGestureRecognizer *doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    doubleRecognizer.numberOfTapsRequired = 2; // 双击
    
    [_imageView addGestureRecognizer:doubleRecognizer];
    
    // 关键在这一行，双击手势确定监测失败才会触发单击手势的相应操作
    [self.singleRecognizer requireGestureRecognizerToFail:doubleRecognizer];
    
    return doubleRecognizer;
}

//处理双击操作
-(void)handleDoubleTapGesture:(UIGestureRecognizer*)sender{
    NSLog(@"handleDoubleTapGesture");
}

#pragma mark - 上下左右滑动手势

-(void)swipeRecognizer {
    UISwipeGestureRecognizer *recognizerUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizerUp setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [[self view] addGestureRecognizer:recognizerUp];
    
    UISwipeGestureRecognizer *recognizerDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizerDown setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:recognizerDown];
    
    UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizerLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizerLeft];
    
    UISwipeGestureRecognizer *recognizerRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizerRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizerRight];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction==UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"swipe up");
    }
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"swipe down");
    }
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"swipe left");
    }
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"swipe right");
    }
}

@end
