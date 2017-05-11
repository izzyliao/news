//
//  HScrollView.m
//  志哉新闻
//
//  Created by Leo 廖 on 17/2/24.
//  Copyright © 2017年 Leo 廖. All rights reserved.
//

#import "HScrollView.h"

@implementation HScrollView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        ///<statements#>
    }
    return self;
}
-(HScrollView *)init
{
    self=[super init];
    if (self) {
        //实例化集合
        buttons=[[NSMutableArray alloc]initWithCapacity:10];
        //背景颜色
        self.backgroundColor=[UIColor whiteColor];
        //允许滚动
        self.scrollEnabled=YES;
        //取消滚动指示器
        self.showsHorizontalScrollIndicator=NO;
        self.showsVerticalScrollIndicator=NO;
    }
    return self;
}
//往滚动视图上放按钮
-(void)addButton:(UIButton *)button
{
    //滚动宽度
    NSInteger width=10;//10指的是按钮之间的距离
    //得到最后那个按钮
    UIButton * lastButton=[buttons lastObject];
    //计算宽度
    if (lastButton) {
        width+=lastButton.frame.origin.x+lastButton.frame.size.width;
    }
    else
    {
        width=0;
    }
    //得到要放到滚动视图上按钮的frame
    CGRect frame=button.frame;
    //设定按钮离滚动视图左边的距离
    frame.origin.x=width;
    //设定按钮离滚动视图上边的距离
    frame.origin.y=2;
    button.frame=frame;
    button.titleLabel.font=[UIFont systemFontOfSize:20];
    //把按钮放到滚动视图上
    [self addSubview:button];
    //在集合中保存这个按钮
    [buttons addObject:button];
    //调节滚动范围
    if (width>self.frame.size.width) {
        self.contentSize=CGSizeMake(width+button.frame.size.width
                                    ,44);
    }
}
-(void)clearColor
{
    for (UIButton *btn in buttons) {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.backgroundColor=[UIColor clearColor];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
