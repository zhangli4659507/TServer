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
#import <ZXingObjC/ZXingObjC.h>

@interface TSORegisterOrderDetailVC ()<UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *order_signLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *addTimeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImav;
@property (weak, nonatomic) IBOutlet UILabel *orderStateLbl;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UIButton *failBtn;
@property (nonatomic, copy) NSString *uploadImageUrl;
@property (weak, nonatomic) IBOutlet UIImageView *uploadImav;
@property (weak, nonatomic) IBOutlet UILabel *uploadImavTagLbl;
@property (weak, nonatomic) IBOutlet UILabel *compaintLbl;

@property (nonatomic, strong) TSRegisterOrderDetailModel *detailModel;

@end

@implementation TSORegisterOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    [self requestData];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)addRightBarItem {
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem  itemWithTitle:@"投诉" titleColor:[UIColor whiteColor] target:self action:@selector(actionComplain)];
}

#pragma mark - requestFunc

- (void)actionComplain {
    
     NSString *imavUrl = self.detailModel.type == 1?self.detailModel.photo_url:self.detailModel.qrcode_url;
    NSDateFormatter *dateFormatter = DateFormatter();
    NSString *timestamp = [dateFormatter stringFromDate:[NSDate date]];
    NSMutableDictionary *parInfoDic = [NSMutableDictionary dictionaryWithDictionary:@{@"timestamp":kUnNilStr(timestamp),@"api_key":kUnNilStr(TApi_key_Str),@"data":@{@"order_id":@(self.order_id),@"complain_img_url":kUnNilStr(imavUrl)}}];
    NSDictionary *signDic = @{@"timestamp":kUnNilStr(timestamp),@"api_key":kUnNilStr(TApi_key_Str),@"order_id":@(self.order_id),@"complain_img_url":kUnNilStr(imavUrl)};
    [MBProgressHUD showMessage:nil];
    [THTTPRequestTool postSignRequestDataWithUrl:@"api/jiedan/complain/register_order_complain" par:parInfoDic signDicInfo:signDic finishBlock:^(TResponse *response) {
        if (response.code == TRequestSuccessCode) {
            [MBProgressHUD showSuccess:@"投诉成功"];
            [self performSelector:@selector(navBackAction) withObject:nil afterDelay:1];
            !self.handleSuccessBlock?:self.handleSuccessBlock();
        } else {
            [MBProgressHUD showError:response.msg];
        }
    }];
}

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


- (void)requestSaveFail {
    NSDateFormatter *dateFormatter = DateFormatter();
    NSString *timestamp = [dateFormatter stringFromDate:[NSDate date]];
    NSMutableDictionary *parInfoDic = [NSMutableDictionary dictionaryWithDictionary:@{@"timestamp":kUnNilStr(timestamp),@"api_key":kUnNilStr(TApi_key_Str),@"data":@{@"order_id":@(self.order_id)}}];
    NSDictionary *signDic = @{@"timestamp":kUnNilStr(timestamp),@"api_key":kUnNilStr(TApi_key_Str),@"order_id":@(self.order_id)};
    
    [MBProgressHUD showMessage:@"正在处理..."];
    [THTTPRequestTool postSignRequestDataWithUrl:@"api/jiedan/order/register_order_fail" par:parInfoDic signDicInfo:signDic finishBlock:^(TResponse *response) {
        if (response.code == TRequestSuccessCode) {
            [MBProgressHUD showSuccess:@"操作成功"];
            [self performSelector:@selector(navBackAction) withObject:nil afterDelay:1];
            !self.handleSuccessBlock?:self.handleSuccessBlock();
        } else {
            [MBProgressHUD showError:kUnNilStr(response.msg)];
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
    
    
    self.navigationItem.rightBarButtonItem = nil;
    if (detailModel.status == 3 || detailModel.status == 6) {
        [self addRightBarItem];
    }
    self.compaintLbl.text = detailModel.is_complain_text;
    self.okBtn.hidden = detailModel.status != 2;
    self.failBtn.hidden = !(detailModel.status == 2 || detailModel.status == 6);
    self.uploadImav.hidden = self.uploadImavTagLbl.hidden = self.okBtn.hidden;
    self.order_signLbl.text = detailModel.order_sn;
    self.priceLbl.text = detailModel.order_price;
    self.nickNameLbl.text = detailModel.nickname;
    self.addTimeLbl.text = detailModel.add_time;
    self.orderStateLbl.text = detailModel.status_text;
    self.QRCodeImav.image = [self getCodeImage:detailModel.type == 1?detailModel.photo_url:detailModel.qrcode_url];
}

- (UIImage*)getCodeImage:(NSString*)order_sn{
    
    ZXEncodeHints *hints = [ZXEncodeHints hints];
    hints.encoding = NSUTF8StringEncoding;                                             // 设置编码类型
    hints.errorCorrectionLevel = [ZXQRCodeErrorCorrectionLevel errorCorrectionLevelH];       // 设置纠正级别，越高识别越快
    ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init]; ZXBitMatrix *result = [writer encode:kUnNilStr(order_sn)                              format:kBarcodeFormatQRCode                               width:160                              height:160                              hints:hints                               error:nil];
    ZXImage *resultImage = [ZXImage imageWithMatrix:result];
    if (resultImage) {
        return [UIImage imageWithCGImage:resultImage.cgimage];
    }
    return nil;
}

#pragma mark - actionFunc

- (IBAction)actionOkBtn:(id)sender {
//    if (self.uploadImageUrl.length == 0) {
//        [MBProgressHUD showError:@"请先上传截图"];
//        return;
//    }
    [self requestSaveOrder];
}

- (IBAction)actionFailBtn:(id)sender {
    [self requestSaveFail];
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
