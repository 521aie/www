//
//  EditItemQr.h
//  RestApp
//
//  Created by zxh on 14-10-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Seat.h"
#import "KabawService.h"

@interface SeatItemQr : UIView<UIActionSheetDelegate>

{
    KabawService *service;
}
@property (nonatomic, strong) IBOutlet UIView *view;

@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UIImageView *img;
@property (nonatomic, strong) IBOutlet UITextView *lblDetail;
@property (nonatomic, strong) IBOutlet UIView *line;

@property (nonatomic,retain) Seat* seat;

- (void)initLabel:(NSString*)label withHit:(NSString *)_hit;

- (void)loadSeat:(Seat*)seat;
//- (void)loadSeat:(Seat*)seat content:(NSString*)content;
- (IBAction)btnSaveClick:(id)sender;

-(void) visibal:(BOOL)show;

@end
