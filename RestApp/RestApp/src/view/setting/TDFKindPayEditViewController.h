//
//  TDFKindPayEditViewController.h
//  RestApp
//
//  Created by chaiweiwei on 2017/2/13.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRootViewController.h"
#import "KindPayVO.h"

typedef NS_ENUM(NSInteger,TDFBrandKindPayType) {
    TDFBrandKindPayTypeAdd,
    TDFBrandKindPayTypeEdit,
};

@interface TDFKindPayEditViewController : TDFRootViewController

@property (nonatomic,copy) NSArray <KindPayVO *>*kindAllPayList;
@property (nonatomic,assign) TDFBrandKindPayType type;
@property (nonatomic,assign) BOOL canEdit;

@property (nonatomic,strong) KindPayVO *kindPay;

@end
