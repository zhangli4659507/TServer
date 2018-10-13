//
//  TSHRegisterOerderListModel.m
//  TServer
//
//  Created by mark_zhang on 2018/10/13.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "TSHRegisterOerderListModel.h"

@implementation TSHRegisterOerderListModel

@end

@implementation TSHRegisterOerderModel
+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"list":[TSHRegisterOerderListModel class]};
}
@end
