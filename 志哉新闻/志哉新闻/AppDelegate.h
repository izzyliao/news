//
//  AppDelegate.h
//  志哉新闻
//
//  Created by Leo 廖 on 17/2/22.
//  Copyright © 2017年 Leo 廖. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "MJRefresh.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) FMDatabase * db;
@end

