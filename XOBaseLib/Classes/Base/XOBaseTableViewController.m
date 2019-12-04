//
//  XOBaseTableViewController.m
//  XOBaseLib
//
//  Created by kenter on 2019/8/13.
//  Copyright © 2019 KENTER. All rights reserved.
//

#import "XOBaseTableViewController.h"
#import "UIView+frame.h"

@interface XOBaseTableViewController ()

@property (nonatomic, assign) UITableViewStyle                  style;

@property (nonatomic, strong) UIView                            *backgroundView;
@property (nonatomic, strong) UIImageView                       *backgroundImageView;
@property (nonatomic, strong) UILabel                           *backgroundTitleLabel;

@end

@implementation XOBaseTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        self.style = style;
        self.showBackgroundView = NO;
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
    if (self.showBackgroundView) {
        CGFloat backgroundViewY = self.tableView.tableHeaderView == nil ? 0 : self.tableView.tableHeaderView.bottom;
        CGFloat backgroundViewH = self.tableView.height - self.tableView.tableHeaderView.height - self.tableView.tableFooterView.height;
        self.tableView.backgroundView.frame = CGRectMake(0, backgroundViewY, self.tableView.width, backgroundViewH);
        
        self.backgroundImageView.frame = self.backgroundView.bounds;
        CGSize imageSize = self.backgroundImage.size;
        CGFloat titleY = self.backgroundView.height/2.0 + imageSize.height/2.0 + 10;
        self.backgroundTitleLabel.frame = CGRectMake(10, titleY, self.backgroundView.width - 20, 20);
        
        // 显示 or 隐藏 tableView的backgroundView
        if (UITableViewStyleGrouped == self.tableView.style) {
            NSInteger sectionNumber = [self.tableView numberOfSections];
            if (sectionNumber > 0) self.backgroundView.hidden = YES;
            else self.backgroundView.hidden = NO;
        }
        else if (UITableViewStylePlain == self.tableView.style) {
            NSInteger sectionNumber = [self.tableView numberOfSections];
            if (sectionNumber <= 0) {
                self.backgroundView.hidden = YES;
            }
            else {
                NSInteger rowNumber = [self.tableView numberOfRowsInSection:0];
                if (rowNumber > 0) self.backgroundView.hidden = YES;
                else self.backgroundView.hidden = NO;
            }
        }
    }
    else {
        if (_backgroundView) {
            _backgroundView.frame = CGRectZero;
        }
        if (_backgroundImageView) {
            _backgroundImageView.frame = CGRectZero;
        }
        if (_backgroundTitleLabel) {
            _backgroundTitleLabel.frame = CGRectZero;
        }
    }
}

#pragma mark ========================= lazy load =========================

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:self.style];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.view addSubview:self->_tableView];
        }];
    }
    return _tableView;
}

- (UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor clearColor];
    }
    return _backgroundView;
}

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.contentMode = UIViewContentModeCenter;
    }
    return _backgroundImageView;
}

- (UIView *)backgroundTitleLabel
{
    if (!_backgroundTitleLabel) {
        _backgroundTitleLabel = [[UILabel alloc] init];
        _backgroundTitleLabel.textColor = [UIColor darkGrayColor];
        _backgroundTitleLabel.textAlignment = NSTextAlignmentCenter;
        _backgroundTitleLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _backgroundTitleLabel;
}

#pragma mark ========================= setter & getter =========================

- (void)setShowBackgroundView:(BOOL)showBackgroundView
{
    _showBackgroundView = showBackgroundView;
    
    if (_showBackgroundView) {
        [self.backgroundView addSubview:self.backgroundImageView];
        [self.backgroundView addSubview:self.backgroundTitleLabel];
        
        self.tableView.backgroundView = self.backgroundView;
    }
    else {
        self.tableView.backgroundView = nil;
    }
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    
    if (self.showBackgroundView) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.backgroundImageView.image = backgroundImage;
        }];
    }
}

- (void)setBackgroundTitle:(NSString *)backgroundTitle
{
    _backgroundTitle = [backgroundTitle copy];
    
    if (self.showBackgroundView) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.backgroundTitleLabel.text = self->_backgroundTitle;
        }];
    }
}

#pragma mark ========================= UITableViewDataSource =========================

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        NSInteger rowNumber = [self tableView:tableView numberOfRowsInSection:section];
        return rowNumber;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (void)refreshByGenralSettingChange:(XOGenralChangeType)genralType userInfo:(NSDictionary *)userInfo
{
    if (_tableView) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self->_tableView reloadData];
        }];
    }
}


@end
