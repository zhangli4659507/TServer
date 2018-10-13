//
//  TSORegisterOrderModel.m
//  TServer
//
//  Created by mark_zhang on 2018/10/13.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "TSORegisterOrderModel.h"

@implementation TSORegisterOrderListModel

@end

@implementation TSORegisterOrderModel
+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"list":[TSORegisterOrderListModel class]};
}
@end
