//
//  TSHomeViewController.m
//  TServer
//
//  Created by Mark on 2018/8/17.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "TSHomeViewController.h"
#import "WMPageController.h"
#import "TSHUnlockViewController.h"
#import "TSHRegisterViewController.h"
@interface TSHomeViewController ()<WMPageControllerDelegate,WMPageControllerDataSource>
@property (nonatomic, strong) WMPageController *pageController;
@end

@implementation TSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    [self setupSubview];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = nil;
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.pageController.view.frame = self.view.bounds;
    self.pageController.viewFrame = self.view.bounds;
}

#pragma mark -

- (void)setupSubview {
    
    _pageController = [[WMPageController alloc] init];
    _pageController.menuViewStyle = WMMenuViewStyleLine;
    _pageController.delegate = self;
    _pageController.dataSource = self;
    _pageController.titleSizeNormal = 14.f;
    _pageController.titleSizeSelected = 17.f;
//    _pageController.automaticallyCalculatesItemWidths = YES;
    _pageController.titleColorNormal = [UIColor colorWithHexString:@"#333"];
    _pageController.titleColorSelected = kThemeColor;
    _pageController.menuBGColor  = [UIColor whiteColor];
    _pageController.progressColor = kThemeColor;
    _pageController.menuHeight = 50.f;
    _pageController.menuItemWidth = kScreenWidth/2;
    _pageController.progressHeight = 3.f;
    [self addChildViewController:_pageController];
    [self.view addSubview:_pageController.view];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [_pageController.menuView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self->_pageController.menuView);
        make.height.offset(1.f);
    }];
    
}

#pragma mark - wmDatasource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    
    return 2;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    if (index == 0) {
        TSHRegisterViewController *qvc = [[TSHRegisterViewController alloc] init];
        return qvc;
    }
    TSHUnlockViewController *uvc = [[TSHUnlockViewController alloc] init];
    return uvc;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    
    return index == 0 ?@"辅助注册":@"微信解封";
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
