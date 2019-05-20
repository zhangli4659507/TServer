//
//  TSTimerTool.h
//  TServer
//
//  Created by Mark on 2019/5/20.
//  Copyright © 2019 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSTimerTool : NSObject

@property (nonatomic, assign) NSInteger timeSecond;

+ (instancetype)shareTimerTool;
@end

NS_ASSUME_NONNULL_END
