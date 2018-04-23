//
//  LZViewController.m
//  WeChatPulldownMessage
//
//  Created by vv-lvzhao on 2018/4/22.
//  Copyright © 2018年 lvzhao. All rights reserved.
//

#import "LZViewController.h"
#import "LZView.h"
#import "Masonry.h"
#import "LZTestView.h"

@interface LZViewController ()
@property (nonatomic,strong) LZView *lzView;    //主页视图
@property (nonatomic,strong) LZTestView *testView;    //主页视图

@end

@implementation LZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"微信下拉消息无动画";
    self.view.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:self.lzView];
    [self.lzView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        if (K_Device_Is_iPhoneX) {
            make.bottom.mas_equalTo(-34);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
}

#pragma mark - ljz
- (LZView *)lzView{
    if(!_lzView){
        _lzView = [[LZView alloc]init];
    }
    return _lzView;
}
- (LZTestView *)testView{
    if(!_testView){
        _testView = [[LZTestView alloc]init];
    }
    return _testView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
