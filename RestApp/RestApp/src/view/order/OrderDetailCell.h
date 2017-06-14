//
//  OrderDetailCell.h
//  RestApp
//
//  Created by apple on 16/4/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditItemList.h"
#import "OrderDetailWeight.h"
@interface OrderDetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titileLbl;
@property (strong, nonatomic) IBOutlet EditItemList *selectview;
@property (strong, nonatomic) IBOutlet EditItemList *hideview;
-(void)initarry:(OrderDetailWeight *)arry delegate:(id<IEditItemListEvent>)delegate tag:(NSInteger)tag iteamTag:(NSInteger)row;
-(NSString *)getstr;
-(NSString *)getHideStr;
- (void)changedata:(NSString *)data withVal:(NSString *)val;
- (void)cahngeTheData:(NSString *)data withVal:(NSString *)val;
@end
