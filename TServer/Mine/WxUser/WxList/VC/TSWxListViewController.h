//
//  TSWxListViewController.h
//  TServer
//
//  Created by mark_zhang on 2018/10/14.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "TBaseViewcontroller.h"
#import "TSWxInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TSWxListViewController : TBaseViewcontroller
@property (nonatomic, assign) BOOL isSelectType;
@property (nonatomic, copy) void (^selectItemBlock)(TSWxInfoListModel *wxUserInfoModel);
@end

NS_ASSUME_NONNULL_END
