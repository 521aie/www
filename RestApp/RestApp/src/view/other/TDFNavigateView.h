//
//  TDFNavigateView.h
//  RestApp
//
//  Created by 黄河 on 16/10/13.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TDFNavigateView;

@protocol TDFNavigateViewDelegate <NSObject>

- (void)switchToViewController:(TDFFunctionVo *)functionVO;

- (void)footerButtonClickWithIndex:(int)index;

@optional
- (void)navigateView:(TDFNavigateView *)navigateView didSearchWithKeyword:(NSString *)keyword;

@end

@interface TDFNavigateView : UIView

@property (nonatomic, strong)UIView         *footerView;
@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, weak)id<TDFNavigateViewDelegate> delegate;
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)NSArray *allSearchDataArray;
@property (nonatomic, strong)NSMutableArray *searchDataArray;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong)UITableView    *tableView;


- (void)reloadData;

@end
