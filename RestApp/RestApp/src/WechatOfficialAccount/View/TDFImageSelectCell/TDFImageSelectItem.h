//
//  TDFImageSelectItem.h
//  RestApp
//
//  Created by Octree on 12/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFForm.h"

/**
 *  ImageURL String 放在 RequestValue 中
 */
@interface TDFImageSelectItem : TDFBaseEditItem

@property (strong, nonatomic) void (^deleteBlock)();
@property (strong, nonatomic) void (^selectBlock)();

@property (copy, nonatomic) NSString *prompt;
@property (copy, nonatomic) NSString *errorMessage;
@property (nonatomic) BOOL separatorHidden;

@end
