//
//  TSHRegisterSection.m
//  TServer
//
//  Created by mark_zhang on 2018/10/13.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "TSHRegisterSection.h"
#import "TSHRegisterCell.h"
@implementation TSHRegisterSection
- (void)tableViewRegisterView:(UITableView *)tableView {
    
    [tableView registerNibName:TSHRegisterCellClassName forCellReuseIdentifier:TSHRegisterCellClassName];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndex:(NSInteger)index {
    
    TSHRegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:TSHRegisterCellClassName];
    if(self.dataSource.count > index) {
        
        [cell configUiWithListModel:self.dataSource[index]];
        WEAK_REF(self);
        [cell setActionOrderBlock:^{
            !weak_self.didSelectedBlock?:weak_self.didSelectedBlock(weak_self.dataSource[index]);
        }];
    }
    return cell;
}
@end
