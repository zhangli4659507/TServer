//
//  TSHUnlockCell.h
//  TServer
//
//  Created by mark_zhang on 2018/10/13.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TSHUnlockListModel;
extern NSString *const TSHUnlockCellClassName;
@interface TSHUnlockCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNumLbl;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UIView *bgView;
- (void)configUiWithModel:(TSHUnlockListModel *)model;
@end

NS_ASSUME_NONNULL_END
