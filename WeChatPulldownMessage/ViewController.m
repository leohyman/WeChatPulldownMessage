//
//  ViewController.m
//  WeChatPulldownMessage
//
//  Created by lvzhao on 2018/4/20.
//  Copyright © 2018年 lvzhao. All rights reserved.
//

#import "ViewController.h"
#import "LZViewController.h"


@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;

    self.title = @"点击跳转";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    LZViewController * LZVC = [[LZViewController alloc]init];
    [self.navigationController pushViewController:LZVC animated:YES];
    
}



@end
