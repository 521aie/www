//
//  TDFMenuEditViewController.h
//  RestApp
//
//  Created by Octree on 8/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDFOAMenuModel.h"

typedef NS_ENUM(NSInteger, TDFMenuEditType) {

    TDFMenuEditTypeAdd      =       0,
    TDFMenuEditTypeEdit     =       1,
};

typedef NS_ENUM(NSInteger, TDFMenuEditAction) {

    //  修改操作
    TDFMenuEditActionEdit       =       0,
    //  删除操作
    TDFMenuEditActionDelete     =       1,
};

@interface TDFMenuEditViewController : UIViewController

@property (copy, nonatomic) NSString *officialAccountId;
+ (instancetype)menuEditViewControllerWithModel:(TDFOAMenuModel *)model editType:(TDFMenuEditType)editType isSubMenu:(BOOL)isSubMenu;
@property (strong, nonatomic) void (^completionBlock)(TDFOAMenuModel *menu, TDFMenuEditAction action);

@end
