//
//  UIButton+SetUp.h
//  CarModelHeadlines
//
//  Created by GK on 16/2/23.
//  Copyright © 2016年 北京智阅网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (SetUp)
+(UIButton *)buttonWithTitle:(NSString *)title target:(id)target action:(SEL)action;
+(UIButton *)buttonWithImage:(UIImage *)image target:(id)target action:(SEL)action;
+(UIButton *)createBtnWithFrame:(CGRect)frame Image:(NSString *)norImage HLImage:(NSString *)hlImage tagart:(id)tagart action:(SEL)selector;

@end
