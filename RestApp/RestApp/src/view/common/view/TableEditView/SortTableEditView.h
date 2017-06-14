//
//  SortTableEditView.h
//  RestApp
//
//  Created by zishu on 16/8/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TableEditView.h"
#import "NavigateTitle2.h"
#import "ISampleListEvent.h"
#import "SortItemValue.h"
#import "TreeNode.h"
@interface SortTableEditView : TableEditView<ISampleListEvent,INavigateEvent>

- (void)reload:(NSMutableArray*) dataTemps error:(NSString*)error;

@end













