//
//  TSWithDrawReordCell.m
//  TServer
//
//  Created by mark_zhang on 2018/10/31.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "TSWithDrawReordCell.h"
NSString *const TSWithDrawReordCellClassName = @"TSWithDrawReordCell";
@implementation TSWithDrawReordCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.preservesSuperviewLayoutMargins = YES;
    self.separatorInset = UIEdgeInsetsZero;
    self.layoutMargins = UIEdgeInsetsZero;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
