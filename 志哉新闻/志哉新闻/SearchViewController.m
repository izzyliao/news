//
//  SearchViewController.m
//  志哉新闻
//
//  Created by Leo 廖 on 17/4/8.
//  Copyright © 2017年 Leo 廖. All rights reserved.
//

#import "SearchViewController.h"
#import "LeoNews.h"
#import "SVProgressHUD.h"
#import "Reachability.h"
#import "DetailViewController.h"
#import "MJRefresh.h"
@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"搜索页";
    self.news=[[NSMutableArray alloc]initWithCapacity:100];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.news.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)searchTap:(UIButton *)sender
{
    [self.news removeAllObjects];
    NSString *str=self.searchText.text;
    str=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (str.length==0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"搜索内容不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        self.searchText.text=@"";
        [self.searchText becomeFirstResponder];
        return;
    }
    Reachability * reach=[Reachability reachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus status=[reach currentReachabilityStatus];
    if (status==NotReachable)
    {
        //如果没有网络
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"请检查网络连接" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else//有网络
    {

        //NSURL对象
        
        //NSURL遇到中文时要注意UTF8编码
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://www.zhejiangren.club/getsearchs.php?title=%@",[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        
        //NSLog(@"-%@",url);
        //转换成URL请求对象
        NSURLRequest * request=[[NSURLRequest alloc]initWithURL:url];
        NSLog(@"--%@",request);
        NSData * data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
       //NSLog(@"%@",data);
        if (data!=nil)
        {
            //对数据进行json解析
            NSArray *news=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            if (news==nil)
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"未搜索到您需要的内容，请重新搜索" preferredStyle:UIAlertControllerStyleAlert];
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
        
               }
        
             }

       }
   }
  [self.tableView reloadData];
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detail=[[DetailViewController alloc]initWithNibName:nil bundle:nil];
    detail.news=self.news[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}

- (IBAction)closekey:(id)sender {
}
@end
