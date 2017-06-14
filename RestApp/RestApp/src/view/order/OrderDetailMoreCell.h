//
//  OrderDetailMoreCell.h
//  RestApp
//
//  Created by apple on 16/4/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrderDetailWeight.h"

@class OrderDetailMoreCell;
@protocol  OnITeamListView <NSObject>

-(void)onIrdeItemListClick:(OrderDetailMoreCell *)cell;

@end

@interface OrderDetailMoreCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *detail;
@property (strong, nonatomic) IBOutlet UILabel *lablname;
@property (nonatomic ,assign) id <OnITeamListView>delegat;
@property (strong, nonatomic) IBOutlet UIButton *btnCLick;
@property (nonatomic ,assign) NSInteger section;
@property (nonatomic ,assign) NSInteger row;
@property (nonatomic ,assign) NSInteger isMore;
@property (nonatomic ,strong) NSString * rowindex;
@property (strong, nonatomic) IBOutlet UIView *line;
@property (strong, nonatomic) IBOutlet UIImageView *btnImg;


- (IBAction)btnClick:(id)sender;
-(void)initarry:(OrderDetailWeight *)iteam delegate:(id<OnITeamListView>)delegate tag:(NSInteger)tag iteamTag:(NSInteger)row;
-(void)initmorearry:(OrderDetailWeight *)iteam delegate:(id<OnITeamListView>)delegate tag:(NSInteger)tag  iteamTag:(NSInteger)row;
-(NSString *)getstr;

@end
