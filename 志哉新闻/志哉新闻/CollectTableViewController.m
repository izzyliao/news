//
//  CollectTableViewController.m
//  志哉新闻
//
//  Created by Leo 廖 on 17/4/8.
//  Copyright © 2017年 Leo 廖. All rights reserved.
//

#import "CollectTableViewController.h"
#import "LeoNews.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "MJRefresh.h"

@interface CollectTableViewController ()

@end

@implementation CollectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"收藏夹";
    
    self.news=[[NSMutableArray alloc]initWithCapacity:100];
    //在导航栏的右边添加一个编辑按钮
    UIBarButtonItem *rightButton=[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:
                                 UIBarButtonItemStylePlain target:self action:@selector(editTap:)];
    self.navigationItem.rightBarButtonItem=rightButton;
    [self loadLocalData];
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(rsfreshTap)];
    //上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadTap)];
}


-(void)editTap:(id)sender
{
    NSLog(@"danjibianji");
    if (self.tableView.isEditing) {
        [self.navigationController setToolbarHidden:NO animated:YES];
        [self.tableView setEditing:NO animated:YES];
    }else{
        [self.navigationController setToolbarHidden:YES animated:YES];
        [self.tableView setEditing:YES animated:YES];
    }
}

-(void)rsfreshTap
{
    [self loadLocalData];
    [self.tableView.mj_header endRefreshing];
}
-(void)loadTap
{
    [self loadLocalData];
    [self.tableView.mj_footer endRefreshing];
}
-(void)loadLocalData
{
    //清空集合
    [self.news removeAllObjects];
    NSLog(@"从本地获取数据");
    //获得数据库对象
    AppDelegate *app=(AppDelegate *)[UIApplication
                                     sharedApplication].delegate;
    FMDatabase *db=app.db;
    FMResultSet *rs=[db executeQuery:@"select * from saves"];
    while ([rs next]) {
        LeoNews * news =[[LeoNews alloc]init];
        news.title=[rs stringForColumn:@"title"];
        news.subtitle=[rs stringForColumn:@"subtitle"];
        news.idid=[NSNumber numberWithInt:[rs
                                           intForColumn:@"idid" ]];
        news.picture=[rs stringForColumn:@"picture"];
        news.content=[rs stringForColumn:@"content"];
        news.author=[rs stringForColumn:@"author"];
        news.time=[rs stringForColumn:@"time"];
        news.flid=[NSNumber numberWithInt:[rs
                                           intForColumn:@"flid"]];
        news.clicks=[NSNumber numberWithInt:[rs
                                             intForColumn:@"clicks" ]];
        NSData *data=[rs dataNoCopyForColumn:@"pic"];
        news.img=[UIImage imageWithData:data];
        [self.news addObject:news];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.news.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(cell==nil) {
        //表格的样式是子标题的样式
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    LeoNews * news=self.news[indexPath.row];
    //标题
    cell.textLabel.text=news.title;
    //子标题
    cell.detailTextLabel.text=news.subtitle;
    //显示图片
    cell.imageView.image=news.img;
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.tableView.isEditing) {
       
    }
    else{
    DetailViewController *detail=[[DetailViewController alloc]initWithNibName:nil bundle:nil];
    detail.news=self.news[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
    }
}

//提交表格编辑的样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.editing) {
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }
    else{
        return UITableViewCellEditingStyleDelete;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeoNews *xinwen=self.news[indexPath.row];
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        //移出数组中
        [self.news removeObjectAtIndex:indexPath.row];
        //获得数据库,在数据库中删除
        AppDelegate *app=[UIApplication sharedApplication].delegate;
        FMDatabase *db=app.db;
        NSString *sql=[NSString stringWithFormat:@"delete from saves where idid=%@",xinwen.idid];
        NSLog(@"%@",sql);
        FMResultSet *rs=[db executeQuery:sql];
        [rs next];
        //移除表格中的
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }

}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

@end
