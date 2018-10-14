//
//  TSRegisterOrderDetailViewController.h
//  TServer
//
//  Created by mark_zhang on 2018/10/14.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "TBaseViewcontroller.h"

NS_ASSUME_NONNULL_BEGIN

@interface TSRegisterOrderDetailViewController : TBaseViewcontroller
@property (nonatomic, assign) NSInteger order_id;
@property (nonatomic, copy) void (^handleSuccessBlock)();
@end

NS_ASSUME_NONNULL_END
