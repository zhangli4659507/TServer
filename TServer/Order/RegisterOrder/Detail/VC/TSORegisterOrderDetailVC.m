//
//  TSORegisterOrderDetailVC.m
//  TServer
//
//  Created by mark_zhang on 2018/10/13.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "TSORegisterOrderDetailVC.h"
#import "TSRegisterOrderDetailModel.h"
#import "TUploadTool.h"
@interface TSORegisterOrderDetailVC ()<UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *order_signLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *addTimeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImav;
@property (weak, nonatomic) IBOutlet UILabel *orderStateLbl;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (nonatomic, copy) NSString *uploadImageUrl;
@property (weak, nonatomic) IBOutlet UIImageView *uploadImav;
@property (weak, nonatomic) IBOutlet UILabel *uploadImavTagLbl;

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

- (void)uploadImageWithIma:(UIImage *)image {
    
    [MBProgressHUD showMessage:@"正在上传...." toView:self.view];
    [TUploadTool uploadImge:image finishBlock:^(NSString *imageUrlString) {
        [MBProgressHUD hideHUDForView:self.view];
        self.uploadImageUrl = imageUrlString;
        self.uploadImav.image = image;
    }];
    
}

- (void)setupUIWithDetailModel:(TSRegisterOrderDetailModel *)detailModel {
    
    self.okBtn.hidden = detailModel.status == 3 || detailModel.status == 4;
    self.uploadImav.hidden = self.uploadImavTagLbl.hidden = self.okBtn.hidden;
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
    if (self.uploadImageUrl.length == 0) {
        [MBProgressHUD showError:@"请先上传截图"];
        return;
    }
    [self requestSaveOrder];
}

- (IBAction)actionUpload:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}




#pragma mark - imagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self uploadImageWithIma:image];
}


@end
