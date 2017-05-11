//
//  HScrollView.h
//  志哉新闻
//
//  Created by Leo 廖 on 17/2/24.
//  Copyright © 2017年 Leo 廖. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HScrollView : UIScrollView
{
    //按钮集合
    NSMutableArray * buttons;
}
-(HScrollView *)init;
-(void)addButton:(UIButton *)button;
-(void)clearColor;
@end
