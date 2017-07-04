//
//  TDFNavigateView.h
//  RestApp
//
//  Created by 黄河 on 16/10/13.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TDFNavigateView;
#import "TDFHomeGroupForwardItem.h"

@protocol TDFNavigateViewDelegate <NSObject>

- (void)switchToViewControllerWithCode:(NSString *)actionCode isLock:(BOOL)isLock actionName:(NSString *)actionName;

- (void)goNextWithUrlString:(NSString *)urlString;

- (void)footerButtonClickWithIndex:(int)index;

@optional
- (void)navigateView:(TDFNavigateView *)navigateView didSearchWithKeyword:(NSString *)keyword;

@end

@interface TDFNavigateSectionModel : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *clickUrl;

@property (nonatomic, strong) NSString *clickTitle;

// 0:普通 1：操作指南，2：常见问题
@property (nonatomic, assign) int index;

@property (nonatomic, strong) NSArray<TDFHomeGroupForwardChildCellModel *> *forwardCells;

@end

@interface TDFNavigateView : UIView

@property (nonatomic, strong)UIView         *footerView;
@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, weak)id<TDFNavigateViewDelegate> delegate;
@property (nonatomic, strong)NSArray<TDFNavigateSectionModel *> *dataArray;
@property (nonatomic, strong)NSArray<TDFNavigateSectionModel *> *allSearchDataArray;
@property (nonatomic, strong)NSMutableArray<TDFNavigateSectionModel *> *searchDataArray;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong)UITableView    *tableView;


- (void)reloadData;

@end
