//
//  TSRegisterOrderDetailViewController.m
//  TServer
//
//  Created by mark_zhang on 2018/10/14.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "TSRegisterOrderDetailViewController.h"
#import "TSUnlockOrderDetailModel.h"
#import "TUploadTool.h"
#import "TSWxListViewController.h"
@interface TSRegisterOrderDetailViewController ()<UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *orderIdLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *addTimeLbl;
@property (weak, nonatomic) IBOutlet UITextField *wxTxt;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@property (nonatomic, copy) NSString *uploadImageUrl;
@property (weak, nonatomic) IBOutlet UIImageView *uploadImav;
@property (nonatomic, strong) TSUnlockOrderDetailModel *detailModel;

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
            self.detailModel = model;
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
    NSDateFormatter *dateFormatter = DateFormatter();
    NSString *timestamp = [dateFormatter stringFromDate:[NSDate date]];
    NSMutableDictionary *parInfoDic = [NSMutableDictionary dictionaryWithDictionary:@{@"timestamp":kUnNilStr(timestamp),@"api_key":kUnNilStr(TApi_key_Str),@"data":@{@"order_id":@(self.order_id),@"jd_finish_img_url":kUnNilStr(self.uploadImageUrl)}}];
    NSDictionary *signDic = @{@"timestamp":kUnNilStr(timestamp),@"api_key":kUnNilStr(TApi_key_Str),@"order_id":@(self.order_id),@"jd_finish_img_url":kUnNilStr(self.uploadImageUrl)};
    
    [MBProgressHUD showMessage:@"正在处理..."];
    [THTTPRequestTool postSignRequestDataWithUrl:@"api/jiedan/order/register_order_finish" par:parInfoDic signDicInfo:signDic finishBlock:^(TResponse *response) {
        if (response.code == TRequestSuccessCode) {
            [MBProgressHUD showSuccess:@"操作成功"];
            [self performSelector:@selector(navBackAction) withObject:nil afterDelay:1];
            !self.handleSuccessBlock?:self.handleSuccessBlock();
        } else {
            [MBProgressHUD showError:kUnNilStr(response.msg)];
        }
    }];
    
    
}

- (void)requestBindWxWithWxUserInfoModel:(TSWxInfoListModel *)wxUserInfoModel {
    NSDateFormatter *dateFormatter = DateFormatter();
    NSString *timestamp = [dateFormatter stringFromDate:[NSDate date]];
    NSMutableDictionary *parInfoDic = [NSMutableDictionary dictionaryWithDictionary:@{@"timestamp":kUnNilStr(timestamp),@"api_key":kUnNilStr(TApi_key_Str),@"data":@{@"jiedan_id":@(self.order_id),@"jiedan_wx_id":@(wxUserInfoModel.jiedan_wx_id)}}];
    NSDictionary *signDic = @{@"timestamp":kUnNilStr(timestamp),@"api_key":kUnNilStr(TApi_key_Str),@"jiedan_id":@(self.order_id),@"jiedan_wx_id":@(wxUserInfoModel.jiedan_wx_id)};
    [MBProgressHUD showMessage:@"正在绑定..."];
    [THTTPRequestTool postSignRequestDataWithUrl:@"api/jiedan/order/unseal_order_bang_wx" par:parInfoDic signDicInfo:signDic finishBlock:^(TResponse *response) {
        if (response.code == TRequestSuccessCode) {
            [MBProgressHUD showSuccess:@"绑定成功"];
            [self requestData];
        } else {
            [MBProgressHUD showError:response.msg];
        }
    }];
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
    self.uploadImav.hidden = self.okBtn.hidden;
}

- (void)uploadImageWithIma:(UIImage *)image {
    
    [MBProgressHUD showMessage:@"正在上传...." toView:self.view];
    [TUploadTool uploadImge:image finishBlock:^(NSString *imageUrlString) {
        [MBProgressHUD hideHUDForView:self.view];
        self.uploadImageUrl = imageUrlString;
        self.uploadImav.image = image;
    }];
    
}

#pragma mark - actionFunc

- (IBAction)actionUploadImav:(id)sender {
    
    if (self.detailModel.status == 0) {
        [MBProgressHUD showError:@"请先绑定微信"];
        return;
    }
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (IBAction)actionBinWxBtn:(id)sender {
    TSWxListViewController *wvc = [[TSWxListViewController alloc] init];
    wvc.isSelectType = YES;
    WEAK_REF(self);
    [wvc setSelectItemBlock:^(TSWxInfoListModel * _Nonnull wxUserInfoModel) {
        [weak_self requestBindWxWithWxUserInfoModel:wxUserInfoModel];
    }];
    [self.navigationController pushViewController:wvc animated:YES];
}

- (IBAction)actionOkbtn:(id)sender {
    if (self.detailModel.status == 0) {
        [MBProgressHUD showError:@"请先绑定微信"];
        return;
    } else if (self.uploadImageUrl.length == 0) {
        [MBProgressHUD showError:@"请先上传截图"];
        return;
    }
    [self requestSaveOrder];
}

#pragma mark - imagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self uploadImageWithIma:image];
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
