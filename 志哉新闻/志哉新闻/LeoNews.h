//
//  LeoNews.h
//  志哉新闻
//
//  Created by Leo 廖 on 17/3/2.
//  Copyright © 2017年 Leo 廖. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface LeoNews : NSObject
@property (strong,nonatomic) NSNumber * clicks;
@property (strong,nonatomic) NSString * picture;
@property (strong,nonatomic) NSString * content;
@property (strong,nonatomic) NSString * author;
@property (strong,nonatomic) NSNumber * idid;
@property (strong,nonatomic) NSNumber * flid;
@property (strong,nonatomic) NSString * time;
@property (strong,nonatomic) NSString * subtitle;
@property (strong,nonatomic) NSString * title;
@property (strong,nonatomic) UIImage * img;
@end
