//
//  OrderBox.m
//  RestApp
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "OrderBox.h"
#import "OrderGuiGeView.h"
#import "UIView+Sizes.h"
@implementation OrderBox


-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"OrderBox" owner:self options:nil];
    [self addSubview:self.view];
    
   
}


-(void)createIteam:(NSArray *)arry
{
    [self  removeview];
    for (NSInteger i=0; i<arry.count; i++) {
        OrderGuiGeView *iteam =[[OrderGuiGeView alloc]init];
        [iteam setTop:130*i];
        [self.view addSubview:iteam];
        iteam.backgroundColor =[UIColor blackColor];
        [iteam awakeFromNib];
        NSLog(@"%@",iteam);
        
    }
    
}

-(CGFloat )getHeight
{
    return self.view.bottom;
}
-(void)removeview
{
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
}
@end
