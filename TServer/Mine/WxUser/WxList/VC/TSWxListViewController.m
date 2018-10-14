//
//  TSWxListViewController.m
//  TServer
//
//  Created by mark_zhang on 2018/10/14.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "TSWxListViewController.h"
#import "TSWxInfoModel.h"
#import "TSWxListSection.h"
#import "TOTableViewTool.h"
#import "TSAddWxUserViewController.h"
#import "TSAddWxUserViewController.h"
@interface TSWxListViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TOTableViewTool *tableViewTool;
@property (nonatomic, strong) TSWxListSection *section;
@property (nonatomic, assign) BOOL isRequest;
@property (nonatomic, assign) NSUInteger pgIndex;
@property (nonatomic, strong) NSMutableArray<TSWxInfoListModel *> *dataArr;
@end

@implementation TSWxListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"微信列表";
    [self setupSubview];
    [self layoutSubview];
    [self.tableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}

#pragma mark - setupSubview
- (void) setupSubview {
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    self.tableView.delegate = self.tableViewTool;
    self.tableView.dataSource = self.tableViewTool;
    //    self.tableView.allowsSelection = NO;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, CGFLOAT_MIN)];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, CGFLOAT_MIN)];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pushDownRefesh)];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(pushUpRefesh)];
    self.tableView.mj_footer.hidden = YES;
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"添加" titleColor:[UIColor whiteColor] target:self action:@selector(actionAddWxUserInfo)];
    
    
}

#pragma mark - layoutSubview

- (void)layoutSubview {
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - actionFunc

- (void)actionAddWxUserInfo {
    if (self.isRequest) {
        return;
    }
    TSAddWxUserViewController *avc = [[TSAddWxUserViewController alloc] init];
    WEAK_REF(self);
    [avc setAddWxSuccessBlock:^{
        [weak_self.tableView.mj_header beginRefreshing];
    }];
    [self.navigationController pushViewController:avc animated:YES];
    
}

#pragma mark - setupData

- (void)pushDownRefesh {
    
    if(self.isRequest) return;
    self.pgIndex = 1;
    self.dataArr = @[].mutableCopy;
    [self requestData];
}

- (void)pushUpRefesh {
    
    if(self.isRequest) return;
    self.pgIndex ++;
    [self requestData];
}

- (void)requestData {
    NSDateFormatter *dateFormatter = DateFormatter();
    NSString *timestamp = [dateFormatter stringFromDate:[NSDate date]];
    NSMutableDictionary *parInfoDic = [NSMutableDictionary dictionaryWithDictionary:@{@"timestamp":kUnNilStr(timestamp),@"api_key":kUnNilStr(TApi_key_Str),@"data":@{@"page":@(self.pgIndex)}}];
    NSDictionary *signDic = @{@"timestamp":kUnNilStr(timestamp),@"api_key":kUnNilStr(TApi_key_Str),@"page":@(self.pgIndex)};
    [TFailhub hidenALLFailhubWithSuperView:self.view];
    if (self.pgIndex == 1) {
        [TLodingHub setGifOnView:self.view withTitle:@"正在加载..."];
    }
    [THTTPRequestTool postSignRequestDataWithUrl:@"api/jiedan/weixin/get_wx_sn_list" par:parInfoDic signDicInfo:signDic finishBlock:^(TResponse *response) {
        self.isRequest = NO;
        [TLodingHub hideAllHUDsForView:self.view];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (response.code == TRequestSuccessCode && [response.data isKindOfClass:[NSDictionary class]]) {
            TSWxInfoModel *listModel = [TSWxInfoModel mj_objectWithKeyValues:response.data];
            [self setupDataWithListModel:listModel];
        } else {
            [MBProgressHUD showError:response.msg];
            self.tableView.mj_footer.hidden = self.pgIndex == 1;
        }
        if (self.dataArr.count == 0) {
            WEAK_REF(self);
            [TFailhub showFailHubWithSuperView:self.view reloadBlock:^{
                [weak_self.tableView.mj_header beginRefreshing];
            }];
        }
    }];
}

- (void)setupDataWithListModel:(TSWxInfoModel *)listModel {
    
    [self.dataArr addObjectsFromArray:listModel.list];
    self.tableView.mj_footer.hidden = listModel.page_index >= listModel.total_pages;
    self.tableViewTool.sectionArray = @[self.section];
    self.section.dataSource = self.dataArr;
    [self.tableView reloadData];
}

#pragma mark - routerFunc

- (void)routerDetailVcWithModel:(TSWxInfoListModel *)orderModel {
    if (self.isSelectType && self.selectItemBlock) {
        [self navBackAction];
        self.selectItemBlock(orderModel);
    }
//    TSORegisterOrderDetailVC *dvc = [[TSORegisterOrderDetailVC alloc] init];
//    dvc.order_id = orderModel.order_id;
//    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark - getterFunc

- (TOTableViewTool *)tableViewTool {
    
    if (_tableViewTool == nil) {
        _tableViewTool = [[TOTableViewTool alloc] init];
    }
    return _tableViewTool;
}

- (TSWxListSection *)section {
    
    if (_section == nil) {
        _section = [[TSWxListSection alloc] init];
        [_section tableViewRegisterView:self.tableView];
        WEAK_REF(self);
        [_section setDidSelectedBlock:^(id  _Nonnull model) {
            [weak_self routerDetailVcWithModel:model];
        }];
    }
    return _section;
}

@end
