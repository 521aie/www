//
//  TDFBusinessAccountInfoListView.h
//  RestApp
//
//  Created by happyo on 2017/1/4.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFBusinessAccountInfoModel : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *account;

@property (nonatomic, assign) BOOL isShowDescription;

@end

@interface TDFBusinessAccountInfoDetailView : UIView

@property (nonatomic, strong) UILabel *lblTitle;

@property (nonatomic, strong) UILabel *lblAccount;

@property (nonatomic, strong) UILabel *lblDescription;

@property (nonatomic, strong) UIView *spliteView;

@end

@interface TDFBusinessAccountInfoListView : UIView

@property (nonatomic, assign) CGFloat heightForView;

- (void)configureViewWithModelList:(NSArray<TDFBusinessAccountInfoModel *> *)modelList;

@end
