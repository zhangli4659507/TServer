//
//  TSHUnlockCell.m
//  TServer
//
//  Created by mark_zhang on 2018/10/13.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "TSHUnlockCell.h"
#import "TSHUnlockModel.h"
NSString *const TSHUnlockCellClassName = @"TSHUnlockCell";
@implementation TSHUnlockCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [T2TView setRoundCornerFor:self.orderBtn radiu:4.f];
    [T2TView setRoundCornerFor:self.bgView radiu:4.f];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    // Initialization code
}

- (void)configUiWithModel:(TSHUnlockListModel *)model {
    self.orderNumLbl.text = [NSString stringWithFormat:@"订单号：%@",model.order_sn];
    self.addTimeLbl.text = model.add_time;
    self.priceLbl.text = [NSString stringWithFormat:@"佣金：%@",model.order_price];
    self.nickNameLbl.text = [NSString stringWithFormat:@"下单人：%@",model.nickname];
    self.provinceLbl.text = [NSString stringWithFormat:@"省份：%@",kUnNilStr(model.province_name)];
    
}
- (IBAction)actionOkBtn:(id)sender {
     !self.actionOrderBlock?:self.actionOrderBlock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
