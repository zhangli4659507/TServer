//
//  TSWithDrawModel.h
//  TServer
//
//  Created by mark_zhang on 2018/10/31.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSWithDrawListModel : NSObject
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *alipay;
@property (nonatomic, copy) NSString *fee;
@property (nonatomic, assign) NSInteger listId;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *status_name;
@property (nonatomic, copy) NSString *update_time;
@property (nonatomic, assign) NSInteger user_id;
@end

@interface TSWithDrawModel : NSObject
@property (nonatomic, assign) NSInteger page_index;
@property (nonatomic, assign) NSInteger page_size;
@property (nonatomic, assign) NSInteger total_count;
@property (nonatomic, assign) NSInteger total_pages;
@property (nonatomic, copy) NSArray<TSWithDrawListModel *> *list;



@end

NS_ASSUME_NONNULL_END
