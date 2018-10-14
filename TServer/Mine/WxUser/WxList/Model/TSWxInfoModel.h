//
//  TSWxInfoModel.h
//  TServer
//
//  Created by mark_zhang on 2018/10/14.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface TSWxInfoListModel : NSObject
@property (nonatomic, assign) NSInteger jiedan_wx_id;//微信id
@property (nonatomic, copy) NSString *jd_phone;//电话号码
@property (nonatomic, copy) NSString *jd_wx_sn;//微信号

@end
@interface TSWxInfoModel : NSObject
@property (nonatomic, assign) NSInteger total_count;//总数
@property (nonatomic, assign) NSInteger total_pages;//总页数
@property (nonatomic, assign) NSInteger page_size;//每页显示数
@property (nonatomic, assign) NSInteger page_index;//当前数
@property (nonatomic, copy) NSArray<TSWxInfoListModel *> *list;
@end

NS_ASSUME_NONNULL_END
