//
//  TDFBarChartCollectionCell.m
//  RestApp
//
//  Created by guopin on 16/6/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFBarChartCollectionCell.h"
#import "UIView+Sizes.h"
@interface TDFBarChartCollectionCell()
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIView *markView;
@property (nonatomic, strong) UIView *redView;
@end
@implementation TDFBarChartCollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.redView  = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/4,0 , frame.size.width/2, 0)];
        [self addSubview:self.redView];
        
        self.whiteView  = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/4,0 , frame.size.width/2, 0)];
        [self addSubview:self.whiteView];
        
        self.markView  = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/4,self.bounds.size.height-15,frame.size.width/2, frame.size.width/2)];
        self.markView.layer.cornerRadius = 5;
        self.markView.layer.masksToBounds = 5 ;
        [self addSubview:self.markView];
        
    }
    return self;
}
-(void)initDataView:(TDFBarChartVo *)dataModel{
//    NSLog(@"%@+++++++%.2f-----%.2f",dataModel.key,dataModel.value,dataModel.value2);
      self.markView.backgroundColor = dataModel.isSelected?[UIColor redColor]:[UIColor colorWithWhite:1 alpha:0.3];
      [self.whiteView setHeight:  (self.bounds.size.height *0.9 - 10)*(dataModel.value-dataModel.value2)/dataModel.maxValue];
      [self.whiteView setBottom:self.bounds.size.height *0.9 - 5];
      self.whiteView.backgroundColor =  dataModel.isSelected?[UIColor whiteColor]:[UIColor colorWithWhite:1 alpha:0.3];

      [self.redView setHeight:  (self.bounds.size.height *0.9 - 10)*dataModel.value2/dataModel.maxValue];
      [self.redView setBottom:self.bounds.size.height *0.9 - 5 - self.whiteView.height];
      self.redView.backgroundColor =  [UIColor redColor];
      self.redView.alpha = dataModel.isSelected ? 1.0f:0.3f;

}
@end
