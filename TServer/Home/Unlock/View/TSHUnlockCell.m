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
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
