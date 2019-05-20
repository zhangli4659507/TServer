//
//  TSHRegisterCell.m
//  TServer
//
//  Created by mark_zhang on 2018/10/13.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "TSHRegisterCell.h"
#import "TSHRegisterOerderListModel.h"
#import "TSTimerTool.h"
NSString *const TSHRegisterCellClassName = @"TSHRegisterCell";

@interface TSHRegisterCell()

@end

@implementation TSHRegisterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [T2TView setRoundCornerFor:self.orderBtn radiu:4.f];
    [T2TView setRoundCornerFor:self.bgView radiu:4.f];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    TSTimerTool *timer =   [TSTimerTool shareTimerTool];
    [timer addObserver:self forKeyPath:@"timeSecond" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    // Initialization code
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    NSLog(@"keypath = %@  chage=%@",keyPath,change);
    
    if (_orderListmodel) {
        RUN_ON_UI_THREAD(^{
            self->_orderListmodel.remaining_time -= 1;
            [self configUi];
        });
       
    }
}

- (void)setOrderListmodel:(TSHRegisterOerderListModel *)orderListmodel {
    
    _orderListmodel = orderListmodel;
    [self configUi];
}

- (void)configUi {
   
    self.orderNumLbl.text = [NSString stringWithFormat:@"订单编号：%@",self.orderListmodel.order_sn];
    self.nickNameLbl.text = kUnNilStr(self.orderListmodel.nickname);
    self.timeLbl.text = [NSString stringWithFormat:@"%ld:%ld",self.orderListmodel.remaining_time/60,self.orderListmodel.remaining_time%60];
    self.priceLbl.text = [NSString stringWithFormat:@"佣金：%@",self.orderListmodel.order_price];
}

- (IBAction)actionOrderBtn:(id)sender {
    !self.actionOrderBlock?:self.actionOrderBlock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
