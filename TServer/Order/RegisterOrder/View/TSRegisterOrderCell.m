//
//  TSRegisterOrderCell.m
//  TServer
//
//  Created by mark_zhang on 2018/10/13.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "TSRegisterOrderCell.h"
#import "TSORegisterOrderModel.h"
NSString *const TSRegisterOrderCellClassName = @"TSRegisterOrderCell";
@implementation TSRegisterOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [T2TView setRoundCornerFor:self.stateBtn radiu:4.f];
    // Initialization code
}

- (void)configUIWithModel:(TSORegisterOrderListModel *)model {
    
    self.orderNumLbl.text = [NSString stringWithFormat:@"订单号：%@",model.order_sn];
    self.priceLbl.text = [NSString stringWithFormat:@"¥%@",model.order_price];
    self.priceLbl.text = [NSString stringWithFormat:@"下单人：%@",model.nickname];
    self.addTimeLbl.text = [NSString stringWithFormat:@"时间：%@",model.add_time];
    self.orderStateLbl.text = model.status_text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
