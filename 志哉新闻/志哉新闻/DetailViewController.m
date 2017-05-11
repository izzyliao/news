//
//  DetailViewController.m
//  志哉新闻
//
//  Created by Leo 廖 on 17/4/8.
//  Copyright © 2017年 Leo 廖. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"
@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"新闻详情";
    UIBarButtonItem *rightButton=[[UIBarButtonItem alloc]initWithTitle:@"收藏" style:
                                  UIBarButtonItemStylePlain target:self action:@selector(saveTap:)];
    self.navigationItem.rightBarButtonItem=rightButton;
}

-(void)saveTap:(id)sender
{
    //获得数据库
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    FMDatabase *db=app.db;
    //判断是否已经收藏
    NSString *sql=[NSString stringWithFormat:@"select count(*) as rows from saves where idid=%@",self.news.idid];
    FMResultSet *rs=[db executeQuery:sql];
    [rs next];
    int rscount=[rs intForColumn:@"rows"];
    if(rscount>0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"新闻已经收藏" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    sql=[NSString stringWithFormat:@"select pic from news where idid=%@",self.news.idid];
    rs=[db executeQuery:sql];
    [rs next];
    NSData *data=[rs dataForColumn:@"pic"];
    BOOL b=[db executeUpdate:@"insert into saves(idid,title,subtitle,picture,content,author,flid,time,clicks,pic)values(?,?,?,?,?,?,?,?,?,?)",self.news.idid,self.news.title,self.news.subtitle,self.news.picture,self.news.content,self.news.author,self.news.flid,self.news.time,self.news.clicks,data];
    if (!b)
    {
        NSLog(@"insert into error");
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"收藏成功" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];

}
-(void)viewDidAppear:(BOOL)animated
{
   
    self.titleView.text=self.news.title;
    self.authorLabel.text=self.news.author;
    self.clicksLabel.text=[NSString stringWithFormat:@"%@",self.news.clicks]; ;
    self.contentView.text=self.news.content;
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
