//
//  TSUnlockOrderDetailModel.h
//  TServer
//
//  Created by mark_zhang on 2018/10/14.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSUnlockOrderDetailModel : NSObject
@property (nonatomic, assign) NSInteger jiedan_id;//接单id
@property (nonatomic, assign) NSInteger order_id;//订单id
@property (nonatomic, copy) NSString *order_sn;//订单编号
@property (nonatomic, copy) NSString *order_price;//订单价格
@property (nonatomic, assign) NSInteger status;//订单状态 0接单成功待录入微信 1-录入微信完成 2-辅助解封完成 3-别人辅助解封完成 4-订单取消
@property (nonatomic, copy) NSString *add_time;//下单时间
@property (nonatomic, copy) NSString *nickname;//下单用户昵称
@property (nonatomic, copy) NSString *jd_add_time;//接单时间
@property (nonatomic, copy) NSString *status_text;//订单状态显示标识
@property (nonatomic, copy) NSString *jd_finish_time;//接单完成时间
@property (nonatomic, assign) BOOL is_complain;//投诉状态（0-没投诉 1-投诉申请 2-下单放胜 3-接单方胜 4-平台胜 ）
@property (nonatomic, copy) NSString *is_complain_text;//接单完成时间
@end

NS_ASSUME_NONNULL_END
