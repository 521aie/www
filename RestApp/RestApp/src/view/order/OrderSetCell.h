//
//  OrderSetCell.h
//  RestApp
//
//  Created by iOS香肠 on 16/3/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FuctionViewCell.h"
#define ORDERSETCELL @"OrderSetCell"

@interface OrderSetCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *gLbl;

@property (strong, nonatomic) IBOutlet UILabel *setLbl;

@property (strong, nonatomic) IBOutlet UIButton *button;

@property (nonatomic ,assign)id<FuctionViewCellDelegate>delegate;

- (IBAction)btnClick:(id)sender;

-(void)setTheGoodsName:(NSString *)name;

-(void)setTheLblName:(NSString *)name;

-(void)setTheSetLabel:(NSNumber *)tag;
- (void)initDelegate:(id<FuctionViewCellDelegate>)delegeta;
@end
