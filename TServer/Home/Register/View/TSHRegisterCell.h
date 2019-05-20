//
//  TSHRegisterCell.h
//  TServer
//
//  Created by mark_zhang on 2018/10/13.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TSHRegisterOerderListModel;
extern NSString *const TSHRegisterCellClassName;
@interface TSHRegisterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNumLbl;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, copy) void (^actionOrderBlock)(void);
@property (nonatomic, weak) TSHRegisterOerderListModel *orderListmodel;
//- (void)configUiWithListModel:(TSHRegisterOerderListModel *)model;

@end

NS_ASSUME_NONNULL_END
