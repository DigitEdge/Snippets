//
//  UILabel+ChangeDefaultFont.m
//  RuntimeTest
//
//  Created by Liuyang on 2021/8/10.
//

#import "UILabel+ChangeDefaultFont.h"
#import <objc/runtime.h>

/// 每个 NSObject 的子类在加载时都会调用下面这个方法.在这里将 init 方法替换,使用我们的新字体.
/// 如果在程序中又特殊设置了字体,则特殊设置的字体不会受影响,但是不要在 label 的 init 方法中设置字体
/// init/initWithFrame/nib 文件的加载方法,都支持更换默认字体

@implementation UILabel (ChangeDefaultFont)
+ (void)load {
    // 只执行一次这个方法,否则每次调用 UILabel 及其子类都会调用, 会造成性能问题.(在 FM APP 开发中 UIView 的layoutSubviews 方法替换时遇到过)
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
//        替换三个方法
        SEL originalSelector = @selector(init);
        SEL originalSelector2 = @selector(initWithFrame:);
        SEL originalSelector3 = @selector(awakeFromNib);
        SEL swizzledSelector = @selector(LSBaseInit);
        SEL swizzledSelector2 = @selector(LSBaseInitWithFrame:);
        SEL swizzledSelector3 = @selector(LSBaseAwakeFromNib);

        Method orginalMethod = class_getInstanceMethod(class, originalSelector);
        Method orginalMethod2 = class_getInstanceMethod(class, originalSelector2);
        Method orginalMethod3 = class_getInstanceMethod(class, originalSelector3);

        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        Method swizzledMethod2 = class_getInstanceMethod(class, swizzledSelector2);
        Method swizzledMethod3 = class_getInstanceMethod(class, swizzledSelector3);
        
        BOOL didAddMethod = class_addMethod(class,
                                            originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));
        BOOL didAddMethod2 = class_addMethod(class,
                                            originalSelector2,
                                            method_getImplementation(swizzledMethod2),
                                            method_getTypeEncoding(swizzledMethod2));
        BOOL didAddMethod3 = class_addMethod(class,
                                            originalSelector3,
                                            method_getImplementation(swizzledMethod3),
                                            method_getTypeEncoding(swizzledMethod3));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(orginalMethod),
                                method_getTypeEncoding(orginalMethod));
        }else {
            method_exchangeImplementations(orginalMethod, swizzledMethod);
        }
        
        if (didAddMethod2) {
            class_replaceMethod(class,
                                swizzledSelector2,
                                method_getImplementation(orginalMethod2),
                                method_getTypeEncoding(orginalMethod2));
        }else {
            method_exchangeImplementations(orginalMethod2, swizzledMethod2);
        }
        
        if (didAddMethod3) {
            class_replaceMethod(class,
                                swizzledSelector3,
                                method_getImplementation(orginalMethod3),
                                method_getTypeEncoding(orginalMethod3));
        }else {
            method_exchangeImplementations(orginalMethod3, swizzledMethod3);
        }
    });
}


/// 在这些方法中替换自定义的字体
- (instancetype)LSBaseInit {
    id __self = [self LSBaseInit];
    UIFont *font = [UIFont fontWithName:@"" size:self.font.pointSize];
    if (font) {
        self.font = font;
    }
    return __self;
}

- (instancetype)LSBaseInitWithFrame:(CGRect)rect {
    id __self = [self LSBaseInitWithFrame: rect];
    UIFont *font = [UIFont fontWithName:@"" size:self.font.pointSize];
    if (font) {
        self.font = font;
    }
    return __self;
}

- (void)LSBaseAwakeFromNib {
    [self LSBaseAwakeFromNib];
    UIFont *font = [UIFont fontWithName:@"" size:self.font.pointSize];
    if (font) {
        self.font = font;
    }
}
@end
