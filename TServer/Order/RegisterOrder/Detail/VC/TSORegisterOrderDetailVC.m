//
//  TSORegisterOrderDetailVC.m
//  TServer
//
//  Created by mark_zhang on 2018/10/13.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "TSORegisterOrderDetailVC.h"
#import "TSRegisterOrderDetailModel.h"
@interface TSORegisterOrderDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *order_signLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *addTimeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImav;
@property (weak, nonatomic) IBOutlet UILabel *orderStateLbl;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@end

@implementation TSORegisterOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    [self requestData];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - requestFunc

- (void)requestData {
    
    NSDateFormatter *dateFormatter = DateFormatter();
    NSString *timestamp = [dateFormatter stringFromDate:[NSDate date]];
    NSMutableDictionary *parInfoDic = [NSMutableDictionary dictionaryWithDictionary:@{@"timestamp":kUnNilStr(timestamp),@"api_key":kUnNilStr(TApi_key_Str),@"data":@{@"order_id":@(self.order_id)}}];
    NSDictionary *signDic = @{@"timestamp":kUnNilStr(timestamp),@"api_key":kUnNilStr(TApi_key_Str),@"order_id":@(self.order_id)};
    [TFailhub hidenALLFailhubWithSuperView:self.view];
    [TLodingHub setGifOnView:self.view withTitle:@"正在加载..."];
    
    [THTTPRequestTool postSignRequestDataWithUrl:@"api/jiedan/order/register_order_detail" par:parInfoDic signDicInfo:signDic finishBlock:^(TResponse *response) {
        [TLodingHub hideAllHUDsForView:self.view];
        if (response.code == TRequestSuccessCode && [response.data isKindOfClass:[NSDictionary class]]) {
            TSRegisterOrderDetailModel *model = [TSRegisterOrderDetailModel mj_objectWithKeyValues:response.data];
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

- (void)setupUIWithDetailModel:(TSRegisterOrderDetailModel *)detailModel {
    
    self.okBtn.hidden = detailModel.status == 3 || detailModel.status == 4;
    self.order_signLbl.text = detailModel.order_sn;
    self.priceLbl.text = detailModel.order_price;
    self.nickNameLbl.text = detailModel.nickname;
    self.addTimeLbl.text = detailModel.add_time;
    self.orderStateLbl.text = detailModel.status_text;
    if (detailModel.type == 1) {
        [self.QRCodeImav sd_setImageWithURL:[NSURL URLWithString:kUnNilStr(detailModel.photo_url)] placeholderImage:nil];
    } else {
        
       [self.QRCodeImav sd_setImageWithURL:[NSURL URLWithString:kUnNilStr(detailModel.qrcode_url)] placeholderImage:nil];
    }
}
#pragma mark - actionFunc

- (IBAction)actionOkBtn:(id)sender {
    
}

@end
