//
//  TDFMustSelectGoodsView.h
//  RestApp
//
//  Created by hulatang on 16/7/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TDFMustSelectGoodsViewDelegate <NSObject>
@optional
- (void)addNewMustSelectGood;

- (void)seeDetailGoodInfoWithData:(id)data;

- (void)seeDetailInfoOfIntroduce;

- (void)showHelpPage:(NSString *)key;
@end

@interface TDFMustSelectGoodsView : UIView
@property (nonatomic, weak)id<TDFMustSelectGoodsViewDelegate> delegate;
@property (nonatomic ,strong)NSMutableArray *dataArray;
@property (nonatomic ,strong)UITableView *tableView;
@end

