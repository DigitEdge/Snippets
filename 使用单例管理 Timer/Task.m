//
//  Task.m
//
//  Created by Liuyang on 2021/8/5.
//

#import "Task.h"

@implementation Task

- (instancetype)initWithTime:(NSUInteger)time handler:(void (^)(void))handler {
    if (self = [super init]) {
        self.time = time;
        self.event = handler;
        _taskId = [NSUUID UUID].UUIDString;
    }
    return self;
}

@end
