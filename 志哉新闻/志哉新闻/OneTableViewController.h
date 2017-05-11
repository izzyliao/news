//
//  OneTableViewController.h
//  志哉新闻
//
//  Created by Leo 廖 on 17/3/2.
//  Copyright © 2017年 Leo 廖. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OneTableViewController : UITableViewController
//保存当前分类的所有新闻
@property (strong,nonatomic)NSMutableArray * news;

@end
