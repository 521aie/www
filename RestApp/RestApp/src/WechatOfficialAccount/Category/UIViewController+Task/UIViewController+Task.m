//
//  UIViewController+Task.m
//  RestApp
//
//  Created by Octree on 4/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "UIViewController+Task.h"
#import <objc/runtime.h>

@interface UIViewController (StoreTask)

@property (strong, nonatomic) NSMutableArray <NSURLSessionTask *> *tasks;

@end

static const void *kTDFStoreTaskKey = "kTDFStoreTaskKey";

@implementation UIViewController (Task)

+ (void)load {

    Method m1 = class_getInstanceMethod([self class], @selector(viewDidDisappear:));
    Method m2 = class_getInstanceMethod([self class], @selector(hook_viewDidDisappear));
    method_exchangeImplementations(m1, m2);
}

- (void)hook_viewDidDisappear {

    [self cancelAllTasks];
    [self hook_viewDidDisappear];
}


- (void)bindTask:(NSURLSessionTask *)task {

    [self.tasks addObject:task];
}

- (void)cancelAllTasks {

    [self.tasks makeObjectsPerformSelector:@selector(cancel)];
}

@end


@implementation UIViewController (StoreTask)

- (NSMutableArray <NSURLSessionTask *> *)tasks {
    
    NSMutableArray *array = objc_getAssociatedObject(self, kTDFStoreTaskKey);
    if (!array) {
        array = [NSMutableArray array];
        objc_setAssociatedObject(self, kTDFStoreTaskKey, array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return array;
}

- (void)setTasks:(NSMutableArray<NSURLSessionTask *> *)tasks {

    objc_setAssociatedObject(self, kTDFStoreTaskKey, tasks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
