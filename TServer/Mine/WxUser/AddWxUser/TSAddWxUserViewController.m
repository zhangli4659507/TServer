//
//  TSAddWxUserViewController.m
//  TServer
//
//  Created by mark_zhang on 2018/10/14.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "TSAddWxUserViewController.h"

@interface TSAddWxUserViewController ()
@property (weak, nonatomic) IBOutlet UITextField *wxTxt;
@property (weak, nonatomic) IBOutlet UITextField *phoneTxt;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@end

@implementation TSAddWxUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定微信号";
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)actionOkBtn:(id)sender {
    
    if (self.wxTxt.text.length == 0) {
        [MBProgressHUD showError:@"请输入微信号"];
        return;
    } else if (self.phoneTxt.text.length == 0) {
        
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    NSDateFormatter *dateFormatter = DateFormatter();
    NSString *timestamp = [dateFormatter stringFromDate:[NSDate date]];
    NSMutableDictionary *parInfoDic = [NSMutableDictionary dictionaryWithDictionary:@{@"timestamp":kUnNilStr(timestamp),@"api_key":kUnNilStr(TApi_key_Str),@"data":@{@"jd_phone":self.phoneTxt.text,@"jd_wx_sn":self.wxTxt.text}}];
    NSDictionary *signDic = @{@"timestamp":kUnNilStr(timestamp),@"api_key":kUnNilStr(TApi_key_Str),@"jd_phone":self.phoneTxt.text,@"jd_wx_sn":self.wxTxt.text};
    [MBProgressHUD showMessage:@"正在添加..."];
    [THTTPRequestTool postSignRequestDataWithUrl:@"api/jiedan/weixin/add_wx" par:parInfoDic signDicInfo:signDic finishBlock:^(TResponse *response) {
        if (response.code == TRequestSuccessCode) {
            [MBProgressHUD showSuccess:@"添加成功"];
           [self performSelector:@selector(navBackAction) withObject:nil afterDelay:1];
            (!self.addWxSuccessBlock)?:self.addWxSuccessBlock();
        } else {
            [MBProgressHUD showError:kUnNilStr(response.msg)];
        }
    }];
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
