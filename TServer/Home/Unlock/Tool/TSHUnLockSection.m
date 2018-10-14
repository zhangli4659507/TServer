//
//  TSHUnLockSection.m
//  TServer
//
//  Created by mark_zhang on 2018/10/13.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "TSHUnLockSection.h"
#import "TSHUnlockCell.h"

@implementation TSHUnLockSection
- (void)tableViewRegisterView:(UITableView *)tableView {
    
    [tableView registerNibName:TSHUnlockCellClassName forCellReuseIdentifier:TSHUnlockCellClassName];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndex:(NSInteger)index {
    
    TSHUnlockCell *cell = [tableView dequeueReusableCellWithIdentifier:TSHUnlockCellClassName];
    if (self.dataSource.count > index) {
        [cell configUiWithModel:self.dataSource[index]];
        WEAK_REF(self);
        [cell setActionOrderBlock:^{
            !weak_self.didSelectedBlock?:weak_self.didSelectedBlock(weak_self.dataSource[index]);
        }];
    }
    return cell;
    }

@end
