//
//  CardBox.h
//  RestApp
//
//  Created by zxh on 14-11-4.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CardSampleVO;
@interface CardBoxView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *view;

@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UITableView *grid;
@property (nonatomic, strong) IBOutlet UIImageView *img;

@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblKind;
@property (nonatomic, strong) IBOutlet UILabel *lblCode;


@property (nonatomic, retain) NSMutableArray* datas;

- (void)loadData:(NSString*)title card:(CardSampleVO*)card;

@end
