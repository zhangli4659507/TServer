//
//  TSWithDrawReordCell.h
//  TServer
//
//  Created by mark_zhang on 2018/10/31.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
extern NSString *const TSWithDrawReordCellClassName;
@interface TSWithDrawReordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moneyLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *stateLbl;

@end

NS_ASSUME_NONNULL_END
