//
//  TSDrawRecordSection.m
//  TServer
//
//  Created by mark_zhang on 2018/10/31.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "TSDrawRecordSection.h"
#import "TSWithDrawReordCell.h"
#import "TSWithDrawModel.h"
@implementation TSDrawRecordSection
- (void)tableViewRegisterView:(UITableView *)tableView {
    
    [tableView registerNibName:TSWithDrawReordCellClassName forCellReuseIdentifier:TSWithDrawReordCellClassName];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndex:(NSInteger)index {
    
    TSWithDrawReordCell *cell = [tableView dequeueReusableCellWithIdentifier:TSWithDrawReordCellClassName];
    if (self.dataSource.count > index) {
        TSWithDrawListModel *model = self.dataSource[index];
        cell.moneyLbl.text = [NSString stringWithFormat:@"提现金额：%@",model.money];
        cell.timeLbl.text = kUnNilStr(model.add_time);
        cell.stateLbl.text = kUnNilStr(model.status_name);
    }
    
    return cell;
}

@end
