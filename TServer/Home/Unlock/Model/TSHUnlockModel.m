//
//  TSHUnlockModel.m
//  TServer
//
//  Created by mark_zhang on 2018/10/13.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "TSHUnlockModel.h"
@implementation TSHUnlockListModel

@end
@implementation TSHUnlockModel
+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"list":[TSHUnlockListModel class]};
    
}
@end
