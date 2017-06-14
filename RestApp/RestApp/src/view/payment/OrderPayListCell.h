//
//  OrderPayListCell.h
//  RestApp
//
//  Created by 果汁 on 15/9/18.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderPayListData.h"
#import "CopyFounctionLabel.h"
@interface OrderPayListCell : UITableViewCell <CopyFounctionLabelEvent>
@property (nonatomic, strong) IBOutlet UILabel *innerCode;
@property (nonatomic, strong) IBOutlet UILabel *seatName;
@property (nonatomic, strong) IBOutlet UILabel *payTime;
@property (nonatomic, strong)  UILabel *payName;
@property (nonatomic,strong)  UILabel *way;
@property (nonatomic, strong) UILabel *orIntoMyCount;
@property (nonatomic, strong) UILabel *intoCountMoney;
@property (weak, nonatomic) IBOutlet UILabel *mobile;
@property (weak, nonatomic) IBOutlet UILabel *orderName;
@property (weak, nonatomic) IBOutlet CopyFounctionLabel *orderId;
@property (strong, nonatomic) UILabel *payType;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic)  UIImageView *iconext;
//-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void)initWithData:(OrderPayListData *)orderPayListData;

@end
