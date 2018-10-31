//
//  TSWithDrawModel.m
//  TServer
//
//  Created by mark_zhang on 2018/10/31.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "TSWithDrawModel.h"
@implementation TSWithDrawListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"listId":@"id"};
}
@end
@implementation TSWithDrawModel
+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"list":[TSWithDrawListModel class]};
}
@end
