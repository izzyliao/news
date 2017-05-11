//
//  DetailViewController.h
//  志哉新闻
//
//  Created by Leo 廖 on 17/4/8.
//  Copyright © 2017年 Leo 廖. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeoNews.h"
@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *titleView;

@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *clicksLabel;
@property (weak, nonatomic) IBOutlet LeoNews * news;

@end
