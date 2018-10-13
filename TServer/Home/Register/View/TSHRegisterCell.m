//
//  TSHRegisterCell.m
//  TServer
//
//  Created by mark_zhang on 2018/10/13.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "TSHRegisterCell.h"
#import "TSHRegisterOerderListModel.h"
NSString *const TSHRegisterCellClassName = @"TSHRegisterCell";
@implementation TSHRegisterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [T2TView setRoundCornerFor:self.orderBtn radiu:4.f];
    [T2TView setRoundCornerFor:self.bgView radiu:4.f];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    // Initialization code
}

- (void)configUiWithListModel:(TSHRegisterOerderListModel *)model {
    
    self.orderNumLbl.text = [NSString stringWithFormat:@"订单编号：%@",model.order_sn];
    self.nickNameLbl.text = kUnNilStr(model.nickname);
    self.timeLbl.text = kUnNilStr(model.remaining_time_text);
    self.priceLbl.text = [NSString stringWithFormat:@"佣金：%@",model.order_price];
}

- (IBAction)actionOrderBtn:(id)sender {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
