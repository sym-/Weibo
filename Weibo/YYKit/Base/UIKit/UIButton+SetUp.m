//
//  UIButton+SetUp.m
//  CarModelHeadlines
//
//  Created by GK on 16/2/23.
//  Copyright © 2016年 北京智阅网络科技有限公司. All rights reserved.
//

#import "UIButton+SetUp.h"

@implementation UIButton (SetUp)
+(UIButton *)buttonWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
+(UIButton *)buttonWithImage:(UIImage *)image target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
+(UIButton *)createBtnWithFrame:(CGRect)frame Image:(NSString *)norImage HLImage:(NSString *)hlImage tagart:(id)tagart action:(SEL)selector
{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    if (norImage) {
        [btn setImage:[UIImage imageNamed:norImage] forState:UIControlStateNormal];
    }
    if (hlImage) {
        [btn setImage:[UIImage imageNamed:hlImage] forState:UIControlStateHighlighted];
    }
    [btn addTarget:tagart action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
@end
