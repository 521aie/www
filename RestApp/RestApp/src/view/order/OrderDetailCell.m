//
//  OrderDetailCell.m
//  RestApp
//
//  Created by apple on 16/4/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "OrderDetailCell.h"

@implementation OrderDetailCell

-(void)initarry:(OrderDetailWeight *)iteam delegate:(id<IEditItemListEvent>)delegate tag:(NSInteger)tag iteamTag:(NSInteger)row
{
   
  
    self.selectview.tag =row;
    [self.selectview initLabel:NSLocalizedString(@"菜肴份量", nil) withHit:@"" delegate:delegate];
    NSString *str ;
    if (iteam.specWeight ==1) {
        str =NSLocalizedString(@"标准菜量", nil);
    }
    if (iteam.specWeight ==0) {
        str =NSLocalizedString(@"极小份", nil);
    }
    if (iteam.specWeight >1) {
        str =NSLocalizedString(@"特大量", nil);
    }
    [self.selectview initData:str withVal:@""];
     self.hideview.tag =row+3000;
    [self.hideview initLabel:NSLocalizedString(@"* 菜量相当于普通菜的几分", nil) withHit:@"" delegate:delegate];
    [self.hideview initData:[NSString stringWithFormat:@"%ld",iteam.specWeight] withVal:@""];
    [self loadTitle:iteam.specName];
}
-(void)loadTitle:(NSString *)title
{
    self.titileLbl.layer.cornerRadius=8;
    self.titileLbl.layer.masksToBounds=YES;
    self.titileLbl.layer.borderWidth=1;
    self.titileLbl.layer.borderColor=[[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.3] CGColor];
    self.titileLbl.text =title;
}
-(NSString *)getstr
{
    return [self.selectview getStrVal];
}
-(NSString *)getHideStr
{
    return [self.hideview getStrVal];
}

- (void)changedata:(NSString *)data withVal:(NSString *)val
{
     self.selectview.IsOrderSelect =1;
    [self.selectview changeData:data withVal:val];
}

- (void)cahngeTheData:(NSString *)data withVal:(NSString *)val
{
    [self.hideview initData:data withVal:val];
}
@end
