//
//  TSWithDrawRecordListVC.m
//  TServer
//
//  Created by mark_zhang on 2018/10/31.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "TSWithDrawRecordListVC.h"
#import "TOTableViewTool.h"
#import "TSDrawRecordSection.h"
#import "TSWithDrawModel.h"
@interface TSWithDrawRecordListVC ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isRequest;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSUInteger pgIndex;
@property (nonatomic, strong) TOTableViewTool *tableViewTool;
@property (nonatomic, strong) TSDrawRecordSection *section;
@end

@implementation TSWithDrawRecordListVC

- (void)viewDidLoad {
    
    self.title = @"提现记录";
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
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 45.f;
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
    self.dataArray = @[].mutableCopy;
    [self requestData];
}

- (void)pushUpRefesh {
    
    if(self.isRequest) return;
    self.pgIndex ++;
    [self requestData];
}

#pragma mark - requestFunc

- (void)requestData {
    NSDateFormatter *dateFormatter = DateFormatter();
    NSString *timestamp = [dateFormatter stringFromDate:[NSDate date]];
    NSMutableDictionary *parInfoDic = [NSMutableDictionary dictionaryWithDictionary:@{@"timestamp":kUnNilStr(timestamp),@"api_key":kUnNilStr(TApi_key_Str),@"data":@{@"page":@(self.pgIndex)}}];
    NSDictionary *signDic = @{@"timestamp":kUnNilStr(timestamp),@"api_key":kUnNilStr(TApi_key_Str),@"page":@(self.pgIndex)};
    [TFailhub hidenALLFailhubWithSuperView:self.view];
    if (self.pgIndex == 1) {
        [TLodingHub setGifOnView:self.view withTitle:@"正在加载..."];
    }
    [THTTPRequestTool postSignRequestDataWithUrl:@"api/jiedan/withdraw/withdraw_list" par:parInfoDic signDicInfo:signDic finishBlock:^(TResponse *response) {
        self.isRequest = NO;
        [TLodingHub hideAllHUDsForView:self.view];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (response.code == TRequestSuccessCode && [response.data isKindOfClass:[NSDictionary class]]) {
            TSWithDrawModel *listModel = [TSWithDrawModel mj_objectWithKeyValues:response.data];
            [self setupDataWithListModel:listModel];
        } else {
            [MBProgressHUD showError:response.msg];
            self.tableView.mj_footer.hidden = self.pgIndex == 1;
        }
        if (self.dataArray.count == 0) {
            WEAK_REF(self);
            [TFailhub showFailHubWithSuperView:self.view reloadBlock:^{
                [weak_self.tableView.mj_header beginRefreshing];
            }];
        }
    }];
}

- (void)setupDataWithListModel:(TSWithDrawModel *)listModel {
    
    [self.dataArray addObjectsFromArray:listModel.list];
    self.tableView.mj_footer.hidden = listModel.page_index >= listModel.total_pages;
    self.tableViewTool.sectionArray = @[self.section];
    self.section.dataSource = self.dataArray;
    [self.tableView reloadData];
}




#pragma mark - getter

- (TOTableViewTool *)tableViewTool {
    
    if (_tableViewTool == nil) {
        _tableViewTool = [[TOTableViewTool alloc] init];
    }
    return _tableViewTool;
}

- (TSDrawRecordSection *)section {
    
    if (_section == nil) {
        _section = [[TSDrawRecordSection alloc] init];
        [_section tableViewRegisterView:self.tableView];
    }
    return _section;
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
