//
//  ItemImage.m
//  RestApp
//
//  Created by zxh on 14-4-18.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ItemImage.h"
#import "NSString+Estimate.h"
#import "UIView+Sizes.h"
#import "SDWebImageDownloader.h"
#import "UIImageView+WebCache.h"


@implementation ItemImage

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"ItemImage" owner:self options:nil];
    [self addSubview:self.view];
}

- (void)initView:(NSString *)filePath
{
    self.filePath=filePath;
    if([NSString isBlank:filePath]){
        [self.view setHeight:[self getHeight]];
        [self setHeight:[self getHeight]];
    }else{
         [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString urlFilterRan:filePath]] placeholderImage:[UIImage imageNamed:@"img_default.png"]];
    }
    [self.view setHeight:[self getHeight]];
    [self setHeight:[self getHeight]];
}

- (float) getHeight{
    if([NSString isBlank:self.filePath]){
        [self.btn setAlpha:0];
        [self.imgBtn setAlpha:0];
        [self.imgView setAlpha:0];
        return 0;
    }else{
        [self.btn setAlpha:1];
        [self.imgBtn setAlpha:1];
        [self.imgView setAlpha:1];
        return 210;
    }
}

-(IBAction)onDelClick:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"您确认要删除当前的图片吗？", nil) delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确认", nil),NSLocalizedString(@"取消", nil), nil];
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
    ;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //获取点击按钮的标题
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:NSLocalizedString(@"确认", nil)])
    {
        [self.delegate delImg:self.objId];
    }
}

        
@end
