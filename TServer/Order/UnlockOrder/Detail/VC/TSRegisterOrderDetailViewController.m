//
//  TSRegisterOrderDetailViewController.m
//  TServer
//
//  Created by mark_zhang on 2018/10/14.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "TSRegisterOrderDetailViewController.h"
#import "TSUnlockOrderDetailModel.h"
@interface TSRegisterOrderDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *orderIdLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *addTimeLbl;
@property (weak, nonatomic) IBOutlet UITextField *wxTxt;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@end

@implementation TSRegisterOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    [self requestData];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -  requestData
- (void)requestData {
    
    NSDateFormatter *dateFormatter = DateFormatter();
    NSString *timestamp = [dateFormatter stringFromDate:[NSDate date]];
    NSMutableDictionary *parInfoDic = [NSMutableDictionary dictionaryWithDictionary:@{@"timestamp":kUnNilStr(timestamp),@"api_key":kUnNilStr(TApi_key_Str),@"data":@{@"order_id":@(self.order_id)}}];
    NSDictionary *signDic = @{@"timestamp":kUnNilStr(timestamp),@"api_key":kUnNilStr(TApi_key_Str),@"order_id":@(self.order_id)};
    [TFailhub hidenALLFailhubWithSuperView:self.view];
    [TLodingHub setGifOnView:self.view withTitle:@"正在加载..."];
    
    [THTTPRequestTool postSignRequestDataWithUrl:@"api/jiedan/order/unseal_order_detail" par:parInfoDic signDicInfo:signDic finishBlock:^(TResponse *response) {
        [TLodingHub hideAllHUDsForView:self.view];
        if (response.code == TRequestSuccessCode && [response.data isKindOfClass:[NSDictionary class]]) {
            TSUnlockOrderDetailModel *model = [TSUnlockOrderDetailModel mj_objectWithKeyValues:response.data];
            [self setupUIWithDetailModel:model];
        } else {
            [MBProgressHUD showError:response.msg];
            WEAK_REF(self);
            [TFailhub showFailHubWithSuperView:self.view reloadBlock:^{
                [weak_self requestData];
            }];
        }
    }];
}

- (void)requestSaveOrder {
    
    }

- (void)setupUIWithDetailModel:(TSUnlockOrderDetailModel *)detailModel {
    self.orderIdLbl.text = detailModel.order_sn;
    self.nickNameLbl.text = detailModel.nickname;
    self.addTimeLbl.text = detailModel.add_time;
    self.priceLbl.text = detailModel.order_price;
    if (detailModel.status == 0) {
        self.wxTxt.placeholder = @"请输入微信号";
    } else {
        self.bindBtn.hidden = YES;
        self.wxTxt.userInteractionEnabled = NO;
        self.wxTxt.text = @"已绑定";
        self.wxTxt.textColor = [UIColor colorWithHexString:@"#e13b29"];
    }
    
    self.okBtn.hidden = detailModel.status== 2 || detailModel.status== 3 || detailModel.status== 4 ;
}
#pragma mark - actionFunc

- (IBAction)actionUploadImav:(id)sender {
    
}

- (IBAction)actionBinWxBtn:(id)sender {
    
}

- (IBAction)actionOkbtn:(id)sender {
    
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
