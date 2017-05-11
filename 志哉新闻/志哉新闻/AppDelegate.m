//
//  AppDelegate.m
//  志哉新闻
//
//  Created by Leo 廖 on 17/2/22.
//  Copyright © 2017年 Leo 廖. All rights reserved.
//

#import "AppDelegate.h"

#import "OneTableViewController.h"
#import "RankinglistTableViewController.h"
#import "SearchViewController.h"
#import "CollectTableViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //打开数据库
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=paths[0];
    path=[path stringByAppendingPathComponent:@"news.db"];
    NSLog(@"---%@---",path);
    NSString *homeDir = NSHomeDirectory();
    //NSLog(@"h=%@",homeDir);
    self.db=[FMDatabase databaseWithPath:path];
    BOOL b=[self.db open];
    if (!b)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"打开数据库失败！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        //初始化UIWindows
        UIWindow *alertWindow = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        alertWindow.rootViewController = [[UIViewController alloc]init];
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        [alertWindow makeKeyAndVisible];
        [alertWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        return NO;
    }
    NSString *sql=@"create table if not exists news(idid integer,title text,subtitle text,picture text,content text,author text,flid integer,time text,clicks integer,pic blob)";
    b=[self.db executeUpdate:sql];
    if (!b) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"创建数据库失败！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        //初始化UIWindows
        UIWindow *alertWindow = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        alertWindow.rootViewController = [[UIViewController alloc]init];
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        [alertWindow makeKeyAndVisible];
        [alertWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        
        return NO;
    }
    
    //设置导航栏的背景颜色
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    //设置导航栏的前景颜色
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    // Override point for customization after application launch.
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    //标签栏控制器
    UITabBarController *tab=[[UITabBarController alloc]init];
    //创建基本视图
    OneTableViewController *one=[[OneTableViewController alloc]
                                 initWithStyle:UITableViewStylePlain];
    RankinglistTableViewController *rankinglist=[[RankinglistTableViewController alloc]init];
    SearchViewController *search=[[SearchViewController alloc]init];
    CollectTableViewController *collect=[[CollectTableViewController alloc]initWithStyle:UITableViewStylePlain];
    //创建导航视图
    UINavigationController *oneNav=[[UINavigationController alloc]initWithRootViewController:one];
    oneNav.tabBarItem.title=@"新闻";
    oneNav.tabBarItem.image=[UIImage imageNamed:@"tab_0.png"];
    UINavigationController *rankinglistNav=[[UINavigationController alloc]initWithRootViewController:rankinglist];
    rankinglistNav.tabBarItem.title=@"排行榜";
    rankinglistNav.tabBarItem.image=[UIImage imageNamed:@"tab_2.png"];
    UINavigationController *searchNav=[[UINavigationController alloc]initWithRootViewController:search];
    searchNav.tabBarItem.title=@"搜索";
    searchNav.tabBarItem.image=[UIImage imageNamed:@"tab_1.png"];
    UINavigationController *CollectNav=[[UINavigationController alloc]initWithRootViewController:collect];
    CollectNav.tabBarItem.title=@"收藏";
    CollectNav.tabBarItem.image=[UIImage imageNamed:@"tab_3.png"];
    tab.viewControllers=[[NSArray alloc]initWithObjects:oneNav,rankinglistNav,searchNav,CollectNav,nil];
    //设定标签栏视图为根视图
    self.window.rootViewController=tab;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
