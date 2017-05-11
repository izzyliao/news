//
//  RankinglistTableViewController.m
//  志哉新闻
//
//  Created by Leo 廖 on 17/4/8.
//  Copyright © 2017年 Leo 廖. All rights reserved.
//

#import "RankinglistTableViewController.h"
#import "LeoNews.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "DetailViewController.h"
@interface RankinglistTableViewController ()

@end

@implementation RankinglistTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"排行榜";
    Reachability * reach=[Reachability reachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus status=[reach currentReachabilityStatus];
    self.news=[[NSMutableArray alloc]initWithCapacity:100];
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(rsfreshTap)];
    [SVProgressHUD showWithStatus:@"waiting" maskType:SVProgressHUDMaskTypeBlack];
    if (status==NotReachable) {//如果没有网络
        
        [self loadLocalData];//加载本地数据
    }
    else//有网络
    {
        [self loadData];//加载远端数据
    }
    
    [SVProgressHUD dismiss];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)rsfreshTap
{
    [self loadData];
    [self.tableView.mj_header endRefreshing];
}
-(void)loadData
{
    //清空集合
    [self.news removeAllObjects];
    
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    FMDatabase *db=app.db;
    [db executeUpdate:@"delete from orders"];
    //NSURL对象
    NSURL *url=[NSURL URLWithString:@"http://www.zhejiangren.club/getorders.php"];
    //转换成URL请求对象
    NSURLRequest * request=[[NSURLRequest alloc]initWithURL:url];
    
    NSData * data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if (data!=nil) {
        //对数据进行json解析
        NSArray *news=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        if (news==nil) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"新闻加载失败" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        if ([news count]>0)
        {
            for(NSDictionary * dict in news)
            {
                NSArray * keys=[dict allKeys];
                LeoNews * xinwen=[[LeoNews alloc]init];
                
                for (NSString *str in keys)
                {
                    //对对象的属性一一赋值 kvc
                    [xinwen setValue:[dict objectForKey:str] forKey:str];
                }
                NSString *imgName=[NSString stringWithFormat:@"http://www.zhejiangren.club/images/%@",xinwen.picture];
                NSURL *url=[NSURL URLWithString:imgName];
                NSURLRequest * request=[NSURLRequest requestWithURL:url];
                NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                xinwen.img=[UIImage imageWithData:data];
                [self.news addObject:xinwen];
                
                BOOL b=[db executeUpdate:@"insert into orders(idid,title,subtitle,picture,content,author,flid,time,clicks,pic)values(?,?,?,?,?,?,?,?,?,?)",xinwen.idid,xinwen.title,xinwen.subtitle,xinwen.picture,xinwen.content,xinwen.author,xinwen.flid,xinwen.time,xinwen.clicks,data];
                if (!b) {
                    NSLog(@"insert into error");
                }
            }

        }
        [self.tableView reloadData];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"新闻加载失败" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
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
    FMResultSet *rs=[db executeQuery:@"select * from orders"];
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
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detail=[[DetailViewController alloc]initWithNibName:nil bundle:nil];
    detail.news=self.news[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}

@end
