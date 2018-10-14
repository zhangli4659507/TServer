//
//  TSWxListSection.m
//  TServer
//
//  Created by mark_zhang on 2018/10/14.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "TSWxListSection.h"
#import "TSWxInfoModel.h"
#import "TSWxListTableViewCell.h"
@implementation TSWxListSection
- (void)tableViewRegisterView:(UITableView *)tableView {
    [tableView registerNibName:TSWxListTableViewCellClassName forCellReuseIdentifier:TSWxListTableViewCellClassName];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndex:(NSInteger)index {
    
    TSWxListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TSWxListTableViewCellClassName];
    if (self.dataSource.count > index) {
        TSWxInfoListModel *listModel = self.dataSource[index];
        cell.wxNumLbl.text = [NSString stringWithFormat:@"微信号：%@",listModel.jd_wx_sn];
        cell.wxPhoneLbl.text = [NSString stringWithFormat:@"电话号码：%@",listModel.jd_phone];
    }
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndex:(NSInteger)index {
    
    if (self.dataSource.count > index && self.didSelectedBlock) {
        self.didSelectedBlock(self.dataSource[index]);
    }
}


@end
