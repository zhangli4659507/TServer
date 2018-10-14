//
//  TSWxInfoModel.m
//  TServer
//
//  Created by mark_zhang on 2018/10/14.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "TSWxInfoModel.h"
@implementation TSWxInfoListModel

@end

@implementation TSWxInfoModel
+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"list":[TSWxInfoListModel class]};
}
@end
