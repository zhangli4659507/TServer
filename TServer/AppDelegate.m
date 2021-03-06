//
//  AppDelegate.m
//  TServer
//
//  Created by Mark on 2018/8/16.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "AppDelegate.h"
#import "TSHomeViewController.h"
#import "TSOrderViewController.h"
#import "TSEarningViewController.h"
#import "TSMineViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "TCLoginViewController.h"
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.clipsToBounds =YES;
    
    IQKeyboardManager *manger =  [IQKeyboardManager sharedManager];
    [manger setEnable:YES];
    manger.shouldResignOnTouchOutside = YES;
    manger.toolbarPreviousBarButtonItemImage = kImaWithImaName(@"icon_arrow_left");
    manger.toolbarNextBarButtonItemImage = kImaWithImaName(@"icon_arrow_right");
    [manger setEnableAutoToolbar:YES];
    [self initTabbarVc];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRootVc) name:TLogin_success_notiName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRootVc) name:TLogin_Out_NotiName object:nil];
    [self changeRootVc];
    //启动基本SDK
    [[PgyManager sharedPgyManager] startManagerWithAppId:@"f38a8fb7ccf47bb8e45da77556d65dfa"];
    //启动更新检查SDK
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"f38a8fb7ccf47bb8e45da77556d65dfa"];
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
    // Override point for customization after application launch.
    return YES;
}

- (void)changeRootVc {
    
    if ([TCUserManger shareUserManger].loginState) {
        self.window.rootViewController = self.tabBarVc;
    } else {
        TCLoginViewController *loginVc = [[TCLoginViewController alloc] init];
        TNavViewController *nav = [[TNavViewController alloc] initWithRootViewController:loginVc];
        self.window.rootViewController = nav;
    }
}

- (void)initTabbarVc {
    TTabbarConfig *home = [[TTabbarConfig alloc] initWithTitle:@"首页" imaName:@"tab_icon_home_normal" imaSelectName:@"tab_icon_home_selected" vc:[[TNavViewController alloc] initWithRootViewController:[[TSHomeViewController alloc] init]]];
    TTabbarConfig *order = [[TTabbarConfig alloc] initWithTitle:@"订单" imaName:@"tab_icon_tk_normal" imaSelectName:@"tab_icon_tk_selected" vc:[[TNavViewController alloc] initWithRootViewController:[[TSOrderViewController alloc] init]]];
//    TTabbarConfig *earning = [[TTabbarConfig alloc] initWithTitle:@"收益" imaName:@"tab_icon_mycourse_normal" imaSelectName:@"tab_icon_mycourse_selected" vc:[[TNavViewController alloc] initWithRootViewController:[[TSEarningViewController alloc] init]]];
    TTabbarConfig *mine = [[TTabbarConfig alloc] initWithTitle:@"我的" imaName:@"tab_icon_grzx_normal" imaSelectName:@"tab_icon_grzx_selected" vc:[[TNavViewController alloc] initWithRootViewController:[[TSMineViewController alloc] init]]];
    
    self.tabBarVc = [[TTabBarViewController alloc] initWithConfigArr:@[home,order,mine]];
    self.window.rootViewController = self.tabBarVc;
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
