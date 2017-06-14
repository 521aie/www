//
//  TDFOptionSelectController.h
//  TDFTools
//
//  Created by Octree on 16/8/16.
//  Copyright © 2016年 Octree. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^TDFOptionSelectCancelBlock) ();
typedef void (^TDFOptionSelectCompletionBlock) (NSArray *selectedIndexes);

@protocol TDFOptionSelectPresentable <NSObject>

@property (copy, nonatomic, readonly) NSString *optionTitle;

@end

@interface TDFOptionSelectController : UINavigationController

/**
 *  element must conform to TDFOptionSelectPresentable
 */
@property (copy, nonatomic) NSArray *options;
@property (copy, nonatomic) NSArray<NSNumber *> *selectedIndexs;

@property (copy, nonatomic) void (^cancelBlock)();
@property (copy, nonatomic) void (^completionBlock)(NSArray *selectedIndexPaths);

+ (instancetype)optionSelectControllerWithOptions:(NSArray *)options
                                   selectedIndexes:(NSArray *)selectedIndexes
                                      cancelBlock:(TDFOptionSelectCancelBlock)cancel
                                       completion:(TDFOptionSelectCompletionBlock)completion;

@end
