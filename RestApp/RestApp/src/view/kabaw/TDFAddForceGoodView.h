//
//  TDFAddForceGoodView.h
//  RestApp
//
//  Created by hulatang on 16/8/2.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TDFAddForceGoodViewDelegate <NSObject>

- (void)changeEditStatus:(BOOL)status;//改变导航条状态

- (void)deleteForceMenuWithData:(id)data;

@end
@class TDFForceMenuVo,TDFForceConfigVo;
@interface TDFAddForceGoodView : UIView

@property (nonatomic, assign)BOOL isEdit;

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong)TDFForceMenuVo *forceMenuVo;

@property (nonatomic, strong)TDFForceConfigVo *forceConfig;

@property (nonatomic, weak)id<TDFAddForceGoodViewDelegate> delegate;

@end


