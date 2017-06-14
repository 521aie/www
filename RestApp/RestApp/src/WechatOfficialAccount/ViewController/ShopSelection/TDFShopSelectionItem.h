//
//  TDFShopSelectionItem.h
//  RestApp
//
//  Created by Octree on 13/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFBaseEditItem.h"

typedef NS_ENUM(NSInteger, TDFShopSelectionState) {
    
    TDFShopSelectionStateNormal        =   0,
    TDFShopSelectionStateSelected      =   1,
};


typedef NS_ENUM(NSInteger, TDFShopSelectionStyle) {

    TDFShopSelectionStyleNormal         =       0,
    TDFShopSelectionStyleDisable        =       1,
};


@interface TDFShopSelectionItem : TDFBaseEditItem

@property (nonatomic) BOOL canSelected;
@property (copy, nonatomic) NSString *subTitle;
@property (copy, nonatomic) NSString *prompt;
@property (nonatomic) TDFShopSelectionState state;
@property (nonatomic) TDFShopSelectionStyle style;
@property (nonatomic) void (^promptBlock)(void);
@property (nonatomic) void (^selectionChangedBlock)(BOOL newValue);

@end
