//
//  TDFFoodSelectViewController.h
//  RestApp
//
//  Created by happyo on 2016/11/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRootViewController.h"
@class TDFFoodCategorySelectedModel;
@class TDFFoodSelectViewController;

@protocol TDFFoodSelectViewControllerDelegate <NSObject>

- (void)viewController:(TDFFoodSelectViewController *)viewController changedFoodCategoryList:(NSArray<TDFFoodCategorySelectedModel *> *)foodCategorySelectedList;

@end

@interface TDFFoodSelectViewController : TDFRootViewController

@property (nonatomic, weak) id<TDFFoodSelectViewControllerDelegate> delegate;

@property (nonatomic, strong) NSString *navTitle;

@property (nonatomic, strong) NSMutableArray<TDFFoodCategorySelectedModel *> *foodCategorySelectedList;

@end
