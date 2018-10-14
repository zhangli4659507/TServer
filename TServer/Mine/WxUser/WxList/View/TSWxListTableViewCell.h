//
//  TSWxListTableViewCell.h
//  TServer
//
//  Created by mark_zhang on 2018/10/14.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
extern NSString *const TSWxListTableViewCellClassName;
@interface TSWxListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *wxNumLbl;
@property (weak, nonatomic) IBOutlet UILabel *wxPhoneLbl;

@end

NS_ASSUME_NONNULL_END
