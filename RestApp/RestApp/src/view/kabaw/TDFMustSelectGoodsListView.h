//
//  TDFMustSelectGoodsListView.h
//  RestApp
//
//  Created by hulatang on 16/8/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TDFMustSelectGoodsListViewDelegate <NSObject>
@optional

- (void)selectGoodWithData:(id)data andIsForceMenu:(int)isForceMenu;//点击tableview回调

@end

@interface TDFMustSelectGoodsListView : UIView

@property (nonatomic, strong)NSArray *dataArray;

@property (nonatomic, assign)NSInteger scrollIndex;

@property (nonatomic, weak)id<TDFMustSelectGoodsListViewDelegate> delegate;

@end
