//
//  OrderGuiGeView.h
//  RestApp
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditItemList.h"
@interface OrderGuiGeView : UIView
@property (strong, nonatomic) IBOutlet UIView *view;

@property (strong, nonatomic) IBOutlet UILabel *TittleLbl;
@property (strong, nonatomic) IBOutlet EditItemList *selectList;
@property (strong, nonatomic) IBOutlet EditItemList *HideList;

-(void)visible:(BOOL)hide;

-(void)initarry:(NSArray *)arry delegate:(id<IEditItemListEvent>)delegate tag:(NSInteger)tag;
- (void)changedata:(NSString *)data withVal:(NSString *)val;
-(NSString *)getstr;
-(CGFloat )getHeight;
@end
