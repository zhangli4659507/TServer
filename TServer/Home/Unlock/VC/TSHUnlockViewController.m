//
//  TSHUnlockViewController.m
//  TServer
//
//  Created by mark_zhang on 2018/10/13.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "TSHUnlockViewController.h"
#import "TSHUnLockSection.h"
#import "TOTableViewTool.h"
#import "TSHUnlockModel.h"
@interface TSHUnlockViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TOTableViewTool *tableViewTool;
@property (nonatomic, strong) TSHUnLockSection *section;
@property (nonatomic, assign) BOOL isRequest;
@property (nonatomic, assign) NSUInteger pgIndex;
@property (nonatomic, strong) NSMutableArray<TSHUnlockListModel *> *dataArr;
@end

@implementation TSHUnlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, CGFLOAT_MIN)];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, CGFLOAT_MIN)];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pushDownRefesh)];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(pushUpRefesh)];
    self.tableView.mj_footer.hidden = YES;
    [self.view addSubview:self.tableView];
    
}

#pragma mark - layoutSubview

- (void)layoutSubview {
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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
    [THTTPRequestTool postSignRequestDataWithUrl:@"api/jiedan/order/unseal_order_list" par:parInfoDic signDicInfo:signDic finishBlock:^(TResponse *response) {
        self.isRequest = NO;
        [TLodingHub hideAllHUDsForView:self.view];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (response.code == TRequestSuccessCode && [response.data isKindOfClass:[NSDictionary class]]) {
            TSHUnlockModel *listModel = [TSHUnlockModel mj_objectWithKeyValues:response.data];
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

- (void)requestOrderWithModel:(TSHUnlockListModel *)orderModel {
    
    NSDateFormatter *dateFormatter = DateFormatter();
    NSString *timestamp = [dateFormatter stringFromDate:[NSDate date]];
    NSMutableDictionary *parInfoDic = [NSMutableDictionary dictionaryWithDictionary:@{@"timestamp":kUnNilStr(timestamp),@"api_key":kUnNilStr(TApi_key_Str),@"data":@{@"order_id":@(orderModel.order_id)}}];
    NSDictionary *signDic = @{@"timestamp":kUnNilStr(timestamp),@"api_key":kUnNilStr(TApi_key_Str),@"order_id":@(orderModel.order_id)};
    [MBProgressHUD showMessage:@"正在处理...."];
    [THTTPRequestTool postSignRequestDataWithUrl:@"api/jiedan/order/unseal_order_do" par:parInfoDic signDicInfo:signDic finishBlock:^(TResponse *response) {
        if (response.code == TRequestSuccessCode) {
            [MBProgressHUD showSuccess:@"接单成功"];
            [self.tableView.mj_header beginRefreshing];
        } else {
            [MBProgressHUD showError:kUnNilStr(response.msg)];
        }
    }];
}

- (void)setupDataWithListModel:(TSHUnlockModel *)listModel {
    
    [self.dataArr addObjectsFromArray:listModel.list];
    self.tableView.mj_footer.hidden = listModel.page_index >= listModel.total_pages;
    self.tableViewTool.sectionArray = @[self.section];
    self.section.dataSource = self.dataArr;
    [self.tableView reloadData];
}


#pragma mark - getterFunc

- (TOTableViewTool *)tableViewTool {
    
    if (_tableViewTool == nil) {
        _tableViewTool = [[TOTableViewTool alloc] init];
    }
    return _tableViewTool;
}

- (TSHUnLockSection *)section {
    
    if (_section == nil) {
        _section = [[TSHUnLockSection alloc] init];
        [_section tableViewRegisterView:self.tableView];
        WEAK_REF(self);
        [_section setDidSelectedBlock:^(id  _Nonnull model) {
            [weak_self requestOrderWithModel:model];
        }];
    }
    return _section;
}

@end
