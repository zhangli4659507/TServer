//
//  TSTimerTool.m
//  TServer
//
//  Created by Mark on 2019/5/20.
//  Copyright © 2019 Mark. All rights reserved.
//

#import "TSTimerTool.h"

@interface TSTimerTool()
@property(nonatomic, copy)dispatch_source_t timer;
@end

@implementation TSTimerTool
+ (instancetype)shareTimerTool {
    
    static TSTimerTool *timerTool =  nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        timerTool = [[TSTimerTool alloc] init];
        timerTool.timeSecond = 0;
        [timerTool startTimer];
    });
    return timerTool;
}

- (void)startTimer {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
     dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0),  NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        self.timeSecond = self.timeSecond + 1;
//        [self setValue:@(self->_timeSecond++) forKey:@"timeSecond"];
    });
    dispatch_resume(_timer);
}

@end
