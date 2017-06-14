//
//  TDFOptionTableViewController.m
//  TDFTools
//
//  Created by Octree on 16/8/16.
//  Copyright © 2016年 Octree. All rights reserved.
//

#import "TDFOptionTableViewController.h"
#import "TDFOptionSelectCell.h"
#import "TDFOptionSelectController.h"
#import "BackgroundHelper.h"

@interface TDFOptionTableViewController ()

@property (strong, nonatomic) UIImageView *backgroundImageView;

@end

@implementation TDFOptionTableViewController

@synthesize options = _options;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.allowsMultipleSelection = YES;
    [self.tableView registerClass:[TDFOptionSelectCell class] forCellReuseIdentifier:@"TDFOptionSelectCell"];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.selectedIndexs.count];
    for (NSNumber *index in self.selectedIndexs) {
        
        [arr addObject:[NSIndexPath indexPathForRow:[index integerValue] inSection:0]];
    }
    
    [self selectRowAtIndexPaths:arr];
    self.title = NSLocalizedString(@"请选择", nil);
    
    self.tableView.backgroundView = self.backgroundImageView;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.options.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TDFOptionSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TDFOptionSelectCell"
                                                            forIndexPath:indexPath];

    NSParameterAssert([self.options[ indexPath.row ] conformsToProtocol:@protocol(TDFOptionSelectPresentable)]);
    
    id<TDFOptionSelectPresentable> presenter = (id<TDFOptionSelectPresentable>)self.options[ indexPath.row ];
    cell.titleLabel.text = presenter.optionTitle;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 88;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self updateSelectedIndexs];
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self updateSelectedIndexs];
}


#pragma mark - Private Methods


- (void)updateSelectedIndexs {
    
    NSArray *indexPaths = self.tableView.indexPathsForSelectedRows;
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity: indexPaths.count];
    
    for (NSIndexPath *indexPath in indexPaths) {
        
        [arr addObject:@(indexPath.row)];
    }
    
    _selectedIndexs = [arr copy];
}

- (void)deselectRowAtIndexPaths:(NSArray *)indexPaths {

    for (NSIndexPath *indexPath in indexPaths) {
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

- (void)selectRowAtIndexPaths:(NSArray *)indexPaths {

    for (NSIndexPath *indexPath in indexPaths) {
        
        [self.tableView selectRowAtIndexPath:indexPath
                                    animated:NO
                              scrollPosition:UITableViewScrollPositionNone];
    }
}

#pragma mark - Accessor

- (void)setOptions:(NSArray *)options {

    if (_options != options) {
    
        _options = [options copy];
    }
    
    [self.tableView reloadData];
}


- (void)setSelectedIndexs:(NSArray<NSNumber *> *)selectedIndexs {

    if (_selectedIndexs != selectedIndexs) {
    
        _selectedIndexs = [selectedIndexs copy];
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:selectedIndexs.count];
        for (NSNumber *index in selectedIndexs) {
            
            [arr addObject:[NSIndexPath indexPathForRow:[index integerValue] inSection:0]];
        }
    
        [self deselectRowAtIndexPaths:self.tableView.indexPathsForSelectedRows];
        [self selectRowAtIndexPaths:arr];
    }
}


- (UIImageView *)backgroundImageView {

    if (!_backgroundImageView) {
    
        _backgroundImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backgroundImageView.image = [UIImage imageNamed:[BackgroundHelper getBackgroundImage]];
    }
    
    return _backgroundImageView;
}


@end
