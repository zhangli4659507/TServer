//
//  TSRegisterOrderDetailModel.h
//  TServer
//
//  Created by mark_zhang on 2018/10/14.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSRegisterOrderDetailModel : NSObject
@property (nonatomic, assign) NSInteger order_id;//订单id
@property (nonatomic, copy) NSString *order_sn;//订单编号
@property (nonatomic, copy) NSString *order_price;//订单价格
@property (nonatomic, assign) NSInteger status;//订单状态 0下单成功 1付款成功 2-被接单 3-已完成（可投诉） 4-已完成（不可投诉了）
@property (nonatomic, copy) NSString *add_time;//下单时间
@property (nonatomic, copy) NSString *nickname;//下单用户昵称
@property (nonatomic, copy) NSString *jd_add_time;//接单时间
@property (nonatomic, copy) NSString *status_text;//订单状态显示标识
@property (nonatomic, assign) NSInteger type;//类型（1拍照上传 2扫码上传）-(1-直接根据链接photo_url显示图片 2-根据链接qrcode_url转为二维码图片显示)
@property (nonatomic, copy) NSString *photo_url;//图片路径（type=1时使用）
@property (nonatomic, copy) NSString *qrcode_url;//图片路径（type=2时使用）
@property (nonatomic, assign) BOOL is_complain;//投诉状态（0-没投诉 1-投诉申请 2-下单放胜 3-接单方胜 4-平台胜 ）
@property (nonatomic, copy) NSString *is_complain_text;//投诉状态
@end

NS_ASSUME_NONNULL_END
