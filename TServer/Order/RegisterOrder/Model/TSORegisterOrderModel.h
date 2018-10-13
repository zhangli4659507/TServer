//
//  TSORegisterOrderModel.h
//  TServer
//
//  Created by mark_zhang on 2018/10/13.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface TSORegisterOrderListModel : NSObject
@property (nonatomic, assign) NSInteger order_id;//订单id
@property (nonatomic, copy) NSString *order_sn;//订单编号
@property (nonatomic, copy) NSString *order_price;//订单价格
@property (nonatomic, assign) NSInteger status;//订单状态 0下单成功 1付款成功 2-被接单 3-已完成（可投诉） 4-已完成（不可投诉了）
@property (nonatomic, copy) NSString *add_time;//下单时间
@property (nonatomic, copy) NSString *nickname;//下单用户昵称
@property (nonatomic, copy) NSString *jd_add_time;//接单时间
@property (nonatomic, copy) NSString *jd_finish_time;//接单完成时间
@property (nonatomic, copy) NSString *status_text;//订单状态显示标识
@end
@interface TSORegisterOrderModel : NSObject
@property (nonatomic, assign) NSInteger total_count;//总数
@property (nonatomic, assign) NSInteger total_pages;//总页数
@property (nonatomic, assign) NSInteger page_size;//每页显示数
@property (nonatomic, assign) NSInteger page_index;//当前数
@property (nonatomic, copy) NSArray<TSORegisterOrderListModel *> *list;
@end

NS_ASSUME_NONNULL_END
