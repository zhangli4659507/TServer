//
//  TSRegisterOrderSection.m
//  TServer
//
//  Created by mark_zhang on 2018/10/13.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "TSRegisterOrderSection.h"
#import "TSRegisterOrderCell.h"
@implementation TSRegisterOrderSection
- (void)tableViewRegisterView:(UITableView *)tableView {
    
    [tableView registerNibName:TSRegisterOrderCellClassName forCellReuseIdentifier:TSRegisterOrderCellClassName];
    }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndex:(NSInteger)index {
    TSRegisterOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:TSRegisterOrderCellClassName];
    if (self.dataSource.count > index) {
        [cell configUIWithModel:self.dataSource[index]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndex:(NSInteger)index {
    
    if (self.didSelectedBlock && self.dataSource.count> index) {
        self.didSelectedBlock(self.dataSource[index]);
    }
}

@end
