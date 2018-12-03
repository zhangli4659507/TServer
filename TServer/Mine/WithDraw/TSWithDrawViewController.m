//
//  TSWithDrawViewController.m
//  TServer
//
//  Created by mark_zhang on 2018/10/17.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "TSWithDrawViewController.h"
#import "TSWithDrawRecordListVC.h"
@interface TSWithDrawViewController ()
@property (weak, nonatomic) IBOutlet UILabel *moneyLbl;
@property (weak, nonatomic) IBOutlet UITextField *moneyTxt;
@property (weak, nonatomic) IBOutlet UILabel *alipayUserNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@end

@implementation TSWithDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"余额提现";
    self.alipayUserNameLbl.text = kUnNilStr([TCUserManger shareUserManger].userModel.alipay);
    self.moneyLbl.text = [NSString stringWithFormat:@"可提现：%.2lf元",[TCUserManger shareUserManger].userModel.max_withdraw_money];
    [T2TView setRoundCornerFor:self.okBtn radiu:20.f];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)actionWithDraw:(id)sender {
    if (self.moneyTxt.text.length == 0) {
        [MBProgressHUD showError:@"请输入提现金额~"];
        return;
    } else if ([TCUserManger shareUserManger].userModel.max_withdraw_money < [self.moneyTxt.text floatValue]) {
        [MBProgressHUD showError:@"提现金额不能大于最大提现额度哦~"];
        return;
    }
    
    NSDateFormatter *dateFormatter = DateFormatter();
    NSString *timestamp = [dateFormatter stringFromDate:[NSDate date]];
    NSMutableDictionary *parInfoDic = [NSMutableDictionary dictionaryWithDictionary:@{@"timestamp":kUnNilStr(timestamp),@"api_key":kUnNilStr(TApi_key_Str),@"data":@{@"money":@([self.moneyTxt.text floatValue])}}];
    NSDictionary *signDic = @{@"timestamp":kUnNilStr(timestamp),@"api_key":kUnNilStr(TApi_key_Str),@"money":@([self.moneyTxt.text floatValue])};
    [MBProgressHUD showMessage:@"正在处理"];
    [THTTPRequestTool postSignRequestDataWithUrl:@"api/jiedan/withdraw/withdraw" par:parInfoDic signDicInfo:signDic finishBlock:^(TResponse *response) {
        if (response.code == TRequestSuccessCode && [response.data isKindOfClass:[NSDictionary class]]) {
            [MBProgressHUD showSuccess:@"申请成功"];
            CGFloat money = [response.data[@"jiedan_money"] floatValue];
            [TCUserManger shareUserManger].userModel.jiedan_money = [NSString stringWithFormat:@"%lf",money];
            [TCUserManger shareUserManger].userModel.max_withdraw_money -= self.moneyTxt.text.floatValue;
            [[NSNotificationCenter defaultCenter] postNotificationName:TMoney_change_notiName object:nil];
           self.moneyLbl.text = [NSString stringWithFormat:@"余额：%.2lf元", [TCUserManger shareUserManger].userModel.max_withdraw_money];
            self.moneyTxt.text = nil;
        } else {
            [MBProgressHUD showError:kUnNilStr(response.msg)];
        }
    }];
    
}

- (IBAction)actionRecord:(id)sender {
    
    TSWithDrawRecordListVC *rvc = [[TSWithDrawRecordListVC alloc] init];
    [self.navigationController pushViewController:rvc animated:YES];
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
