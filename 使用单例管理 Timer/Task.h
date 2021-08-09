//
//  Task.h
//
//  Created by Liuyang on 2021/8/5.
//
//Task 类,作为定时器任务类

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSObject

- (instancetype)initWithTime:(NSUInteger)time handler:(void(^) (void))handler;

/// 标志
@property (nonatomic, readonly, copy) NSString *taskId;

/// 时间单位为 1/60 秒, 屏幕刷新频率最高为 60Hz
@property (nonatomic, assign) NSUInteger time;

/// 要执行的动作
@property (nonatomic, copy) void(^event)(void);

@end

NS_ASSUME_NONNULL_END
