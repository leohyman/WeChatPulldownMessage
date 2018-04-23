//
//  LZView.h
//  WeChatPulldownMessage
//
//  Created by vv-lvzhao on 2018/4/22.
//  Copyright © 2018年 lvzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define K_HeadViewHeight 44

///屏幕的宽
#define K_SCREENWIDTH [UIScreen mainScreen].bounds.size.width
///屏幕的高
#define K_SCREENHEIGHT  [UIScreen mainScreen].bounds.size.height
///导航栏的高度
#define K_NAVHEIGHT  ((K_SCREENHEIGHT == 812)? 88 : 64)
///tabbar的高度
#define K_BARHEIGHT  ((K_SCREENHEIGHT == 812) ? 83 : 49)

//判断设备是否是iPhoneX!!
#define K_Device_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)


@interface LZView : UIView

@end
