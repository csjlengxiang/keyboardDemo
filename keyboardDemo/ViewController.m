//
//  ViewController.m
//  keyboardDemo
//
//  Created by sijiechen3 on 16/9/30.
//  Copyright © 2016年 sijiechen3. All rights reserved.
//

#import "ViewController.h"
#import "SPNumbersKeyboardView.h"
#import "Masonry.h"

@interface ViewController ()

@property (strong, nonatomic) SPNumbersKeyboardView * keyboard;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.keyboard = [[SPNumbersKeyboardView alloc] init];
    
    [self.view addSubview:self.keyboard];
    
    [self.keyboard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(0.4);
    }];
    
    [self.keyboard.errorSig subscribeNext:^(id x) {
        NSLog(@"---- %@", x);
    }];
    
    
    UILabel * lb = [UILabel new];
    
    lb.adjustsFontSizeToFitWidth = YES;
    
    lb.text = @"输入描述";
    lb.textAlignment = NSTextAlignmentRight;
    
    lb.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:lb];
    
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-100);
        make.width.mas_equalTo(100);
    }];
    
    RAC(lb, text) = self.keyboard.desSig;
    
    UILabel * lb1 = [UILabel new];
    
    lb1.adjustsFontSizeToFitWidth = YES;
    
    lb1.text = @"错误信息";
    lb1.textAlignment = NSTextAlignmentCenter;
    
    lb1.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:lb1];
    
    [lb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-130);
        make.width.mas_equalTo(100);
    }];
    
    RAC(lb1, text) = self.keyboard.errorSig;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
