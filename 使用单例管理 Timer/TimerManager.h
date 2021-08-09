//
//  TimerManager.h
//
//  Created by Liuyang on 2021/8/5.
//
//使用单例管理定时器,统一管理整个工程的定时任务,无论有多少定时任务,保证整个工程都只有一个定时器在运行

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN
@class Task;
@interface TimerManager : NSObject

+ (instancetype)defaultManager;

- (void)runTask:(Task *)task;

/// 取消指定的定时器任务
/// @param taskId  taskId
- (void)cancelTaskWithId:(NSString *)taskId;
@end

NS_ASSUME_NONNULL_END
